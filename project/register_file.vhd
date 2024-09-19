-- register_file.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port (
        clk        : in  STD_LOGIC;
        RegWrite   : in  STD_LOGIC;
        readReg1   : in  STD_LOGIC_VECTOR(4 downto 0);
        readReg2   : in  STD_LOGIC_VECTOR(4 downto 0);
        writeReg   : in  STD_LOGIC_VECTOR(4 downto 0);
        writeData  : in  STD_LOGIC_VECTOR(31 downto 0);
        readData1  : out STD_LOGIC_VECTOR(31 downto 0);
        readData2  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
    type reg_file_type is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal reg_file : reg_file_type := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if RegWrite = '1' and writeReg /= "00000" then
                reg_file(to_integer(unsigned(writeReg))) <= writeData;
            end if;
        end if;
    end process;

    readData1 <= reg_file(to_integer(unsigned(readReg1)));
    readData2 <= reg_file(to_integer(unsigned(readReg2)));
end Behavioral;
