{
  V65C02.Registers.pas
    65C02 Emulator - Registers

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

unit V65C02.Registers;

interface

const
  // Status register flag masks
  StatusCarry:     Byte = 1 shl 0;
  StatusZero:      Byte = 1 shl 1;
  StatusInterrupt: Byte = 1 shl 2;
  StatusDecimal:   Byte = 1 shl 3;
  StatusBreak:     Byte = 1 shl 4;
  StatusConstant:  Byte = 1 shl 5;
  StatusOverflow:  Byte = 1 shl 6;
  StatusNegative:  Byte = 1 shl 7;

type
  TRegisters = record
  private
    function  GetFlags(Mask: Byte): Boolean;        inline;
    procedure SetFlags(Mask: Byte; Value: Boolean); inline;
  public
    PC:     Word;
    SP:     Byte;
    A:      Byte;
    X, Y:   Byte;
    Status: Byte;

    function AsString: String;

    function CarryOne: Byte; inline;

    property Flags[Mask: Byte]: Boolean read GetFlags write SetFlags; default;
  end;

implementation

function TRegisters.GetFlags;
begin
  Result := (Status and Mask) <> 0
end;

procedure TRegisters.SetFlags;
begin
  if Value then
    Status := Status or Mask
  else
    Status := Status and (not Mask);
end;

function TRegisters.CarryOne: Byte;
begin
  if Flags[StatusCarry] then
    Result := 1
  else
    Result := 0;
end;

function TRegisters.AsString: String;
begin
  // TODO: Registers string
  Result := '';
end;

end.

