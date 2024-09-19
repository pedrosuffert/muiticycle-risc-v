-- instruction_memory.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory is
    Port (
        addr     : in  STD_LOGIC_VECTOR(31 downto 0);
        instr    : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    type memory_array is array (0 to 4095) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem : memory_array := (others => (others => '0'));
begin
    instr <= mem(to_integer(unsigned(addr(13 downto 2))));
    -- Initialize memory with program code as needed
end Behavioral;
