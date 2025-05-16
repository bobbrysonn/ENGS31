-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity BlockMemory_tb is
end BlockMemory_tb;

architecture testbench of BlockMemory_tb is

component BlockMemory IS
PORT ( 	cLK				:	in	STD_LOGIC; 
		W_ADDR, R_ADDR	: 	in 	STD_LOGIC_VECTOR(7 downto 0);
		W_DATA				: 	in 	STD_LOGIC_VECTOR(15 downto 0);
        CLEAR, W_EN	: 	in	STD_LOGIC;
        R_DATA	:	out	STD_LOGIC_VECTOR(15 downto 0));
end COMPONENT BlockMemory;



signal 	CLK		:	STD_LOGIC := '0'; --10 MHz clock
signal 	W_ADDR	: 	STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal 	R_ADDR	: 	STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal	W_DATA	:	STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal	R_DATA	:	STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal 	CLEAR	: 	STD_LOGIC := '0';
signal 	W_EN	:	STD_LOGIC := '0';


begin

uut : BlockMemory PORT MAP(
		clk  => CLK,
		W_ADDR => W_ADDR,
        R_ADDR => R_ADDR,
        W_DATA => W_DATA,
        CLEAR => CLEAR,
        W_EN => W_EN,
       	R_DATA => R_DATA);
    
    
clk_proc : process
BEGIN

  CLK <= '0';
  wait for 5 ns;   

  CLK <= '1';
  wait for 5 ns;

END PROCESS clk_proc;

stim_proc : process
begin
	
    R_ADDR <= "00000011"; --3
    
    wait for 10 ns;
    
    W_DATA <= "0000000100000001";--0x0101
    W_ADDR <= "00000000"; --0
    W_EN <= '1';
    Wait for 10 ns;
    W_EN <= '0';

	Wait for 10 ns;
    W_DATA<= "0000001100000011";--0x0303
    W_ADDR <= "00000001"; --1
    W_EN <= '1';
    Wait for 10 ns;
    W_EN <= '0';
    
    Wait for 10 ns;
    W_DATA <= "0000011100000111";--0x0707
    W_ADDR <= "00000010"; --2
    W_EN <= '1';
    Wait for 10 ns;
    W_EN <= '0';

	Wait for 10 ns;
    W_DATA <= "0000111100001111";--0x0F0F
    W_ADDR <= "00000011"; --3
   	W_EN <= '1';
    Wait for 10 ns;
    W_EN <= '0';
    
    Wait for 10 ns;
    W_DATA <= "0001111100011111";--0x1F1F
    W_ADDR <= "00000100"; --4
    W_EN <= '1';
    Wait for 10 ns;
    W_EN <= '0';
	
    Wait for 10 ns;
    W_DATA <= "0011111100111111";--0x3F3F
    W_ADDR <= "00000101"; --5
    W_EN <= '1';
    Wait for 10 ns;
    W_EN <= '0';
    
    Wait for 10 ns;
    W_DATA <= "0111111101111111";--0x7F7F
    W_ADDR <= "00000110"; --6
    W_EN <= '1';
    Wait for 10 ns;
    W_EN <= '0';
	
    Wait for 10 ns;
    W_DATA <= "1111111111111111";--0xFFFF
    W_ADDR <= "00000111"; --7
    W_EN <= '1';
    Wait for 10 ns;
    W_EN <= '0';
    
    --Cycle through each location in memory
    R_ADDR <= "00000001"; --1
    wait for 10 ns;
    R_ADDR <= "00000010"; --2
    wait for 10 ns;
    R_ADDR <= "00000011"; --3
    wait for 10 ns;
    R_ADDR <= "00000100"; --4
    wait for 10 ns;
    R_ADDR <= "00000101"; --5
    wait for 10 ns;
    R_ADDR <= "00000110"; --6
    wait for 10 ns;
    R_ADDR <= "00000111"; --7
    wait for 10 ns;
    
    --Clear the memory
    wait for 10 ns;
    CLEAR <= '1';
    wait for 10 ns;
    CLEAR <= '0';
    wait for 10 ns;
  
  	 --Cycle through each location in memory
    R_ADDR <= "00000000"; --0
    wait for 10 ns;
    R_ADDR <= "00000001"; --1
    wait for 10 ns;
    R_ADDR <= "00000010"; --2
    wait for 10 ns;
    R_ADDR <= "00000011"; --3
    wait for 10 ns;
    R_ADDR <= "00000100"; --4
    wait for 10 ns;
    R_ADDR <= "00000101"; --5
    wait for 10 ns;
    R_ADDR <= "00000110"; --6
    wait for 10 ns;
    R_ADDR <= "00000111"; --7
    wait for 10 ns;
    
    wait;
end process stim_proc;
end testbench;