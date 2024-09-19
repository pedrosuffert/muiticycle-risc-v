-- processor.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processor is
    Port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC
    );
end processor;

architecture Behavioral of processor is
    -- Signals
    signal PC, PC_next, PC_plus4 : STD_LOGIC_VECTOR(31 downto 0);
    signal instr                 : STD_LOGIC_VECTOR(31 downto 0);
    signal readData1, readData2  : STD_LOGIC_VECTOR(31 downto 0);
    signal writeData             : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUResult             : STD_LOGIC_VECTOR(31 downto 0);
    signal ALU_inputA, ALU_inputB : STD_LOGIC_VECTOR(31 downto 0);
    signal imm_out               : STD_LOGIC_VECTOR(31 downto 0);
    signal Zero                  : STD_LOGIC;
    -- Control signals
    signal RegWrite, MemRead, MemWrite, ALUSrcA, ALUSrcB, PCWrite : STD_LOGIC;
    signal ALUOp               : STD_LOGIC_VECTOR(3 downto 0);
    signal PCSource            : STD_LOGIC_VECTOR(1 downto 0);
    -- Extracted fields
    signal opcode              : STD_LOGIC_VECTOR(6 downto 0);
    signal funct3              : STD_LOGIC_VECTOR(2 downto 0);
    signal funct7              : STD_LOGIC_VECTOR(6 downto 0);
    signal rd, rs1, rs2        : STD_LOGIC_VECTOR(4 downto 0);
begin
    -- Instantiate PC module
    PC_module: entity work.pc
        Port map (
            clk     => clk,
            reset   => reset,
            PCWrite => PCWrite,
            PC_in   => PC_next,
            PC_out  => PC
        );

    -- Instruction Memory
    InstrMem: entity work.instruction_memory
        Port map (
            addr  => PC,
            instr => instr
        );

    -- Decode instruction fields
    opcode <= instr(6 downto 0);
    rd     <= instr(11 downto 7);
    funct3 <= instr(14 downto 12);
    rs1    <= instr(19 downto 15);
    rs2    <= instr(24 downto 20);
    funct7 <= instr(31 downto 25);

    -- Register File
    RegFile: entity work.register_file
        Port map (
            clk       => clk,
            RegWrite  => RegWrite,
            readReg1  => rs1,
            readReg2  => rs2,
            writeReg  => rd,
            writeData => writeData,
            readData1 => readData1,
            readData2 => readData2
        );

    -- Immediate Generator
    ImmGen: entity work.immediate_generator
        Port map (
            instr   => instr,
            imm_out => imm_out
        );

    -- ALU Source A MUX
    ALUSrcA_MUX: entity work.mux_alu_src_a
        Port map (
            sel    => ALUSrcA,
            input0 => PC,
            input1 => readData1,
            output => ALU_inputA
        );

    -- ALU Source B MUX
    ALUSrcB_MUX: entity work.mux_alu_src_b
        Port map (
            sel    => ALUSrcB,
            input0 => readData2,
            input1 => imm_out,
            output => ALU_inputB
        );

    -- ALU
    ALU_module: entity work.alu
        Port map (
            A      => ALU_inputA,
            B      => ALU_inputB,
            ALUOp  => ALUOp,
            Result => ALUResult,
            Zero   => Zero
        );

    -- Data Memory
    DataMem: entity work.data_memory
        Port map (
            clk       => clk,
            MemRead   => MemRead,
            MemWrite  => MemWrite,
            addr      => ALUResult,
            writeData => readData2,
            readData  => writeData  -- Reusing writeData signal for read data
        );

    -- PC + 4
    PC_plus4 <= std_logic_vector(unsigned(PC) + 4);

    -- PC Source MUX
    PCSource_MUX: entity work.mux_pc_source
        Port map (
            sel    => PCSource,
            input0 => PC_plus4,
            input1 => ALUResult,
            input2 => ALUResult,
            input3 => ALUResult,
            output => PC_next
        );

    -- Control Unit
    ControlUnit: entity work.control_unit
        Port map (
            opcode    => opcode,
            funct3    => funct3,
            funct7    => funct7,
            RegWrite  => RegWrite,
            MemRead   => MemRead,
            MemWrite  => MemWrite,
            ALUSrcA   => ALUSrcA,
            ALUSrcB   => ALUSrcB,
            ALUOp     => ALUOp,
            PCWrite   => PCWrite,
            PCSource  => PCSource
        );

end Behavioral;
