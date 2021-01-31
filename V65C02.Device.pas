{
  V65C02.Device.pas
    65C02 Emulator - Base device class

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

unit V65C02.Device;

interface

type
  T65C02Device = class
  private
    FHostDevice: T65C02Device;

    FBytesRead:  Integer;
    FBytesWrite: Integer;
    FInterrupts: Integer;
    FSteps:      Integer;

    FLock: Integer;
  protected
    FAddressBase: Word;
    FAddressSize: Integer;
  public
    constructor Create;
    destructor  Destroy; override;

    function AsString: String; virtual;

    procedure Reset; virtual;

    function  ReadByte (AAddress: Word): Byte;         virtual;
    procedure WriteByte(AAddress: Word; AValue: Byte); virtual;

    function  ReadWord (AAddress: Integer): Word;         inline;
    procedure WriteWord(AAddress: Integer; AValue: Word); inline;

    procedure IRQ; virtual;
    procedure NMI; virtual;

    function Step:  Byte; virtual;
    function Yield: Byte;

    procedure Lock;   inline;
    procedure Unlock; inline;

    function Enabled: Boolean; inline;

    property HostDevice: T65C02Device read FHostDevice write FHostDevice;

    property BytesRead:  Integer read FBytesRead;
    property BytesWrite: Integer read FBytesWrite;

    property Interrupts: Integer read FInterrupts;
    property Steps:      Integer read FSteps;

    property AddressBase: Word    read FAddressBase;
    property AddressSize: Integer read FAddressSize;
  end;

implementation

constructor T65C02Device.Create;
begin
  inherited;

  FAddressBase := 0;
  FAddressSize := $FFFF;

  FHostDevice := nil;

  Reset;
end;

destructor T65C02Device.Destroy;
begin
  inherited;
end;

function T65C02Device.AsString;
begin
  Result := ClassName;
end;

procedure T65C02Device.Reset;
begin
  FBytesRead  := 0;
  FBytesWrite := 0;
  FInterrupts := 0;
  FSteps      := 0;
  FLock       := 0;
end;

function T65C02Device.ReadByte;
begin
  Inc(FBytesRead);
  Result := 0;
end;

procedure T65C02Device.WriteByte;
begin
  Inc(FBytesWrite);
end;

function T65C02Device.ReadWord;
begin
  Result := (ReadByte(AAddress + 1) shl 8) + ReadByte(AAddress);
end;

procedure T65C02Device.WriteWord;
begin
  WriteByte(AAddress,      AValue        and $FF);
  WriteByte(AAddress + 1, (AValue shr 8) and $FF);
end;

procedure T65C02Device.IRQ;
begin
  Inc(FInterrupts);
end;

procedure T65C02Device.NMI;
begin
  Inc(FInterrupts);
end;

function T65C02Device.Step;
begin
  Inc(FSteps);
  Result := 0;
end;

function T65C02Device.Yield;
begin
  if FHostDevice = nil then
    Exit(0);

  Lock;
  try
    Result := FHostDevice.Step;
  finally
    Unlock;
  end;
end;

procedure T65C02Device.Lock;
begin
  Inc(FLock);
end;

procedure T65C02Device.Unlock;
begin
  if FLock > 0 then Dec(FLock);
end;

function T65C02Device.Enabled;
begin
  Result := FLock = 0;
end;

end.

