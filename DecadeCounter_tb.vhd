library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity DecadeCounter_tb is
end entity DecadeCounter_tb;

architecture rtl_tb of DecadeCounter_tb is

    constant CLK_PERIOD : time := 5 ns;

    signal CE   : std_logic := '0';
    signal CLK  : std_logic := '0';
    signal TC   : std_logic := '0'; 

    component DecadeCounter
        port (
            CE,clk  : in    std_logic;
            TC      : out   std_logic
        );
    end component;

begin

    dut: DecadeCounter
    port map (
        CE      => CE,
        CLK     => CLK,
        TC      => TC
    );

    CLK <= not CLK after CLK_PERIOD;

    stim: process
    begin
        CE <= '0';
        wait for 4 * CLK_PERIOD;

        CE <= '1';
        wait for 100 * CLK_PERIOD;

        CE <= '0';
        wait for 4 * CLK_PERIOD;

        wait;
    end process;

end;