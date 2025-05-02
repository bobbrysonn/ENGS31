library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity DecadeCounter_tb is
end entity DecadeCounter_tb;

architecture rtl_tb of DecadeCounter_tb is

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
        TC      => TC;
    );

end;