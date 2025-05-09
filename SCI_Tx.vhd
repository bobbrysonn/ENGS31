-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY SCI_Tx IS
PORT ( 	clk			: 	in 	STD_LOGIC;
		Parallel_in	: 	in 	STD_LOGIC_VECTOR(7 downto 0);
        New_data	:	in	STD_LOGIC;
        Tx			:	out STD_LOGIC);
end SCI_Tx;


ARCHITECTURE behavior of SCI_Tx is


--Datapath elements

constant BAUD_PERIOD : integer := 391; --Number of clock cycles needed to achieve a baud rate of 256,000 given a 100 MHz clock (100 MHz / 256000 = 391)

--creat your other datapath elements here

BEGIN


--Datapath
datapath : process(clk) 
begin
	--synchronous components
    if rising_edge(clk) then                
        
    end if;
    
    --asynchronous components
    
    
end process datapath;

--don't forget to hard-wire the LSB of the Shift Register to the output Tx.


end behavior;
        
        