-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity CountByN_tb is
end CountByN_tb;

architecture testbench of CountByN_tb is

component CountByN
PORT (	clk, enable, reset 	: 	in 	STD_LOGIC;
		n					:	in	STD_LOGIC_VECTOR(3 downto 0);
		count				:	out	STD_LOGIC_VECTOR(7 downto 0);
        overflow			: 	out STD_LOGIC);
end component;


signal enable 	: std_logic := '0';
signal reset 	: std_logic := '0';
signal clk 		: std_logic := '0';
signal overflow	: std_logic := '0'; 
signal n		: std_logic_vector(3 downto 0) := "0000";
signal count	: std_logic_vector(7 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

uut : CountByN PORT MAP(
	clk => clk,
    enable => enable,
    reset => reset,
    n => n,
    count => count,
    overflow => overflow);
    
    
    
stim_proc : process
BEGIN
	clk <= '0';
	wait for CLK_PERIOD/2;
	clk <= '1';
	wait for CLK_PERIOD/2;
end process stim_proc;

inputs: process
begin
	n <= "1111";
    wait for 200 ns;
    
    enable <= '1';
    wait for 170 ns;
    
    enable <= '0';
    wait for 80 ns;
    
    enable <= '1';
    wait for 10 ns;
    
    enable <= '0';
    wait for 80 ns;
    
    enable <= '1';
    wait for 200 ns;
    
    reset <= '1';
    wait for 80 ns;
    
    reset <= '0';    
    wait;
end process inputs;

end testbench;