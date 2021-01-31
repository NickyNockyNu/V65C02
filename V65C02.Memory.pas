{
  V65C02.Memory.pas
    65C02 Emulator - Memory (RAM/ROM) device

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

unit V65C02.Memory;

interface

uses
  System.SysUtils,
  System.Classes,

  V65C02.Device;

type
  T65C02MemoryDevice = class(T65C02Device)
  protected
    FCanRead:  Boolean;
    FCanWrite: Boolean;
  public
    Memory: array of Byte;

    constructor Create(const ABase: Word = 0; const ASize: Integer = 65536);

    function  ReadByte (AAddress: Word): Byte;         override;
    procedure WriteByte(AAddress: Word; AValue: Byte); override;

    function Load(const AFileName: String; const ABase: Word = 0): Integer;

    property CanRead:  Boolean read FCanRead  write FCanRead;
    property CanWrite: Boolean read FCanWrite write FCanWrite;
  end;

implementation

constructor T65C02MemoryDevice.Create(const ABase: Word = 0; const ASize: Integer = 65536);
begin
  inherited Create;

  FAddressBase := ABase;
  FAddressSize := ASize;

  SetLength(Memory, ASize);

  FCanRead  := True;
  FCanWrite := True;
end;

function T65C02MemoryDevice.ReadByte;
begin
  Result := inherited;

  if FCanRead and (AAddress < FAddressSize) then
    Result := Memory[AAddress];
end;

procedure T65C02MemoryDevice.WriteByte;
begin
  inherited;

  if FCanWrite and (AAddress < FAddressSize) then
    Memory[AAddress] := AValue;
end;

function T65C02MemoryDevice.Load;
begin
  try
    with TFileStream.Create(AFileName, fmOpenRead) do try
      Result := Size;

      if (ABase + Result) > FAddressSize then
        Result := FAddressSize - ABase;

      Result := Read(Memory[ABase], Result);
    finally
      Free;
    end;
  except
    Result := -1;
  end;
end;

end.

