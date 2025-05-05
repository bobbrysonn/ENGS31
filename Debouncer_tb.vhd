-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity Debouncer_tb is
end Debouncer_tb;

architecture testbench of Debouncer_tb is

component Debouncer
PORT ( 	clk			:	in	STD_LOGIC;
		Switch_In	:	in	STD_LOGIC;
        Debounce_Out:	out	STD_LOGIC);
end component;

signal 	clk, Switch_in, Debounce_Out	:	STD_LOGIC := '0';

begin

uut : Debouncer PORT MAP(
	clk => clk,
    Switch_In => Switch_In,
    Debounce_Out => Debounce_Out);
    

clk_proc : process
BEGIN
	clk <='0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;    
END PROCESS clk_proc;

    
stim_proc : process
BEGIN
	Switch_in <= '0';
    wait for 75 ns;
    
    --switch is pressed and bounces for a while    
    Switch_In <= '1';
    wait for 84 ns;
    
    Switch_in <= '0';
    wait for 130 ns;
    
    Switch_In <= '1';
    wait for 50 ns;
    
    Switch_in <= '0';
    wait for 100 ns;
    
    Switch_In <= '1';
    wait for 36 ns;
    
    Switch_in <= '0';
    wait for 120 ns;
    
    -- Switch is now on for 5 us
    Switch_In <= '1';
    wait for 5 us;
    
   --switch is released and bounces for a while 
    Switch_in <= '0';
    wait for 80 ns;
    
    Switch_In <= '1';
    wait for 134 ns;
    
    Switch_in <= '0';
    wait for 14 ns;
    
    Switch_In <= '1';
    wait for 99 ns;
    
    Switch_in <= '0';
    wait for 209 ns;
    
    Switch_In <= '1';
    wait for 306 ns;
    
    Switch_in <= '0';
    wait for 5 us;
    
END PROCESS stim_proc;

end testbench;