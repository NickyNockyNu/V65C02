unit V65C02.Form;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,

  V65C02.Device,
  V65C02.Memory,
  V65C02.Registers,
  V65C02.Instructions,
  V65C02.Addressing,
  V65C02.CPU;

type
  TV65C02Form = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

  public
    CPU: T65C02;
    Mem: T65C02MemoryDevice;
  end;

var
  V65C02Form: TV65C02Form;

implementation

{$R *.dfm}

procedure TV65C02Form.FormCreate(Sender: TObject);
var
  LastPC:   Word;
  LastTest: Byte;
begin
  CPU := T65C02.Create;
  Mem := T65C02MemoryDevice.Create;

  CPU.AddDevice(Mem);

  AllocConsole;

  Writeln(Mem.Load('6502_functional_test.bin'));

  CPU.ResetVector := $0400;

  CPU.Reset;

  LastTest := $FF;

  repeat
    LastPC := CPU.Registers.PC;
    if CPU.ReadByte($200) <> LastTest then
    begin
      LastTest := CPU.ReadByte($200);
      Writeln('test case ' + LastTest.ToString + ' at $' +IntToHex(CPU.Registers.PC, 4));
      //Readln;
    end;

    // Run 1 instruction
    //Writeln('A:', CPU.Registers.A, ' X:', CPU.Registers.X, ' Y:', CPU.Registers.Y, ' PC:', IntTohex(CPU.Registers.PC, 4), ' SP:', CPU.Registers.SP, ' Status:', CPU.Registers.Status, ' CarryOne:', CPU.Registers.CarryOne, ' Instr:', IntToHex(CPU.CurrentOp, 2));
    CPU.Step;
  until (CPU.IllegalOp) or (CPU.Registers.PC = LastPC) or (CPU.Registers.PC = $3399);

  if CPU.Registers.PC = $3399 then
    writeln('test successful')
  else
    writeln('failed at ' + IntToHex(CPU.Registers.PC, 4));

end;

end.

