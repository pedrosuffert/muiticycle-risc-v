-- mux_alu_src_a.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_alu_src_a is
    Port (
        sel       : in  STD_LOGIC;
        input0    : in  STD_LOGIC_VECTOR(31 downto 0);
        input1    : in  STD_LOGIC_VECTOR(31 downto 0);
        output    : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux_alu_src_a;

architecture Behavioral of mux_alu_src_a is
begin
    output <= input0 when sel = '0' else input1;
end Behavioral;
