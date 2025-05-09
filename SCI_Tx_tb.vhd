-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity SCI_Tx_tb is
end SCI_Tx_tb;

architecture testbench of SCI_Tx_tb is

Component SCI_Tx IS
PORT ( 	clk			: 	in 	STD_LOGIC;
		Parallel_in	: 	in 	STD_LOGIC_VECTOR(7 downto 0);
        New_data	:	in	STD_LOGIC;
        Tx			:	out STD_LOGIC);
end component SCI_Tx;


--inputs
signal CLK : std_logic := '0';
signal Parallel_in : std_logic_vector(7 downto 0) := "00000000";
signal New_Data: std_logic := '1';

--outputs
signal Tx : std_logic := '0';



begin

uut : SCI_Tx PORT MAP(
		clk  => clk,
		Parallel_in => Parallel_in,
        New_data => New_data,
		Tx => Tx);
    
    
clk_proc : process
BEGIN

  CLK <= '0';
  wait for 5ns;   --100 MHz clock

  CLK <= '1';
  wait for 5ns;

END PROCESS clk_proc;

stim_proc : process
begin
	
    Parallel_in <= "10101010";
    wait for 100 ns;
    
    New_data <= '1';
    wait for 10 ns;
    
    new_data <= '0';
    
    wait for 50 us;
    
    
    Parallel_in <= "00100100";    
    New_data <= '1';
    wait for 10 ns;
    
    new_data <= '0';
    
    wait for 50 us;
    
    wait;
end process stim_proc;
end testbench;