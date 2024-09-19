-- mux_pc_source.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_pc_source is
    Port (
        sel       : in  STD_LOGIC_VECTOR(1 downto 0);
        input0    : in  STD_LOGIC_VECTOR(31 downto 0);  -- PC + 4
        input1    : in  STD_LOGIC_VECTOR(31 downto 0);  -- PC + Immediate
        input2    : in  STD_LOGIC_VECTOR(31 downto 0);  -- Immediate (JAL)
        input3    : in  STD_LOGIC_VECTOR(31 downto 0);  -- Register + Immediate (JALR)
        output    : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux_pc_source;

architecture Behavioral of mux_pc_source is
begin
    with sel select
        output <= input0 when "00",
                  input1 when "01",
                  input2 when "10",
                  input3 when "11",
                  (others => '0') when others;
end Behavioral;
