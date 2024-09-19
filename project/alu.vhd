-- alu.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        A       : in  STD_LOGIC_VECTOR(31 downto 0);
        B       : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUOp   : in  STD_LOGIC_VECTOR(3 downto 0);
        Result  : out STD_LOGIC_VECTOR(31 downto 0);
        Zero    : out STD_LOGIC
    );
end alu;

architecture Behavioral of alu is
begin
    process(A, B, ALUOp)
    begin
        case ALUOp is
            when "0000" => Result <= A + B;            -- ADD
            when "0001" => Result <= A - B;            -- SUB
            when "0010" => Result <= A and B;          -- AND
            when "0011" => Result <= A or B;           -- OR
            when "0100" => Result <= A xor B;          -- XOR
            when "0101" => 
                if (signed(A) < signed(B)) then        -- SLT
                    Result <= (others => '1');
                else
                    Result <= (others => '0');
                end if;
            when others => Result <= (others => '0');
        end case;

        if Result = (others => '0') then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process;
end Behavioral;
