library IEEE;
use IEEE.std_logic_1164.all;

entity FourDigitCounter_tb is
end FourDigitCounter_tb;

architecture testbench of FourDigitCounter_tb is

component FourDigitCounter
PORT ( 	CE,clk	:	in	STD_LOGIC;
        TC		:	out	STD_LOGIC);
end component;

signal 	CE, clk, TC	:	STD_LOGIC := '0';



begin

uut : FourDigitCounter PORT MAP(
	clk => clk,
    CE => CE,
    TC => TC);
    
    
    
    clk_proc : process
    begin
    	clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process clk_proc;
    
stim_proc : process
BEGIN
	wait for 20 ns;
	
    CE <= '1';
    
 
    wait;
    
END PROCESS stim_proc;

end testbench;