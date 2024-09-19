-- immediate_generator.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity immediate_generator is
    Port (
        instr    : in  STD_LOGIC_VECTOR(31 downto 0);
        imm_out  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end immediate_generator;

architecture Behavioral of immediate_generator is
begin
    process(instr)
    begin
        case instr(6 downto 0) is
            when "0010011" | "0000011" | "1100111" =>  -- I-type
                imm_out <= std_logic_vector(signed(instr(31 downto 20)));
            when "0100011" =>  -- S-type
                imm_out <= std_logic_vector(signed(instr(31 downto 25) & instr(11 downto 7)));
            when "1100011" =>  -- B-type
                imm_out <= std_logic_vector(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'));
            when "0010111" | "0110111" =>  -- U-type
                imm_out <= instr(31 downto 12) & x"000";
            when "1101111" =>  -- J-type
                imm_out <= std_logic_vector(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'));
            when others =>
                imm_out <= (others => '0');
        end case;
    end process;
end Behavioral;
