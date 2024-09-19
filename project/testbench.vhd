-- processor_tb.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processor_tb is
end processor_tb;

architecture Behavioral of processor_tb is
    -- Component Declaration
    component processor
        Port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC
        );
    end component;

    -- Signals
    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';

    -- Clock period definition
    constant clk_period : time := 10 ns;
begin
    -- Instantiate the processor
    DUT: processor
        Port map (
            clk   => clk,
            reset => reset
        );

    -- Clock Generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin
        -- Hold reset high for a few clock cycles
        wait for 20 ns;
        reset <= '0';
        wait;
    end process;
end Behavioral;
