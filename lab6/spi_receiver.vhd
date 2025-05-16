--=============================================================
--Ben Dobbins
--ES31/CS56
--This script is the SPI Receiver code for Lab 6, the voltmeter.
--Your name goes here: Bob Moriasi
--=============================================================

--=============================================================
--Library Declarations
--=============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;			
use ieee.math_real.all;				
library UNISIM;
use UNISIM.Vcomponents.ALL;

--=============================================================
--Entity Declarations
--=============================================================
entity spi_receiver is
	generic(
		N_SHIFTS 				: integer);
	port(
	    --1 MHz serial clock
		clk_port				: in  std_logic;	
    	
    	--controller signals
		take_sample_port 		: in  std_logic;	
		spi_cs_port			    : out std_logic;    

        --datapath signals
		spi_s_data_port		    : in  std_logic;
		adc_data_port			: out std_logic_vector(11 downto 0));
end spi_receiver; 

--=============================================================
--Architecture + Component Declarations
--=============================================================
architecture Behavioral of spi_receiver is
--=============================================================
--Local Signal Declaration
--=============================================================
-- Datapath control signals
signal shift_enable		: std_logic := '0';
signal load_enable		: std_logic := '0';

-- Datapath shift register 
signal shift_reg	    : std_logic_vector(11 downto 0) := (others => '0');

-- FSM state type and signals
type state_type is (S_IDLE, S_ASSERT_CS, S_SHIFT_DATA, S_LATCH_DATA);
signal current_state    : state_type := S_IDLE;
signal next_state       : state_type := S_IDLE;

-- Counter for tracking number of shifted bits
signal bit_count        : integer range 0 to N_SHIFTS := 0;
signal counter_reset_s  : std_logic := '0'; -- Internal signal to reset bit_count
signal counter_inc_s    : std_logic := '0'; -- Internal signal to increment bit_count

begin
--=============================================================
--Controller:
--=============================================================

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--State Update:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
state_update_proc: process(clk_port)
begin
    if rising_edge(clk_port) then
        current_state <= next_state;
    end if;
end process state_update_proc;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Next State Logic:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
next_state_logic_proc: process(current_state, take_sample_port, bit_count)
begin
    next_state <= current_state; 

    case current_state is

        when S_IDLE =>
            if take_sample_port = '1' then
                next_state <= S_ASSERT_CS;
            else
                next_state <= S_IDLE;
            end if;

        when S_ASSERT_CS =>
            -- Asserts CS and prepares for shifting.
            next_state <= S_SHIFT_DATA;

        when S_SHIFT_DATA =>
            if bit_count = (N_SHIFTS - 1) then 
                next_state <= S_LATCH_DATA;
            else
                next_state <= S_SHIFT_DATA;
            end if;

        when S_LATCH_DATA =>
            -- Latches the data and de-asserts CS.
            next_state <= S_IDLE;
            
        when others =>
             next_state <= S_IDLE;

    end case;
end process next_state_logic_proc;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Output Logic:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
output_logic_proc: process(current_state)
begin

    spi_cs_port     <= '1';
    shift_enable    <= '0';
    load_enable     <= '0';
    counter_reset_s <= '0';
    counter_inc_s   <= '0';

    case current_state is
        when S_IDLE =>
            spi_cs_port     <= '1';
            shift_enable    <= '0';
            load_enable     <= '0';
            counter_reset_s <= '1'; -- Keep counter at 0
            counter_inc_s   <= '0';

        when S_ASSERT_CS =>
            spi_cs_port     <= '0'; -- Assert CS
            shift_enable    <= '1'; -- Enable shifting for the next state
            load_enable     <= '0';
            counter_reset_s <= '1'; -- Ensure counter starts from 0 for the shifting phase
            counter_inc_s   <= '0';

        when S_SHIFT_DATA =>
            spi_cs_port     <= '0'; -- Keep CS asserted
            shift_enable    <= '1'; -- Keep shifting enabled
            load_enable     <= '0';
            counter_reset_s <= '0';
            counter_inc_s   <= '1'; -- Increment bit counter

        when S_LATCH_DATA =>
            spi_cs_port     <= '1'; -- De-assert CS
            shift_enable    <= '0'; -- Disable shifting
            load_enable     <= '1'; -- Enable parallel load of adc_data
            counter_reset_s <= '0'; 
            counter_inc_s   <= '0'; 
                                    
        when others =>
            spi_cs_port     <= '1';
            shift_enable    <= '0';
            load_enable     <= '0';
            counter_reset_s <= '1'; 
            counter_inc_s   <= '0';

    end case;
end process output_logic_proc;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Bit Counter:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
bit_counter_proc: process(clk_port)
begin
    if rising_edge(clk_port) then
        if counter_reset_s = '1' then
            bit_count <= 0;
        elsif counter_inc_s = '1' then
            if bit_count < N_SHIFTS then
                 bit_count <= bit_count + 1;
            end if;
        end if;
    end if;
end process bit_counter_proc;

--=============================================================
--Datapath:
--=============================================================
-- This shift register captures the 12 data bits from the ADC.
-- It shifts left, with spi_s_data_port coming into the LSB (bit 0).
-- After N_SHIFTS total shifts (including preamble bits which are shifted out),
-- this register will hold the 12 actual data bits, with MSB at shift_reg(11)
-- and LSB at shift_reg(0).
shift_register_proc: process(clk_port) 
begin
	if rising_edge(clk_port) then
		if shift_enable = '1' then 
            shift_reg <= shift_reg(10 downto 0) & spi_s_data_port;
		end if;
		
		if load_enable = '1' then 
            adc_data_port <= shift_reg;
		end if;
    end if;
end process shift_register_proc;

end Behavioral;