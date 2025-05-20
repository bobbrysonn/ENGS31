library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SCI_Tx IS
    port (
        clk         : in  STD_LOGIC;
        Data_in     : in  STD_LOGIC_VECTOR(7 downto 0);
        Load        : in  STD_LOGIC;
        Tx          : out STD_LOGIC;
        Tx_done     : out STD_Logic
    );
end entity SCI_Tx;

architecture behavior of SCI_Tx is

    constant CLOCK_FREQUENCY_CONST : integer := 10_000_000; -- 10 MHz
    constant BAUD_RATE_CONST       : integer := 256_000;    -- 256 kHz
    constant BAUD_PERIOD_CLOCKS    : integer := CLOCK_FREQUENCY_CONST / BAUD_RATE_CONST; -- 39

    -- Baud rate generator counter. Initialized to 0.
    signal baud_rate_counter_r : integer range 0 to BAUD_PERIOD_CLOCKS - 1 := 0;
    signal baud_tick_s         : std_logic; -- Will be pulsed high

    -- Shift register: Initialized to '1' for idle Tx line.
    signal tx_sreg_r           : std_logic_vector(9 downto 0) := (others => '1');

    -- Bit counter for 10 bits Initialized to 0.
    signal bit_count_r         : integer range 0 to 9 := 0;

    -- FSM states and state register. Initialized to S_IDLE.
    type state_t is (S_IDLE, S_TX_BITS, S_TX_DONE_PULSE);
    signal current_state_r     : state_t := S_IDLE;
    signal next_state_s        : state_t;

begin

    -- Baud Rate Tick Generator: Generates a 1-clock pulse (baud_tick_s) at the baud rate.
    process(clk)
    begin
        if rising_edge(clk) then
            baud_tick_s <= '0'; -- Default to low, pulse high for one system clock cycle
            if current_state_r = S_TX_BITS then -- Only count when actively transmitting bits
                if baud_rate_counter_r < BAUD_PERIOD_CLOCKS - 1 then
                    baud_rate_counter_r <= baud_rate_counter_r + 1;
                else
                    baud_rate_counter_r <= 0;
                    baud_tick_s         <= '1';
                end if;
            else
                -- When not in S_TX_BITS (i.e., S_IDLE or S_TX_DONE_PULSE), reset the baud counter.
                baud_rate_counter_r <= 0; 
            end if;
        end if;
    end process;

    -- FSM State Register: Updates current_state_r on clock edge.
    process(clk)
    begin
        if rising_edge(clk) then
            current_state_r <= next_state_s;
        end if;
    end process;

    -- FSM Combinatorial Logic: Determine next_state_s and control output
    process(current_state_r, Load, baud_tick_s, bit_count_r, tx_sreg_r)
    begin
        next_state_s   <= current_state_r;  -- By default, stay in current state
        Tx             <= '1';              -- Default Tx line to idle (high)
        Tx_done        <= '0';              -- Default Tx_done to low

        case current_state_r is
            when S_IDLE =>
                Tx <= '1'; -- Ensure Tx line is idle
                if Load = '1' then
                    -- When Load is asserted, prepare to start transmission.
                    next_state_s <= S_TX_BITS;
                end if;

            when S_TX_BITS =>
                Tx <= tx_sreg_r(0); -- Output the LSB of the shift register (current bit)
                if baud_tick_s = '1' then
                    if bit_count_r < 9 then
                        next_state_s <= S_TX_BITS; -- Remain in S_TX_BITS
                    else -- bit_count_r is 9,  the 10th bit period has just ended.
                        next_state_s <= S_TX_DONE_PULSE; -- All bits sent, move to signal completion.
                    end if;
                end if;

            when S_TX_DONE_PULSE =>
                Tx      <= '1'; -- Tx line return to idle
                Tx_done <= '1'; -- Tx_done high for this one clock cycle.
                next_state_s <= S_IDLE; -- Transition back to S_IDLE.
        end case;
    end process;

    -- Synchronous Datapath Logic: Update (tx_sreg_r, bit_count_r) on clock edge.
    process(clk)
    begin
        if rising_edge(clk) then
            if current_state_r = S_IDLE and next_state_s = S_TX_BITS then 
                -- Load the shift register
                tx_sreg_r   <= '1' & Data_in & '0'; 
                bit_count_r <= 0;  -- Reset bit counter for the new transmission
            
            elsif current_state_r = S_TX_BITS and baud_tick_s = '1' then
                tx_sreg_r   <= '0' & tx_sreg_r(9 downto 1); -- Shift out the LSB
                if bit_count_r < 9 then
                    bit_count_r <= bit_count_r + 1;
                end if;
            end if;
        end if;
    end process;

end architecture behavior;