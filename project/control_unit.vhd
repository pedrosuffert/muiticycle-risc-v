-- control_unit.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
    Port (
        opcode      : in  STD_LOGIC_VECTOR(6 downto 0);
        funct3      : in  STD_LOGIC_VECTOR(2 downto 0);
        funct7      : in  STD_LOGIC_VECTOR(6 downto 0);
        -- Control signals
        RegWrite    : out STD_LOGIC;
        MemRead     : out STD_LOGIC;
        MemWrite    : out STD_LOGIC;
        ALUSrcA     : out STD_LOGIC;
        ALUSrcB     : out STD_LOGIC;
        ALUOp       : out STD_LOGIC_VECTOR(3 downto 0);
        PCWrite     : out STD_LOGIC;
        PCSource    : out STD_LOGIC_VECTOR(1 downto 0)
    );
end control_unit;

architecture Behavioral of control_unit is
begin
    process(opcode, funct3, funct7)
    begin
        -- Default control signals
        RegWrite    <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        ALUSrcA     <= '0';
        ALUSrcB     <= '0';
        ALUOp       <= "0000";
        PCWrite     <= '0';
        PCSource    <= "00";

        case opcode is
            when "0110011" =>  -- R-type instructions
                RegWrite <= '1';
                ALUSrcA  <= '1';
                ALUSrcB  <= '0';
                case funct3 is
                    when "000" =>  -- ADD or SUB
                        if funct7 = "0000000" then
                            ALUOp <= "0000";  -- ADD
                        elsif funct7 = "0100000" then
                            ALUOp <= "0001";  -- SUB
                        end if;
                    when "111" => ALUOp <= "0010";  -- AND
                    when "110" => ALUOp <= "0011";  -- OR
                    when "100" => ALUOp <= "0100";  -- XOR
                    when "010" => ALUOp <= "0101";  -- SLT
                    when others => null;
                end case;
            when "0010011" =>  -- I-type arithmetic instructions (ADDI)
                RegWrite <= '1';
                ALUSrcA  <= '1';
                ALUSrcB  <= '1';
                ALUOp    <= "0000";  -- ADDI uses ADD operation
            when "0000011" =>  -- LW
                RegWrite <= '1';
                MemRead  <= '1';
                ALUSrcA  <= '1';
                ALUSrcB  <= '1';
                ALUOp    <= "0000";  -- Address calculation
            when "0100011" =>  -- SW
                MemWrite <= '1';
                ALUSrcA  <= '1';
                ALUSrcB  <= '1';
                ALUOp    <= "0000";  -- Address calculation
            when "1101111" =>  -- JAL
                RegWrite <= '1';
                PCWrite  <= '1';
                PCSource <= "10";    -- PC + immediate
            when "1100111" =>  -- JALR
                RegWrite <= '1';
                PCWrite  <= '1';
                PCSource <= "11";    -- Register + immediate
            when "0010111" =>  -- AUIPC
                RegWrite <= '1';
                ALUSrcA  <= '0';
                ALUSrcB  <= '1';
                ALUOp    <= "0000";
            when "0110111" =>  -- LUI
                RegWrite <= '1';
                ALUSrcA  <= '0';
                ALUSrcB  <= '1';
                ALUOp    <= "0000";
            when "1100011" =>  -- Branch instructions
                ALUSrcA  <= '1';
                ALUSrcB  <= '0';
                case funct3 is
                    when "000" =>  -- BEQ
                        ALUOp   <= "0001";  -- SUB
                        if Zero = '1' then
                            PCWrite  <= '1';
                            PCSource <= "01";  -- PC + immediate
                        end if;
                    when "001" =>  -- BNE
                        ALUOp   <= "0001";  -- SUB
                        if Zero = '0' then
                            PCWrite  <= '1';
                            PCSource <= "01";  -- PC + immediate
                        end if;
                    when others => null;
                end case;
            when others => null;
        end case;
    end process;
end Behavioral;
