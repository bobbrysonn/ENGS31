library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


ENTITY FourDigitCounter IS
PORT ( 	CE,clk	:	in	STD_LOGIC;
        TC		:	out	STD_LOGIC);
end FourDigitCounter;


ARCHITECTURE Structural of FourDigitCounter is

component DecadeCounter
PORT ( 	CE,clk	:	in	STD_LOGIC;
        TC		:	out	STD_LOGIC);
end component;

--create intermediate signals (used to wire up the multiple decade counters)
signal CE_tens, CE_hundreds, CE_thousands : std_logic;


BEGIN

	--Define the 4 different decade counters. Wire them up to the appropriate signals and inputs/outputs of the top-level.
    Ones: DecadeCounter
    port map (
        CE => CE,
        clk => CLK,
        TC => CE_tens
    );

    Tens: DecadeCounter
    port map (
        CE => CE_tens,
        clk => CLK,
        TC => CE_hundreds
    );

    Hundreds: DecadeCounter
    port map (
        CE => CE_hundreds,
        clk => CLK,
        TC => CE_thousands
    );

    Thousands: DecadeCounter
    port map (
        CE => CE_thousands,
        clk => CLK,
        TC => TC
    );

end Structural;