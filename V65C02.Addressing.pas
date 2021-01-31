{
  V65C02.Addressing.pas
    65C02 Emulator - Addressing modes

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

unit V65C02.Addressing;

interface

uses
  V65C02.Device,
  V65C02.CPU;

type
  TAddressProc = function(Machine: T65C02): Word;

  PAddressLUT = ^TAddressLUT;
  TAddressLUT = record
    Name:   String[32];
    Format: String[16];
    Proc:   TAddressProc;
  end;

  TAddressMode = (amIMP, amACC, amIMM, amZER, amZEX, amZEY, amREL, amABS,
                  amABX, amABY, amAIN, amINX, amINY);

function AddressProcIMP(Machine: T65C02): Word;
function AddressProcACC(Machine: T65C02): Word;
function AddressProcIMM(Machine: T65C02): Word;
function AddressProcZER(Machine: T65C02): Word;
function AddressProcZEX(Machine: T65C02): Word;
function AddressProcZEY(Machine: T65C02): Word;
function AddressProcREL(Machine: T65C02): Word;
function AddressProcABS(Machine: T65C02): Word;
function AddressProcABX(Machine: T65C02): Word;
function AddressProcABY(Machine: T65C02): Word;
function AddressProcAIN(Machine: T65C02): Word;
function AddressProcINX(Machine: T65C02): Word;
function AddressProcINY(Machine: T65C02): Word;
// TODO: Absolute indexed indirect (JMP extension)

const
  AddressMode: array[TAddressMode] of TAddressLUT = (
    (Name:'Implicit';          Format:'';        Proc:AddressProcIMP),
    (Name:'Accumulator';       Format:'A';       Proc:AddressProcACC),
    (Name:'Immediate';         Format:'#%1';     Proc:AddressProcIMM),
    (Name:'Zero Page';         Format:'%1';      Proc:AddressProcZER),
    (Name:'Zero Page, X';      Format:'%1, X';   Proc:AddressProcZEX),
    (Name:'Zero Page, Y';      Format:'%1, Y';   Proc:AddressProcZEY),
    (Name:'Relative';          Format:'%1';      Proc:AddressProcREL),
    (Name:'Absolute';          Format:'%1';      Proc:AddressProcABS),
    (Name:'Absolute, X';       Format:'%1, X';   Proc:AddressProcABX),
    (Name:'Absolute, Y';       Format:'%1, Y';   Proc:AddressProcABY),
    (Name:'Absolute Indirect'; Format:'(%1)';    Proc:AddressProcAIN),
    (Name:'Indexed Indirect';  Format:'(%1, X)'; Proc:AddressProcINX),
    (Name:'Indirect Indexed';  Format:'(%1), Y'; Proc:AddressProcINY)
  );

implementation

function AddressProcIMP;
begin
  Result := 0;
end;

function AddressProcACC;
begin
  Result := 0;//Machine.Registers.A;
end;

function AddressProcIMM;
begin
  Result := Machine.Registers.PC;
  Inc(Machine.Registers.PC);
end;

function AddressProcZER;
begin
  Result := Machine.ReadByte(Machine.Registers.PC);
  Inc(Machine.Registers.PC);
end;

function AddressProcZEX;
begin
  Result := (AddressProcZER(Machine) + Machine.Registers.X) mod 256;
end;

function AddressProcZEY;
begin
  Result := (AddressProcZER(Machine) + Machine.Registers.Y) mod 256;
end;

function AddressProcREL;
begin
  var Offset: Word := AddressProcZER(Machine);

  if (Offset and $80) <> 0 then
    Offset := Offset or $FF00;

  Result := Machine.Registers.PC + Offset;
end;

function AddressProcABS;
begin
  Result := Machine.ReadWord(Machine.Registers.PC);
  Inc(Machine.Registers.PC, 2);
end;

function AddressProcABX;
begin
  Result := AddressProcABS(Machine);
  var Page: Word := Result and $FF00;
  Result := Result + Machine.Registers.X;

  Machine.PageCrossed := Page <> (Result and $FF00);
end;

function AddressProcABY;
begin
  Result := AddressProcABS(Machine);
  var Page: Word := Result and $FF00;
  Result := Result + Machine.Registers.Y;

  Machine.PageCrossed := Page <> (Result and $FF00);
end;

function AddressProcAIN;
begin
  var Addr: Word := AddressProcABS(Machine);

  var EffL: Word := Machine.ReadByte(Addr);
  var EffH: Word := Machine.ReadByte((Addr and $FF00) + ((Addr + 1) and $00FF));

  Result := EffL + $100 * EffH;
end;

function AddressProcINX;
begin
  var ZeroL: Word := AddressProcZEX(Machine);
  var ZeroH: Word := (ZeroL + 1) mod 256;

  Result := Machine.ReadByte(ZeroL) + (Machine.ReadByte(ZeroH) shl 8);
end;

function AddressProcINY;
begin
  var ZeroL: Word := AddressProcZER(Machine);
  var ZeroH: Word := (ZeroL + 1) mod 256;

  Result := Machine.ReadByte(ZeroL) + (Machine.ReadByte(ZeroH) shl 8);
  var Page: Word := Result and $FF00;
  Result := Result + Machine.Registers.Y;

  Machine.PageCrossed := Page <> (Result and $FF00);
end;

end.

