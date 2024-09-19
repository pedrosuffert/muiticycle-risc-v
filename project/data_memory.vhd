-- data_memory.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    Port (
        clk       : in  STD_LOGIC;
        MemRead   : in  STD_LOGIC;
        MemWrite  : in  STD_LOGIC;
        addr      : in  STD_LOGIC_VECTOR(31 downto 0);
        writeData : in  STD_LOGIC_VECTOR(31 downto 0);
        readData  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end data_memory;

architecture Behavioral of data_memory is
    type memory_array is array (0 to 4095) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem : memory_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                mem(to_integer(unsigned(addr(13 downto 2)))) <= writeData;
            end if;
        end if;
    end process;

    readData <= mem(to_integer(unsigned(addr(13 downto 2)))) when MemRead = '1' else (others => '0');
end Behavioral;
