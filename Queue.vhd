-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Queue IS
PORT ( 	clk		:	in	STD_LOGIC; --10 MHz clock
		Write	: 	in 	STD_LOGIC;
		Read	: 	in 	STD_LOGIC;
        Data_in	:	in	STD_LOGIC_VECTOR(7 downto 0);
		Data_out:	out	STD_LOGIC_VECTOR(7 downto 0);
        Empty	:	out	STD_LOGIC;
        Full	:	out	STD_LOGIC);
end Queue;


architecture behavior of Queue is

CONSTANT QUEUE_LENGTH : integer := 8;

type regfile is array(0 to QUEUE_LENGTH-1) of STD_LOGIC_VECTOR(7 downto 0);
signal Queue_reg : regfile := (others =>(others => '0'));

signal W_ADDR : integer := 0;
signal R_ADDR : integer := 0;
signal Element_cnt : integer := 0;
signal Full_sig, Empty_sig : std_logic := '0';

BEGIN

--------------
-- Element_cnt 
--------------
process(all)
begin
    if rising_edge(clk) then
        if Write = '1' and Full_sig = '0' then
            Element_cnt <= Element_cnt + 1;
        end if;

        if Read = '1' and Empty_sig = '0' then
            Element_cnt <= Element_cnt - 1;
        end if;
    end if;

    Empty_sig <= '0';
    if Element_cnt = 0 then
        Empty_sig <= '1';
    end if;

    Full_sig <= '0';
    if Element_cnt = 8 then
        Full_sig <= '1';
    end if;
end process;

---------------------
-- Read Address Count
---------------------
process(all)
begin
    if rising_edge(clk) then
        if Read = '1' and Empty_Sig = '0' then
            if R_ADDR <= 7 then
                R_ADDR <= 0;
            else
                R_ADDR <= R_ADDR + 1;
            end if;
        end if;
    end if;
end process;

---------------------
-- Write Address Count
---------------------
process(all)
begin
    if rising_edge(clk) then
        if Write = '1' and Full_Sig = '0' then
            if W_ADDR = 7 then
                W_ADDR <= 0;
            else
                W_ADDR <= W_ADDR + 1;
            end if;
        end if;
    end if;
end process;

------------------
-- Regfile process
------------------
process(all)
begin
    if rising_edge(clk) then
        if Write = '1' and Full_Sig = '0' then
            Queue_reg(W_ADDR) <= Data_in;
        end if;
    end if;
end process;

--Assign internal signals to the outputs
Full <= Full_sig;
Empty <= Empty_sig;

--We always want the Data_out to be displaying the front of the queue
Data_out <= Queue_reg(R_ADDR);

end behavior;
        
        