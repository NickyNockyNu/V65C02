program Test;

{$APPTYPE CONSOLE}

uses
  V65C02.Addressing in '..\V65C02.Addressing.pas',
  V65C02.CPU in '..\V65C02.CPU.pas',
  V65C02.Device in '..\V65C02.Device.pas',
  V65C02.Instructions in '..\V65C02.Instructions.pas',
  V65C02.Memory in '..\V65C02.Memory.pas',
  V65C02.Registers in '..\V65C02.Registers.pas';

var
  CPU: T65C02;
  RAM: T65C02MemoryDevice;

procedure WriteRegs;
begin
  Write(#9'PC=', CPU.Registers.PC);
  Write(#0'SP=', CPU.Registers.SP);
  Write(#9'A=', CPU.Registers.A);
  Write(#9'X=', CPU.Registers.X);
  Write(#9'Y=', CPU.Registers.Y);
  Write(#9'Status=', CPU.Registers.Status, #13#10);
end;

begin
  Writeln('V65C02 functional test');

  CPU := T65C02.Create;
  RAM := T65C02MemoryDevice.Create(0, 65536);

  CPU.AddDevice(RAM);

  // https://github.com/Klaus2m5/6502_65C02_functional_tests
  Writeln('Loaded ', RAM.Load('6502_functional_test.bin'), ' bytes');

  CPU.ResetVector := $0400;
  CPU.Reset;

  var test_num := $FF;

  repeat
    if CPU.ReadByte($200) <> test_num then
    begin
      test_num := CPU.ReadByte($200);

      Write('test_num=', test_num, ' ');
      WriteRegs;
    end;

    var PC := CPU.Registers.PC;

    CPU.Step;

    if CPU.Registers.PC = PC then
    begin
      WriteLn('/!\ Failed');
      WriteRegs;

      Break;
    end;
  until CPU.IllegalOp or (CPU.Registers.PC = $3399);

  Write('Done');
  ReadLn;
end.

