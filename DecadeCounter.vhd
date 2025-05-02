library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity DecadeCounter is
    port (
        CE,clk   : in   std_logic;
        TC       : out  std_logic
    );
end entity DecadeCounter;

architecture rtl of DecadeCounter is

    signal counter : unsigned(3 downto 0) := (others => '0');

begin
    -- Counting up
    process(clk)
    begin
        if rising_edge(clk) then
            if CE = '1' then
                counter <=  "0000" when (counter = "1001") else
                            counter + 1;
            end if;
        end if;
    end process;

    -- Emitting TC
    process(counter)
    begin
        TC <=   '1' when (counter = "1001") else
                '0';
    end process;
end architecture;
