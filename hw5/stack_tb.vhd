-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity Stack_tb is
end Stack_tb;

architecture testbench of Stack_tb is

component Stack IS
PORT ( 	clk		:	in	STD_LOGIC; --10 MHz clock
		Push	: 	in 	STD_LOGIC;
		Pop		: 	in 	STD_LOGIC;
        Clear	: 	in	STD_LOGIC;
        Data_in	:	in	STD_LOGIC_VECTOR(7 downto 0);
        Full	:	out	STD_LOGIC;
        Empty	:	out	STD_LOGIC;
		Data_out:	out	STD_LOGIC_VECTOR(7 downto 0));
end component;



signal 	clk		:	STD_LOGIC := '0'; --10 MHz clock
signal 	Push	: 	STD_LOGIC := '0';
signal 	Pop		: 	STD_LOGIC := '0';
signal 	Clear	: 	STD_LOGIC := '0';
signal 	Data_in	:	STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal 	Full	:	STD_LOGIC := '0';
signal 	Empty	:	STD_LOGIC := '0';
signal 	Data_out:	STD_LOGIC_VECTOR(7 downto 0) := (others => '0');


begin

uut : Stack PORT MAP(
		clk  => CLK,
		Push => Push,
        Pop => Pop,
        Clear => Clear,
        Data_in => Data_in,
        Full => Full,
        Empty => Empty,
		Data_out => Data_out);
    
    
clk_proc : process
BEGIN

  CLK <= '0';
  wait for 5 ns;   

  CLK <= '1';
  wait for 5 ns;

END PROCESS clk_proc;

stim_proc : process
begin
	
    wait for 10 ns;
    
    Data_in <= "00000001";--0x01
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';

	Wait for 10 ns;
    Data_in <= "00000011";--0x03
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
    
    Wait for 10 ns;
    Data_in <= "00000111";--0x07
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';

	Wait for 10 ns;
    Data_in <= "00001111";--0x0F
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
    
    Wait for 10 ns;
    Data_in <= "00011111";--0x1F
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
	
    Wait for 10 ns;
    Data_in <= "00111111";--0x3F
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
    
    Wait for 10 ns;
    Data_in <= "01111111";--0x7F
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
	
    Wait for 10 ns;
    Data_in <= "11111111";--0xFF
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
    
    Wait for 10 ns;
    Data_in <= "01010101";--0x55 (the stack should be full and this won't get put anywhere)
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
    
    
    wait for 20 ns;
    Pop <= '1';
    wait for 10 ns;
    Pop <= '0';
    
    wait for 20 ns;
    Pop <= '1';
    wait for 10 ns;
    Pop <= '0';
    
    Wait for 10 ns;
    Data_in <= "10101010";--0xAA
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
    
    
    wait for 20 ns;
    Pop <= '1';
    wait for 10 ns;
    Pop <= '0';
    
    wait for 20 ns;
    Clear <= '1';
    wait for 10 ns;
    Clear <= '0';
    
    Wait for 10 ns;
    Data_in <= "01111111";--0x7F
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
	
    Wait for 10 ns;
    Data_in <= "11111111";--0xFF
    Push <= '1';
    Wait for 10 ns;
    Push <= '0';
    
    wait for 20 ns;
    Pop <= '1';
    wait for 10 ns;
    Pop <= '0';
    
     wait for 20 ns;
    Pop <= '1';
    wait for 10 ns;
    Pop <= '0';
    
     wait for 20 ns; --(The stack should be empty and nothing happens)
    Pop <= '1';
    wait for 10 ns;
    Pop <= '0';
    
    wait;
end process stim_proc;
end testbench;