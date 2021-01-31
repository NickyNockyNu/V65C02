{
  V65C02.Instructions.pas
    65C02 Emulator - Instructions

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

unit V65C02.Instructions;

interface

uses
  V65C02.Device,
  V65C02.Memory,
  V65C02.Registers,
  V65C02.CPU,
  V65C02.Addressing;

type
  TInstructionProc = procedure(Machine: T65C02; Src: Word);

  TInstructionPenalty = (ipNone, ipPageCross, ipBranch);

  TInstruction = (inADC, inAND, inASL, inBBR, inBSS, inBCC, inBCS, inBEQ, inBIT, inBMI,
                  inBNE, inBPL, inBRA, inBRK, inBVC, inBVS, inCLC, inCLD, inCLI, inCLV,
                  inCMP, inCPX, inCPY, inDEC, inDEX, inDEY, inEOR, inINC, inINX, inINY,
                  inJMP, inJSR, inLDA, inLDX, inLDY, inLSR, inNOP, inORA, inPHA, inPHP,
                  inPHX, inPHY, inPLA, inPLP, inPLX, inPLY, inRMB, inROL, inROR, inRTI,
                  inSTZ, inTAX, inTAY, inTRB, inTSB, inTSX, inTXA, inTXS, inTYA, inWAI,
                  inSEC, inRTS, inSEI, inSTA, inSTY, inSTX, inSBC, inSED, inNIL);

  PInstructionLUT = ^TInstructionLUT;
  TInstructionLUT = record
    Proc:   TInstructionProc;
    Format: String[3];
    Name:   String[32];
  end;

  POpCodeLUT = ^TOpCodeLUT;
  TOpCodeLUT = record
    Mode:        TAddressMode;
    Instruction: TInstruction;
    Ticks:       Byte;
    Penalty:     TInstructionPenalty;
  end;

procedure InstructionADC(Machine: T65C02; Src: Word);
procedure InstructionAND(Machine: T65C02; Src: Word);
procedure InstructionASL(Machine: T65C02; Src: Word);
procedure InstructionBCC(Machine: T65C02; Src: Word);
procedure InstructionBCS(Machine: T65C02; Src: Word);

procedure InstructionBEQ(Machine: T65C02; Src: Word);
procedure InstructionBIT(Machine: T65C02; Src: Word);
procedure InstructionBMI(Machine: T65C02; Src: Word);
procedure InstructionBNE(Machine: T65C02; Src: Word);
procedure InstructionBPL(Machine: T65C02; Src: Word);
procedure InstructionBRA(Machine: T65C02; Src: Word);

procedure InstructionBRK(Machine: T65C02; Src: Word);
procedure InstructionBVC(Machine: T65C02; Src: Word);
procedure InstructionBVS(Machine: T65C02; Src: Word);
procedure InstructionCLC(Machine: T65C02; Src: Word);
procedure InstructionCLD(Machine: T65C02; Src: Word);

procedure InstructionCLI(Machine: T65C02; Src: Word);
procedure InstructionCLV(Machine: T65C02; Src: Word);
procedure InstructionCMP(Machine: T65C02; Src: Word);
procedure InstructionCPX(Machine: T65C02; Src: Word);
procedure InstructionCPY(Machine: T65C02; Src: Word);

procedure InstructionDEC(Machine: T65C02; Src: Word);
procedure InstructionDEX(Machine: T65C02; Src: Word);
procedure InstructionDEY(Machine: T65C02; Src: Word);
procedure InstructionEOR(Machine: T65C02; Src: Word);
procedure InstructionINC(Machine: T65C02; Src: Word);

procedure InstructionINX(Machine: T65C02; Src: Word);
procedure InstructionINY(Machine: T65C02; Src: Word);
procedure InstructionJMP(Machine: T65C02; Src: Word);
procedure InstructionJSR(Machine: T65C02; Src: Word);
procedure InstructionLDA(Machine: T65C02; Src: Word);

procedure InstructionLDX(Machine: T65C02; Src: Word);
procedure InstructionLDY(Machine: T65C02; Src: Word);
procedure InstructionLSR(Machine: T65C02; Src: Word);
procedure InstructionNOP(Machine: T65C02; Src: Word);
procedure InstructionORA(Machine: T65C02; Src: Word);

procedure InstructionPHA(Machine: T65C02; Src: Word);
procedure InstructionPHP(Machine: T65C02; Src: Word);
procedure InstructionPHX(Machine: T65C02; Src: Word);
procedure InstructionPHY(Machine: T65C02; Src: Word);
procedure InstructionPLA(Machine: T65C02; Src: Word);
procedure InstructionPLP(Machine: T65C02; Src: Word);
procedure InstructionPLX(Machine: T65C02; Src: Word);
procedure InstructionPLY(Machine: T65C02; Src: Word);
procedure InstructionROL(Machine: T65C02; Src: Word);

procedure InstructionROR(Machine: T65C02; Src: Word);
procedure InstructionRTI(Machine: T65C02; Src: Word);
procedure InstructionRTS(Machine: T65C02; Src: Word);
procedure InstructionSBC(Machine: T65C02; Src: Word);
procedure InstructionSEC(Machine: T65C02; Src: Word);
procedure InstructionSED(Machine: T65C02; Src: Word);

procedure InstructionSEI(Machine: T65C02; Src: Word);
procedure InstructionSTA(Machine: T65C02; Src: Word);
procedure InstructionSTX(Machine: T65C02; Src: Word);
procedure InstructionSTY(Machine: T65C02; Src: Word);
procedure InstructionSTZ(Machine: T65C02; Src: Word);
procedure InstructionTAX(Machine: T65C02; Src: Word);

procedure InstructionTAY(Machine: T65C02; Src: Word);
procedure InstructionTSX(Machine: T65C02; Src: Word);
procedure InstructionTXA(Machine: T65C02; Src: Word);
procedure InstructionTXS(Machine: T65C02; Src: Word);
procedure InstructionTYA(Machine: T65C02; Src: Word);

// TODO: Slightly more complicated as both parameters change
procedure InstructionBBR(Machine: T65C02; Src: Word);
procedure InstructionBSS(Machine: T65C02; Src: Word);
procedure InstructionRMB(Machine: T65C02; Src: Word);
procedure InstructionTRB(Machine: T65C02; Src: Word);
procedure InstructionTSB(Machine: T65C02; Src: Word);

// TODO: Wait for interrupt
procedure InstructionWAI(Machine: T65C02; Src: Word);

const
  Instructions: array[TInstruction] of TInstructionLUT = (
    (Proc:InstructionADC; Format:'ADC'; Name:'Add with Carry'),
    (Proc:InstructionAND; Format:'AND'; Name:'Logical AND'),
    (Proc:InstructionASL; Format:'ASL'; Name:'Arithmetic Shift Left'),
    (Proc:InstructionBBR; Format:'BBR'; Name:'Branch on Bit Reset'),
    (Proc:InstructionBSS; Format:'BSS'; Name:'Branch on Bit Set'),
    (Proc:InstructionBCC; Format:'BCC'; Name:'Branch if Carry Clear'),
    (Proc:InstructionBCS; Format:'BCS'; Name:'Branch if Carry Set'),
    (Proc:InstructionBEQ; Format:'BEQ'; Name:'Branch if Equal'),
    (Proc:InstructionBIT; Format:'BIT'; Name:'Bit Test'),
    (Proc:InstructionBMI; Format:'BMI'; Name:'Branch if Minus'),
    (Proc:InstructionBNE; Format:'BNE'; Name:'Branch if Not Equal'),
    (Proc:InstructionBPL; Format:'BPL'; Name:'Branch if Positive'),
    (Proc:InstructionBRA; Format:'BRA'; Name:'Branch Always'),
    (Proc:InstructionBRK; Format:'BRK'; Name:'Force Interrupt'),
    (Proc:InstructionBVC; Format:'BVC'; Name:'Branch if Overflow Clear'),
    (Proc:InstructionBVS; Format:'BVS'; Name:'Branch if Overflow Set'),
    (Proc:InstructionCLC; Format:'CLC'; Name:'Clear Carry Flag'),
    (Proc:InstructionCLD; Format:'CLD'; Name:'Clear Decimal Mode'),
    (Proc:InstructionCLI; Format:'CLI'; Name:'Clear Interrupt Disable'),
    (Proc:InstructionCLV; Format:'CLV'; Name:'Clear Overflow Flag'),
    (Proc:InstructionCMP; Format:'CMP'; Name:'Compare'),
    (Proc:InstructionCPX; Format:'CPX'; Name:'Compare X'),
    (Proc:InstructionCPY; Format:'CPY'; Name:'Compare Y'),
    (Proc:InstructionDEC; Format:'DEC'; Name:'Decrement Memory'),
    (Proc:InstructionDEX; Format:'DEX'; Name:'Decrememt X'),
    (Proc:InstructionDEY; Format:'DEY'; Name:'Decrememt Y'),
    (Proc:InstructionEOR; Format:'EOR'; Name:'Exclusive OR'),
    (Proc:InstructionINC; Format:'INC'; Name:'Increment Memory'),
    (Proc:InstructionINX; Format:'INX'; Name:'Increment X'),
    (Proc:InstructionINY; Format:'INY'; Name:'Increment Y'),
    (Proc:InstructionJMP; Format:'JMP'; Name:'Jump'),
    (Proc:InstructionJSR; Format:'JSR'; Name:'Jump to Subroutine'),
    (Proc:InstructionLDA; Format:'LDA'; Name:'Load A'),
    (Proc:InstructionLDX; Format:'LDX'; Name:'Load X'),
    (Proc:InstructionLDY; Format:'LDY'; Name:'Load Y'),
    (Proc:InstructionLSR; Format:'LSR'; Name:'Logical Shift Right'),
    (Proc:InstructionNOP; Format:'NOP'; Name:'No Operation'),
    (Proc:InstructionORA; Format:'ORA'; Name:'Logical Inclusive OR'),
    (Proc:InstructionPHA; Format:'PHA'; Name:'Push A'),
    (Proc:InstructionPHP; Format:'PHP'; Name:'Push P'),
    (Proc:InstructionPHX; Format:'PHX'; Name:'Push X'),
    (Proc:InstructionPHY; Format:'PHY'; Name:'Push Y'),
    (Proc:InstructionPLA; Format:'PLA'; Name:'Pull A'),
    (Proc:InstructionPLP; Format:'PLP'; Name:'Pull P'),
    (Proc:InstructionPLX; Format:'PLX'; Name:'Pull X'),
    (Proc:InstructionPLY; Format:'PLY'; Name:'Pull Y'),
    (Proc:InstructionRMB; Format:'RMB'; Name:'Reset Memory Bit'),
    (Proc:InstructionROL; Format:'ROL'; Name:'Rotate Left'),
    (Proc:InstructionROR; Format:'ROR'; Name:'Rotate Right'),
    (Proc:InstructionRTI; Format:'RTI'; Name:'Return from Interrupt'),
    (Proc:InstructionSTZ; Format:'STZ'; Name:'Store Zero'),
    (Proc:InstructionTAX; Format:'TAX'; Name:'Transfer A to X'),
    (Proc:InstructionTAY; Format:'TAY'; Name:'Transfer A to Y'),
    (Proc:InstructionTRB; Format:'TRB'; Name:'Test and Reset Bit'),
    (Proc:InstructionTSB; Format:'TSB'; Name:'Test and Set Bit'),
    (Proc:InstructionTSX; Format:'TSX'; Name:'Transfer SP to X'),
    (Proc:InstructionTXA; Format:'TXA'; Name:'Transfer X to A'),
    (Proc:InstructionTXS; Format:'TXS'; Name:'Transfer X to SP'),
    (Proc:InstructionTYA; Format:'TYA'; Name:'Transfer Y to A'),
    (Proc:InstructionWAI; Format:'WAI'; Name:'Wait for Interrupt'),
    (Proc:InstructionSEC; Format:'SEC'; Name:'Set Carry Flag'),
    (Proc:InstructionRTS; Format:'RTS'; Name:'Return from Subroutine'),
    (Proc:InstructionSEI; Format:'SEI'; Name:'Set Interrupt Disable'),
    (Proc:InstructionSTA; Format:'STA'; Name:'Store A'),
    (Proc:InstructionSTY; Format:'STY'; Name:'Store Y'),
    (Proc:InstructionSTX; Format:'STX'; Name:'Store X'),
    (Proc:InstructionSBC; Format:'SBC'; Name:'Subtract with Carry'),
    (Proc:InstructionSED; Format:'SED'; Name:'Set Decimal Flag'),
    (Proc:nil)
  );

  OpCodes: array[Byte] of TOpCodeLUT = (
    {00} (Mode:amIMP; Instruction:inBRK; Ticks:7; Penalty:ipNone),
    {01} (Mode:amINX; Instruction:inORA; Ticks:6; Penalty:ipNone),
    {02} (Instruction:inNIL),
    {03} (Instruction:inNIL),
    {04} (Instruction:inNIL),
    {05} (Mode:amZER; Instruction:inORA; Ticks:3; Penalty:ipNone),
    {06} (Mode:amZER; Instruction:inASL; Ticks:5; Penalty:ipNone),
    {07} (Instruction:inNIL),
    {08} (Mode:amIMP; Instruction:inPHP; Ticks:3; Penalty:ipNone),
    {09} (Mode:amIMM; Instruction:inORA; Ticks:2; Penalty:ipNone),
    {0A} (Mode:amACC; Instruction:inASL; Ticks:2; Penalty:ipNone),
    {0B} (Instruction:inNIL),
    {0C} (Instruction:inNIL),
    {0D} (Mode:amABS; Instruction:inORA; Ticks:4; Penalty:ipNone),
    {0E} (Mode:amABS; Instruction:inASL; Ticks:6; Penalty:ipNone),
    {0F} (Instruction:inNIL),
    {10} (Mode:amREL; Instruction:inBPL; Ticks:2; Penalty:ipBranch),
    {11} (Mode:amINY; Instruction:inORA; Ticks:5; Penalty:ipPageCross),
    {12} (Instruction:inNIL),
    {13} (Instruction:inNIL),
    {14} (Instruction:inNIL),
    {15} (Mode:amZEX; Instruction:inORA; Ticks:4; Penalty:ipNone),
    {16} (Mode:amZEX; Instruction:inASL; Ticks:6; Penalty:ipNone),
    {17} (Instruction:inNIL),
    {18} (Mode:amIMP; Instruction:inCLC; Ticks:2; Penalty:ipNone),
    {19} (Mode:amABY; Instruction:inORA; Ticks:4; Penalty:ipPageCross),
    {1A} (Instruction:inNIL),
    {1B} (Instruction:inNIL),
    {1C} (Instruction:inNIL),
    {1D} (Mode:amABX; Instruction:inORA; Ticks:4; Penalty:ipPageCross),
    {1E} (Mode:amABX; Instruction:inASL; Ticks:7; Penalty:ipNone),
    {1F} (Instruction:inNIL),
    {20} (Mode:amABS; Instruction:inJSR; Ticks:6; Penalty:ipNone),
    {21} (Mode:amINX; Instruction:inAND; Ticks:6; Penalty:ipNone),
    {22} (Instruction:inNIL),
    {23} (Instruction:inNIL),
    {24} (Mode:amZER; Instruction:inBIT; Ticks:3; Penalty:ipNone),
    {25} (Mode:amZER; Instruction:inAND; Ticks:3; Penalty:ipNone),
    {26} (Mode:amZER; Instruction:inROL; Ticks:5; Penalty:ipNone),
    {27} (Instruction:inNIL),
    {28} (Mode:amIMP; Instruction:inPLP; Ticks:4; Penalty:ipNone),
    {29} (Mode:amIMM; Instruction:inAND; Ticks:2; Penalty:ipNone),
    {2A} (Mode:amACC; Instruction:inROL; Ticks:2; Penalty:ipNone),
    {2B} (Instruction:inNIL),
    {2C} (Mode:amABS; Instruction:inBIT; Ticks:4; Penalty:ipNone),
    {2D} (Mode:amABS; Instruction:inAND; Ticks:4; Penalty:ipNone),
    {2E} (Mode:amABS; Instruction:inROL; Ticks:6; Penalty:ipNone),
    {2F} (Instruction:inNIL),
    {30} (Mode:amREL; Instruction:inBMI; Ticks:2; Penalty:ipBranch),
    {31} (Mode:amINY; Instruction:inAND; Ticks:5; Penalty:ipNone),
    {32} (Instruction:inNIL),
    {33} (Instruction:inNIL),
    {34} (Instruction:inNIL),
    {35} (Mode:amZEX; Instruction:inAND; Ticks:4; Penalty:ipNone),
    {36} (Mode:amZEX; Instruction:inROL; Ticks:6; Penalty:ipNone),
    {37} (Instruction:inNIL),
    {38} (Mode:amIMP; Instruction:inSEC; Ticks:2; Penalty:ipNone),
    {39} (Mode:amABY; Instruction:inAND; Ticks:4; Penalty:ipPageCross),
    {3A} (Instruction:inNIL),
    {3B} (Instruction:inNIL),
    {3C} (Instruction:inNIL),
    {3D} (Mode:amABX; Instruction:inAND; Ticks:4; Penalty:ipPageCross),
    {3E} (Mode:amABX; Instruction:inROL; Ticks:7; Penalty:ipNone),
    {3F} (Instruction:inNIL),
    {40} (Mode:amIMP; Instruction:inRTI; Ticks:6; Penalty:ipNone),
    {41} (Mode:amINX; Instruction:inEOR; Ticks:6; Penalty:ipNone),
    {42} (Instruction:inNIL),
    {43} (Instruction:inNIL),
    {44} (Instruction:inNIL),
    {45} (Mode:amZER; Instruction:inEOR; Ticks:3; Penalty:ipNone),
    {46} (Mode:amZER; Instruction:inLSR; Ticks:5; Penalty:ipNone),
    {47} (Instruction:inNIL),
    {48} (Mode:amIMP; Instruction:inPHA; Ticks:3; Penalty:ipNone),
    {49} (Mode:amIMM; Instruction:inEOR; Ticks:2; Penalty:ipNone),
    {4A} (Mode:amACC; Instruction:inLSR; Ticks:2; Penalty:ipNone),
    {4B} (Instruction:inNIL),
    {4C} (Mode:amABS; Instruction:inJMP; Ticks:3; Penalty:ipNone),
    {4D} (Mode:amABS; Instruction:inEOR; Ticks:4; Penalty:ipNone),
    {4E} (Mode:amABS; Instruction:inLSR; Ticks:6; Penalty:ipNone),
    {4F} (Instruction:inNIL),
    {50} (Mode:amREL; Instruction:inBVC; Ticks:2; Penalty:ipBranch),
    {51} (Mode:amINY; Instruction:inEOR; Ticks:5; Penalty:ipPageCross),
    {52} (Instruction:inNIL),
    {53} (Instruction:inNIL),
    {54} (Instruction:inNIL),
    {55} (Mode:amZEX; Instruction:inEOR; Ticks:4; Penalty:ipNone),
    {56} (Mode:amZEX; Instruction:inLSR; Ticks:6; Penalty:ipNone),
    {57} (Instruction:inNIL),
    {58} (Mode:amIMP; Instruction:inCLI; Ticks:2; Penalty:ipNone),
    {59} (Mode:amABY; Instruction:inEOR; Ticks:4; Penalty:ipPageCross),
    {5A} (Mode:amIMP; Instruction:inPHY; Ticks:3; Penalty:ipNone),
    {5B} (Instruction:inNIL),
    {5C} (Instruction:inNIL),
    {5D} (Mode:amABX; Instruction:inEOR; Ticks:4; Penalty:ipPageCross),
    {5E} (Mode:amABX; Instruction:inLSR; Ticks:7; Penalty:ipNone),
    {5F} (Instruction:inNIL),
    {60} (Mode:amIMP; Instruction:inRTS; Ticks:6; Penalty:ipNone),
    {61} (Mode:amINX; Instruction:inADC; Ticks:6; Penalty:ipNone),
    {62} (Instruction:inNIL),
    {63} (Instruction:inNIL),
    {64} (Mode:amZER; Instruction:inSTZ; Ticks:3; Penalty:ipNone),
    {65} (Mode:amZER; Instruction:inADC; Ticks:3; Penalty:ipNone),
    {66} (Mode:amZER; Instruction:inROR; Ticks:5; Penalty:ipNone),
    {67} (Instruction:inNIL),
    {68} (Mode:amIMP; Instruction:inPLA; Ticks:4; Penalty:ipNone),
    {69} (Mode:amIMM; Instruction:inADC; Ticks:2; Penalty:ipNone),
    {6A} (Mode:amACC; Instruction:inROR; Ticks:2; Penalty:ipNone),
    {6B} (Instruction:inNIL),
    {6C} (Mode:amAIN; Instruction:inJMP; Ticks:5; Penalty:ipNone),
    {6D} (Mode:amABS; Instruction:inADC; Ticks:4; Penalty:ipNone),
    {6E} (Mode:amABS; Instruction:inROR; Ticks:6; Penalty:ipNone),
    {6F} (Instruction:inNIL),
    {70} (Mode:amREL; Instruction:inBVS; Ticks:2; Penalty:ipBranch),
    {71} (Mode:amINY; Instruction:inADC; Ticks:5; Penalty:ipPageCross),
    {72} (Instruction:inNIL),
    {73} (Instruction:inNIL),
    {74} (Mode:amZEX; Instruction:inSTZ; Ticks:4; Penalty:ipNone),
    {75} (Mode:amZEX; Instruction:inADC; Ticks:4; Penalty:ipNone),
    {76} (Mode:amZEX; Instruction:inROR; Ticks:6; Penalty:ipNone),
    {77} (Instruction:inNIL),
    {78} (Mode:amIMP; Instruction:inSEI; Ticks:2; Penalty:ipNone),
    {79} (Mode:amABY; Instruction:inADC; Ticks:4; Penalty:ipPageCross),
    {7A} (Instruction:inNIL),
    {7B} (Instruction:inNIL),
    {7C} (Instruction:inNIL),
    {7D} (Mode:amABX; Instruction:inADC; Ticks:4; Penalty:ipPageCross),
    {7E} (Mode:amABX; Instruction:inROR; Ticks:7; Penalty:ipNone),
    {7F} (Instruction:inNIL),
    {80} (Mode:amREL; Instruction:inBRA; Ticks:3; Penalty:ipPageCross),
    {81} (Mode:amINX; Instruction:inSTA; Ticks:6; Penalty:ipNone),
    {82} (Instruction:inNIL),
    {83} (Instruction:inNIL),
    {84} (Mode:amZER; Instruction:inSTY; Ticks:3; Penalty:ipNone),
    {85} (Mode:amZER; Instruction:inSTA; Ticks:3; Penalty:ipNone),
    {86} (Mode:amZER; Instruction:inSTX; Ticks:3; Penalty:ipNone),
    {87} (Instruction:inNIL),
    {88} (Mode:amIMP; Instruction:inDEY; Ticks:2; Penalty:ipNone),
    {89} (Instruction:inNIL),
    {8A} (Mode:amIMP; Instruction:inTXA; Ticks:2; Penalty:ipNone),
    {8B} (Instruction:inNIL),
    {8C} (Mode:amABS; Instruction:inSTY; Ticks:4; Penalty:ipNone),
    {8D} (Mode:amABS; Instruction:inSTA; Ticks:4; Penalty:ipNone),
    {8E} (Mode:amABS; Instruction:inSTX; Ticks:4; Penalty:ipNone),
    {8F} (Instruction:inNIL),
    {90} (Mode:amREL; Instruction:inBCC; Ticks:2; Penalty:ipBranch),
    {91} (Mode:amINY; Instruction:inSTA; Ticks:6; Penalty:ipNone),
    {92} (Instruction:inNIL),
    {93} (Instruction:inNIL),
    {94} (Mode:amZEX; Instruction:inSTY; Ticks:4; Penalty:ipNone),
    {95} (Mode:amZEX; Instruction:inSTA; Ticks:4; Penalty:ipNone),
    {96} (Mode:amZEY; Instruction:inSTX; Ticks:4; Penalty:ipNone),
    {97} (Instruction:inNIL),
    {98} (Mode:amIMP; Instruction:inTYA; Ticks:2; Penalty:ipNone),
    {99} (Mode:amABY; Instruction:inSTA; Ticks:5; Penalty:ipNone),
    {9A} (Mode:amIMP; Instruction:inTXS; Ticks:2; Penalty:ipNone),
    {9B} (Instruction:inNIL),
    {9C} (Mode:amABS; Instruction:inSTZ; Ticks:4; Penalty:ipNone),
    {9D} (Mode:amABX; Instruction:inSTA; Ticks:5; Penalty:ipNone),
    {9E} (Mode:amABX; Instruction:inSTZ; Ticks:5; Penalty:ipNone),
    {9F} (Instruction:inNIL),
    {A0} (Mode:amIMM; Instruction:inLDY; Ticks:2; Penalty:ipNone),
    {A1} (Mode:amINX; Instruction:inLDA; Ticks:6; Penalty:ipNone),
    {A2} (Mode:amIMM; Instruction:inLDX; Ticks:2; Penalty:ipNone),
    {A3} (Instruction:inNIL),
    {A4} (Mode:amZER; Instruction:inLDY; Ticks:3; Penalty:ipNone),
    {A5} (Mode:amZER; Instruction:inLDA; Ticks:3; Penalty:ipNone),
    {A6} (Mode:amZER; Instruction:inLDX; Ticks:3; Penalty:ipNone),
    {A7} (Instruction:inNIL),
    {A8} (Mode:amIMP; Instruction:inTAY; Ticks:2; Penalty:ipNone),
    {A9} (Mode:amIMM; Instruction:inLDA; Ticks:2; Penalty:ipNone),
    {AA} (Mode:amIMP; Instruction:inTAX; Ticks:2; Penalty:ipNone),
    {AB} (Instruction:inNIL),
    {AC} (Mode:amABS; Instruction:inLDY; Ticks:4; Penalty:ipNone),
    {AD} (Mode:amABS; Instruction:inLDA; Ticks:4; Penalty:ipNone),
    {AE} (Mode:amABS; Instruction:inLDX; Ticks:4; Penalty:ipNone),
    {AF} (Instruction:inNIL),
    {B0} (Mode:amREL; Instruction:inBCS; Ticks:2; Penalty:ipBranch),
    {B1} (Mode:amINY; Instruction:inLDA; Ticks:5; Penalty:ipPageCross),
    {B2} (Instruction:inNIL),
    {B3} (Instruction:inNIL),
    {B4} (Mode:amZEX; Instruction:inLDY; Ticks:4; Penalty:ipNone),
    {B5} (Mode:amZEX; Instruction:inLDA; Ticks:4; Penalty:ipNone),
    {B6} (Mode:amZEY; Instruction:inLDX; Ticks:4; Penalty:ipNone),
    {B7} (Instruction:inNIL),
    {B8} (Mode:amIMP; Instruction:inCLV; Ticks:2; Penalty:ipNone),
    {B9} (Mode:amABY; Instruction:inLDA; Ticks:4; Penalty:ipPageCross),
    {BA} (Mode:amIMP; Instruction:inTSX; Ticks:2; Penalty:ipNone),
    {BB} (Instruction:inNIL),
    {BC} (Mode:amABX; Instruction:inLDY; Ticks:4; Penalty:ipPageCross),
    {BD} (Mode:amABX; Instruction:inLDA; Ticks:4; Penalty:ipPageCross),
    {BE} (Mode:amABY; Instruction:inLDX; Ticks:4; Penalty:ipPageCross),
    {BF} (Instruction:inNIL),
    {C0} (Mode:amIMM; Instruction:inCPY; Ticks:2; Penalty:ipNone),
    {C1} (Mode:amINX; Instruction:inCMP; Ticks:6; Penalty:ipNone),
    {C2} (Instruction:inNIL),
    {C3} (Instruction:inNIL),
    {C4} (Mode:amZER; Instruction:inCPY; Ticks:3; Penalty:ipNone),
    {C5} (Mode:amZER; Instruction:inCMP; Ticks:3; Penalty:ipNone),
    {C6} (Mode:amZER; Instruction:inDEC; Ticks:5; Penalty:ipNone),
    {C7} (Instruction:inNIL),
    {C8} (Mode:amIMP; Instruction:inINY; Ticks:2; Penalty:ipNone),
    {C9} (Mode:amIMM; Instruction:inCMP; Ticks:2; Penalty:ipNone),
    {CA} (Mode:amIMP; Instruction:inDEX; Ticks:2; Penalty:ipNone),
    {CB} (Mode:amIMP; Instruction:inWAI; Ticks:3; Penalty:ipNone),
    {CC} (Mode:amABS; Instruction:inCPY; Ticks:4; Penalty:ipNone),
    {CD} (Mode:amABS; Instruction:inCMP; Ticks:4; Penalty:ipNone),
    {CE} (Mode:amABS; Instruction:inDEC; Ticks:3; Penalty:ipNone),
    {CF} (Instruction:inNIL),
    {D0} (Mode:amREL; Instruction:inBNE; Ticks:2; Penalty:ipBranch),
    {D1} (Mode:amINY; Instruction:inCMP; Ticks:5; Penalty:ipPageCross),
    {D2} (Instruction:inNIL),
    {D3} (Instruction:inNIL),
    {D4} (Instruction:inNIL),
    {D5} (Mode:amZEX; Instruction:inCMP; Ticks:4; Penalty:ipNone),
    {D6} (Mode:amZEX; Instruction:inDEC; Ticks:6; Penalty:ipNone),
    {D7} (Instruction:inNIL),
    {D8} (Mode:amIMP; Instruction:inCLD; Ticks:2; Penalty:ipNone),
    {D9} (Mode:amABY; Instruction:inCMP; Ticks:4; Penalty:ipPageCross),
    {DA} (Mode:amIMP; Instruction:inPHX; Ticks:3; Penalty:ipNone),
    {DB} (Instruction:inNIL),
    {DC} (Instruction:inNIL),
    {DD} (Mode:amABX; Instruction:inCMP; Ticks:4; Penalty:ipPageCross),
    {DE} (Mode:amABX; Instruction:inDEC; Ticks:7; Penalty:ipNone),
    {DF} (Instruction:inNIL),
    {E0} (Mode:amIMM; Instruction:inCPX; Ticks:2; Penalty:ipNone),
    {E1} (Mode:amINX; Instruction:inSBC; Ticks:6; Penalty:ipNone),
    {E2} (Instruction:inNIL),
    {E3} (Instruction:inNIL),
    {E4} (Mode:amZER; Instruction:inCPX; Ticks:3; Penalty:ipNone),
    {E5} (Mode:amZER; Instruction:inSBC; Ticks:3; Penalty:ipNone),
    {E6} (Mode:amZER; Instruction:inINC; Ticks:5; Penalty:ipNone),
    {E7} (Instruction:inNIL),
    {E8} (Mode:amIMP; Instruction:inINX; Ticks:2; Penalty:ipNone),
    {E9} (Mode:amIMM; Instruction:inSBC; Ticks:2; Penalty:ipNone),
    {EA} (Mode:amIMP; Instruction:inNOP; Ticks:2; Penalty:ipNone),
    {EB} (Instruction:inNIL),
    {EC} (Mode:amABS; Instruction:inCPX; Ticks:4; Penalty:ipNone),
    {ED} (Mode:amABS; Instruction:inSBC; Ticks:4; Penalty:ipNone),
    {EE} (Mode:amABS; Instruction:inINC; Ticks:6; Penalty:ipNone),
    {EF} (Instruction:inNIL),
    {F0} (Mode:amREL; Instruction:inBEQ; Ticks:2; Penalty:ipBranch),
    {F1} (Mode:amINY; Instruction:inSBC; Ticks:5; Penalty:ipPageCross),
    {F2} (Instruction:inNIL),
    {F3} (Instruction:inNIL),
    {F4} (Instruction:inNIL),
    {F5} (Mode:amZEX; Instruction:inSBC; Ticks:4; Penalty:ipNone),
    {F6} (Mode:amZEX; Instruction:inINC; Ticks:6; Penalty:ipNone),
    {F7} (Instruction:inNIL),
    {F8} (Mode:amIMP; Instruction:inSED; Ticks:2; Penalty:ipNone),
    {F9} (Mode:amABY; Instruction:inSBC; Ticks:4; Penalty:ipPageCross),
    {FA} (Instruction:inNIL),
    {FB} (Instruction:inNIL),
    {FC} (Instruction:inNIL),
    {FD} (Mode:amABX; Instruction:inSBC; Ticks:4; Penalty:ipPageCross),
    {FE} (Mode:amABX; Instruction:inINC; Ticks:7; Penalty:ipNone),
    {FF} (Instruction:inNIL)
  );

implementation

procedure InstructionAND;
begin
  var M:   Byte := Machine.ReadByte(Src);
  var Res: Byte := M and Machine.Registers.A;

  Machine.Registers[StatusNegative] := (Res and $80) <> 0;
  Machine.Registers[StatusZero] := Res = 0;

  Machine.Registers.A := Res;
end;

procedure InstructionASL;
var
  M: Byte;
begin
  if Machine.ModeAcc then
    M := Machine.Registers.A
  else
    M := Machine.ReadByte(Src);

  Machine.Registers[StatusCarry] := (M and $80) <> 0;

  M := M shl 1;
  M := M and $FF;

  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;

  if Machine.ModeAcc then
    Machine.Registers.A := M
  else
    Machine.WriteByte(Src, M);
end;

procedure InstructionBCC;
begin
  if not Machine.Registers[StatusCarry] then
  begin
    Machine.Branched := True;

    if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
      Machine.PageCrossed := True;

    Machine.Registers.PC := Src;
  end;
end;

procedure InstructionBCS;
begin
  if Machine.Registers[StatusCarry] then
  begin
    Machine.Branched := True;

    if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
      Machine.PageCrossed := True;

    Machine.Registers.PC := Src;
  end;
end;

procedure InstructionBEQ;
begin
  if Machine.Registers[StatusZero] then
  begin
    Machine.Branched := True;

    if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
      Machine.PageCrossed := True;

    Machine.Registers.PC := Src;
  end;
end;

procedure InstructionBIT;
begin
  var M: Byte   := Machine.ReadByte(Src);
  var Res: Byte := M and Machine.Registers.A;
  Machine.Registers[StatusNegative] := (Res and $80) <> 0;

  Machine.Registers.Status := (Machine.Registers.Status and $3F) or (M and $C0);
  Machine.Registers[StatusZero] := Res = 0;
end;

procedure InstructionBMI;
begin
  if Machine.Registers[StatusNegative] then
  begin
    Machine.Branched := True;

    if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
      Machine.PageCrossed := True;

    Machine.Registers.PC := Src;
  end;
end;

procedure InstructionBNE;
begin
  if not Machine.Registers[StatusZero] then
  begin
    Machine.Branched := True;

    if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
      Machine.PageCrossed := True;

    Machine.Registers.PC := Src;
  end;
end;

procedure InstructionBPL;
begin
  if not Machine.Registers[StatusNegative] then
  begin
    Machine.Branched := True;

    if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
      Machine.PageCrossed := True;

    Machine.Registers.PC := Src;
  end;
end;

procedure InstructionBRA(Machine: T65C02; Src: Word);
begin
  Machine.Branched := True;

  if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
    Machine.PageCrossed := True;

  Machine.Registers.PC := Src;
end;

procedure InstructionBRK;
begin
  Inc(Machine.Registers.PC);

  Machine.StackPush((Machine.Registers.PC shr 8) and $FF);
  Machine.StackPush(Machine.Registers.PC and $FF);
  Machine.StackPush(Machine.Registers.Status or StatusBreak);

  Machine.Registers[StatusInterrupt] := True;
  Machine.Registers.PC := Machine.IRQVector;
end;

procedure InstructionBVC;
begin
  if not Machine.Registers[StatusOverflow] then
  begin
    Machine.Branched := True;

    if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
      Machine.PageCrossed := True;

    Machine.Registers.PC := Src;
  end;
end;

procedure InstructionBVS;
begin
  if Machine.Registers[StatusOverflow] then
  begin
    Machine.Branched := True;

    if (Src and $FF00) <> (Machine.Registers.PC and $FF00) then
      Machine.PageCrossed := True;

    Machine.Registers.PC := Src;
  end;
end;

procedure InstructionCLC;
begin
  Machine.Registers[StatusCarry] := False;
end;

procedure InstructionCLD;
begin
  Machine.Registers[StatusDecimal] := False;
end;

procedure InstructionCLI;
begin
  Machine.Registers[StatusInterrupt] := False;
end;

procedure InstructionCLV;
begin
  Machine.Registers[StatusOverflow] := False;
end;

procedure InstructionCMP;
begin
  var Tmp: Cardinal := Machine.Registers.A - Machine.ReadByte(Src);
  Machine.Registers[StatusCarry] := Tmp < $100;
  Machine.Registers[StatusNegative] := (Tmp and $80) <> 0;
  Machine.Registers[StatusZero] := (Tmp and $FF) = 0;
end;

procedure InstructionCPX;
begin
  var Tmp: Cardinal := Machine.Registers.X - Machine.ReadByte(Src);
  Machine.Registers[StatusCarry] := Tmp < $100;
  Machine.Registers[StatusNegative] := (Tmp and $80) <> 0;
  Machine.Registers[StatusZero] :=  (Tmp and $FF) = 0;
end;

procedure InstructionCPY;
begin
  var Tmp: Cardinal := Machine.Registers.Y - Machine.ReadByte(Src);
  Machine.Registers[StatusCarry] := Tmp < $100;
  Machine.Registers[StatusNegative] := (Tmp and $80) <> 0;
  Machine.Registers[StatusZero] := (Tmp and $FF) = 0;
end;

procedure InstructionDEC;
begin
  var M: Byte := Machine.ReadByte(Src) - 1;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.WriteByte(Src, M);
end;

procedure InstructionDEX;
begin
  var M: Byte := Machine.Registers.X - 1;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.X := M;
end;

procedure InstructionDEY;
begin
  var M: Byte := Machine.Registers.Y - 1;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.Y := M;
end;

procedure InstructionEOR;
begin
  var M: Byte := Machine.ReadByte(Src);
  M := Machine.Registers.A xor M;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.A := M;
end;

procedure InstructionINC;
begin
  var M: Byte := Machine.ReadByte(Src) + 1;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.WriteByte(Src, M);
end;

procedure InstructionINX;
begin
  var M: Byte := Machine.Registers.X + 1;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.X := M;
end;

procedure InstructionINY;
begin
  var M: Byte := Machine.Registers.Y + 1;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.Y := M;
end;

procedure InstructionJMP;
begin
  Machine.Registers.PC := Src;
end;

procedure InstructionJSR;
begin
  Dec(Machine.Registers.PC);
  Machine.StackPush((Machine.Registers.PC shr 8) and $FF);
  Machine.StackPush(Machine.Registers.PC and $FF);
  Machine.Registers.PC := Src;
end;

procedure InstructionLDA;
begin
  var M: Byte := Machine.ReadByte(Src);
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.A := M;
end;

procedure InstructionLDX;
begin
  var M: Byte := Machine.ReadByte(Src);
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.X := M;
end;

procedure InstructionLDY;
begin
  var M: Byte := Machine.ReadByte(Src);
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.Y := M;
end;

procedure InstructionLSR;
var
  M: Byte;
begin
  if Machine.ModeAcc then
    M := Machine.Registers.A
  else
    M := Machine.ReadByte(Src);

  Machine.Registers[StatusCarry] := (M and $01) <> 0;
  M := M shr 1;
  Machine.Registers[StatusNegative] := False;
  Machine.Registers[StatusZero] := M = 0;

  if Machine.ModeAcc then
    Machine.Registers.A := M
  else
    Machine.WriteByte(Src, M);
end;

procedure InstructionNOP;
begin
  {No OP}
end;

procedure InstructionORA;
begin
  var M: Byte := Machine.ReadByte(Src);
  M := Machine.Registers.A or M;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.A := M;
end;

procedure InstructionPHA;
begin
  Machine.StackPush(Machine.Registers.A);
end;

procedure InstructionPHP;
begin
  Machine.StackPush(Machine.Registers.Status or StatusBreak);
end;

procedure InstructionPHX;
begin
  Machine.StackPush(Machine.Registers.X);
end;

procedure InstructionPHY;
begin
  Machine.StackPush(Machine.Registers.Y);
end;

procedure InstructionPLA;
begin
  Machine.Registers.A := Machine.StackPull;
  Machine.Registers[StatusNegative] := (Machine.Registers.A and $80) <> 0;
  Machine.Registers[StatusZero] := Machine.Registers.A = 0;
end;

procedure InstructionPLP;
begin
  Machine.Registers.Status := Machine.StackPull;
  Machine.Registers[StatusConstant] := True;
end;

procedure InstructionPLX;
begin
  Machine.Registers.X := Machine.StackPull;
  Machine.Registers[StatusNegative] := (Machine.Registers.X and $80) <> 0;
  Machine.Registers[StatusZero] := Machine.Registers.X = 0;
end;

procedure InstructionPLY;
begin
  Machine.Registers.Y := Machine.StackPull;
  Machine.Registers[StatusNegative] := (Machine.Registers.Y and $80) <> 0;
  Machine.Registers[StatusZero] := Machine.Registers.Y = 0;
end;

procedure InstructionROL;
var
  M: Word;
begin
  if Machine.ModeAcc then
    M := Machine.Registers.A
  else
    M := Machine.ReadByte(Src);

  M := M shl 1;

  if Machine.Registers[StatusCarry] then
    M := M or $01;

  Machine.Registers[StatusCarry] := M > $FF;
  M := M and $FF;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;

  if Machine.ModeAcc then
    Machine.Registers.A := M
  else
    Machine.WriteByte(Src, M);
end;

procedure InstructionROR;
var
  M: Word;
begin
  if Machine.ModeAcc then
    M := Machine.Registers.A
  else
    M := Machine.ReadByte(Src);

  if Machine.Registers[StatusCarry] then
    M := M or $100;

  Machine.Registers[StatusCarry] := (M and $01) <> 0;

  M := M shr 1;
  M := M and $FF;

  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;

  if Machine.ModeAcc then
    Machine.Registers.A := M
  else
    Machine.WriteByte(Src, M);
end;

procedure InstructionRTI;
begin
  Machine.Registers.Status := Machine.StackPull;

  var Lo: Byte := Machine.StackPull;
  var Hi: Byte := Machine.StackPull;

  Machine.Registers.PC := (Hi shl 8) or Lo;
end;

procedure InstructionRTS;
begin
  var Lo: Byte := Machine.StackPull;
  var Hi: Byte := Machine.StackPull;

  Machine.Registers.PC := (Hi shl 8) or Lo + 1;
end;

procedure InstructionADC;
begin
  var M:   Byte     := Machine.ReadByte(Src);
  var Tmp: Cardinal := M + Machine.Registers.A + Machine.Registers.CarryOne;

  Machine.Registers[StatusZero] := (Tmp and $FF) = 0;

  if Machine.Registers[StatusDecimal] then
  begin
    if (((Machine.Registers.A and $F) + (M and $F) + Machine.Registers.CarryOne) > 9) then
      Tmp := Tmp + 6;

    Machine.Registers[StatusNegative] := (Tmp and $80) <> 0;

    Machine.Registers[StatusOverflow] := (((Machine.Registers.A xor M) and $80) = 0) and (((Machine.Registers.A xor Tmp) and $80) <> 0);

    if Tmp > $99 then
      Tmp := Tmp + $60;

    Machine.Registers[StatusCarry] := Tmp > $99;
  end
  else
  begin
    Machine.Registers[StatusNegative] := (Tmp and $80) <> 0;
    Machine.Registers[StatusOverflow] := (((Machine.Registers.A xor M) and $80)=0) and (((Machine.Registers.A xor Tmp) and $80) <> 0);
    Machine.Registers[StatusCarry] := Tmp > $FF;
  end;

  Machine.Registers.A := Tmp and $FF;
end;

procedure InstructionSBC;
begin
  var M:   Byte := Machine.ReadByte(Src);
  var Tmp: Word := Machine.Registers.A - M - (1 - Machine.Registers.CarryOne);

  Machine.Registers[StatusNegative] := (Tmp and $80) <> 0;

  Machine.Registers[StatusZero] := (Tmp and $FF) = 0;

   Machine.Registers[StatusOverflow] := (((Machine.Registers.A xor Tmp) and $80) <> 0) and (((Machine.Registers.A xor M) and $80) <> 0);

  if Machine.Registers[StatusDecimal] then
  begin
    if (((Machine.Registers.A and $0F) - (1 - Machine.Registers.CarryOne)) < (M and $0F)) then
      Tmp := Tmp - 6;

    if Tmp > $99 then
      Tmp := Tmp - $60;
  end;

  Machine.Registers[StatusCarry] := Tmp < $100;
  Machine.Registers.A := Tmp and $FF;
end;

procedure InstructionSEC;
begin
  Machine.Registers[StatusCarry] := True;
end;

procedure InstructionSED;
begin
  Machine.Registers[StatusDecimal] := True;
end;

procedure InstructionSEI;
begin
  Machine.Registers[StatusInterrupt] := True;
end;

procedure InstructionSTA;
begin
  Machine.WriteByte(Src, Machine.Registers.A);
end;

procedure InstructionSTX;
begin
  Machine.WriteByte(Src, Machine.Registers.X);
end;

procedure InstructionSTY;
begin
  Machine.WriteByte(Src, Machine.Registers.Y);
end;

procedure InstructionSTZ;
begin
  Machine.WriteByte(Src, 0);
end;

procedure InstructionTAX;
begin
  var M: Byte := Machine.Registers.A;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.X := M;
end;

procedure InstructionTAY;
begin
  var M: Byte := Machine.Registers.A;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.Y := M;
end;

procedure InstructionTSX;
begin
  var M: Byte := Machine.Registers.SP;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.X := M;
end;

procedure InstructionTXA;
begin
  var M: Byte := Machine.Registers.X;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.A := M;
end;

procedure InstructionTXS;
begin
  Machine.Registers.SP := Machine.Registers.X;
end;

procedure InstructionTYA;
begin
  var M: Byte := Machine.Registers.Y;
  Machine.Registers[StatusNegative] := (M and $80) <> 0;
  Machine.Registers[StatusZero] := M = 0;
  Machine.Registers.A := M;
end;

// TODO: Slightly more complicated as both parameters change
procedure InstructionBBR(Machine: T65C02; Src: Word);
begin
  {}
end;

procedure InstructionBSS(Machine: T65C02; Src: Word);
begin
  {}
end;

procedure InstructionRMB(Machine: T65C02; Src: Word);
begin
  {}
end;

procedure InstructionTRB(Machine: T65C02; Src: Word);
begin
  {}
end;

procedure InstructionTSB(Machine: T65C02; Src: Word);
begin
  {}
end;

procedure InstructionWAI(Machine: T65C02; Src: Word);
begin
  // TODO: Wait for interrupt mechanism
end;

end.

