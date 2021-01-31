{
  V65C02.CPU.pas
    65C02 Emulator - CPU

    Copyright © 2021 Nicholas Smith

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

unit V65C02.CPU;

interface

uses
  V65C02.Device,
  V65C02.Memory,
  V65C02.Registers;

const
  IRQVectorAddress   = $FFFE;
  NMIVectorAddress   = $FFFA;
  ResetVectorAddress = $FFFC;

type
  T65C02 = class(T65C02Device)
  private
    FDevices: array of T65C02Device;

    //FZeroPage: T65C02MemoryDevice;
    //FStack:    T65C02MemoryDevice;

    FCycles: Cardinal;

    FCurrentOp: Byte;

    FModeAcc:     Boolean;

    FIllegalOp:   Boolean;
    FPageCrossed: Boolean;
    FBranched:    Boolean;
  public
    Registers: TRegisters;

    constructor Create;
    destructor  Destroy; override;

    function AddDevice(ADevice: T65C02Device): T65C02Device;

    function  ReadByte (AAddress: Word): Byte;         override;
    procedure WriteByte(AAddress: Word; AValue: Byte); override;

    procedure StackPush(AValue: Byte); inline;
    function  StackPull: Byte;         inline;

    procedure IRQ; override;
    procedure NMI; override;

    procedure Reset; override;

    function Step: Byte; override;

    property NMIVector:   Word index NMIVectorAddress   read ReadWord write WriteWord;
    property ResetVector: Word index ResetVectorAddress read ReadWord write WriteWord;
    property IRQVector:   Word index IRQVectorAddress   read ReadWord write WriteWord;

    //property ZeroPage: T65C02MemoryDevice read FZeroPage;
    //property Stack:    T65C02MemoryDevice read FStack;

    property Cycles: Cardinal read fCycles;

    property CurrentOp: Byte read fCurrentOp;

    property ModeAcc: Boolean read fModeAcc;

    property IllegalOp: Boolean read fIllegalOp;

    property PageCrossed: Boolean read fPageCrossed write fPageCrossed;
    property Branched:    Boolean read fBranched    write fBranched;
  end;

implementation

uses
  V65C02.Addressing,
  V65C02.Instructions;

constructor T65C02.Create;
begin
  inherited Create;

  FAddressBase := 0;
  FAddressSize := $FFFF;

  //FZeroPage := T65C02MemoryDevice.Create($0000, $FF);
  //FStack    := T65C02MemoryDevice.Create($0100, $FF);

  //AddDevice(FZeroPage);
  //AddDevice(FStack);
end;

destructor T65C02.Destroy;
begin
  inherited;
end;

function T65C02.AddDevice;
begin
  SetLength(FDevices, Length(FDevices) + 1);
  FDevices[high(FDevices)] := ADevice;

  ADevice.HostDevice := Self;

  Result := ADevice;

  // TODO: Check for and warn on IO range conflicts
end;

function T65C02.ReadByte;
begin
  Result := inherited ReadByte(AAddress);

  for var Device in FDevices do
    if Device.Enabled and (Device.AddressSize > 0) and (AAddress >= Device.AddressBase) and (AAddress <= (Device.AddressBase + Device.AddressSize - 1)) then
      Exit(Device.ReadByte(AAddress - Device.AddressBase));
end;

procedure T65C02.WriteByte;
begin
  inherited WriteByte(AAddress, AValue);

  for var Device in FDevices do
    if Device.Enabled and (Device.AddressSize > 0) and (AAddress >= Device.AddressBase) and (AAddress <= (Device.AddressBase + Device.AddressSize - 1)) then
      Device.WriteByte(AAddress - Device.AddressBase, AValue);
end;

procedure T65C02.StackPush;
begin
  //FStack.WriteByte(Registers.SP, AValue);
  WriteByte($100 + Registers.SP, AValue);

  if Registers.SP = 0 then
    Registers.SP := $FF
  else
    Dec(Registers.SP);
end;

function T65C02.StackPull;
begin
  if Registers.SP = $FF then
    Registers.SP := 0
  else
    Inc(Registers.SP);

  //Result := FStack.ReadByte(Registers.SP);
  Result := ReadByte($100 + Registers.SP);
end;

procedure T65C02.IRQ;
begin
  for var Device in FDevices do
    if Device.Enabled then Device.IRQ;

  if not Enabled then
    Exit;

  if Registers[StatusInterrupt] then
    Exit;

  Registers[StatusBreak] := False;

  StackPush((Registers.PC shr 8) and $FF);
  StackPush( Registers.PC        and $FF);

  StackPush(Registers.Status);

  Registers[StatusInterrupt] := True;
  Registers.PC := IRQVector;

  Inc(FCycles, 7);

  inherited;
end;

procedure T65C02.NMI;
begin
  for var Device in FDevices do
    if Device.Enabled then Device.NMI;

  if not Enabled then
    Exit;

  Registers[StatusBreak] := False;

  StackPush((Registers.PC shr 8) and $FF);
  StackPush( Registers.PC        and $FF);

  StackPush(Registers.Status);

  Registers[StatusInterrupt] := True;
  Registers.PC  := NMIVector;

  Inc(FCycles, 7);

  inherited;
end;

procedure T65C02.Reset;
begin
  inherited;

  Registers.PC := ResetVector;
  Registers.SP := $FF;

  Registers.A := $AA;
  Registers.X := $00;
  Registers.Y := $00;

  Registers.Status := StatusBreak or StatusInterrupt or StatusZero or StatusConstant;

  FCurrentOp := $02;

  FIllegalOp   := False;
  FPageCrossed := False;
  FBranched    := False;

  FCycles := 6;

  for var Device in fDevices do
    Device.Reset;
end;

function T65C02.Step;
begin
  for var Device in FDevices do
    if Device.Enabled then Device.Step;

  if not Enabled then
    Exit(0);

  FCurrentOp := ReadByte(Registers.PC);

  FModeAcc     := False;
  FPageCrossed := False;
  FBranched    := False;

  var OpCode: POpCodeLUT := @OpCodes[FCurrentOp];

  FIllegalOp := OpCode^.Instruction = inNIL;
  if FIllegalOp then
    Exit(0);

  Inc(Registers.PC);

  FModeAcc := OpCode^.Mode = amACC;

  Instructions[OpCode^.Instruction].Proc(Self, AddressMode[OpCode^.Mode].Proc(Self));

  Result := Inherited + OpCode^.Ticks;

  case OpCode^.Penalty of
    ipPageCross:
      if FPageCrossed then
        Inc(Result);

    ipBranch:
      if FBranched then
      begin
        Inc(Result);

        if FPageCrossed then
          Inc(Result)
      end;
  end;

  Inc(FCycles, Result);
end;

end.

