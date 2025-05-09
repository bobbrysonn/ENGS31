library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY CountByN IS
PORT (	clk		: 	in 	STD_LOGIC; -- Clock input
		enable	: 	in 	STD_LOGIC; -- Enable signal for counting
		reset	: 	in 	STD_LOGIC; -- Synchronous reset for the counter
		n		:	in	STD_LOGIC_VECTOR(3 downto 0); -- 4-bit count step size
		count	:	out	STD_LOGIC_VECTOR(7 downto 0); -- 8-bit counter output
        overflow: 	out STD_LOGIC); -- Overflow signal, high for one clock cycle on rollover
end CountByN;

ARCHITECTURE behavior of CountByN is

    -- Internal signal for the 8-bit count register
    signal count_reg    : unsigned(7 downto 0) := (others => '0');
    
    -- Internal signal for the overflow output
    signal overflow_reg : std_logic := '0';

BEGIN

    process(clk)

        -- Variable to hold the intermediate sum of count_reg + n
        variable temp_sum : unsigned(8 downto 0); 

    begin

        if rising_edge(clk) then

            -- If reset is high, the counter is set to 0 and overflow is cleared.
            if reset = '1' then
                count_reg    <= (others => '0'); -- Reset count to 0
                overflow_reg <= '0';             -- Clear overflow flag

            -- If not reset, check if counting is enabled.
            elsif enable = '1' then

                -- Perform addition
                -- The sum is stored in a 9-bit variable (temp_sum) to detect overflow.
                temp_sum := ('0' & count_reg) + ("0000" & unsigned(n));

                -- Check if overflow occurred
                if temp_sum(8) = '1' then 
                    overflow_reg <= '1';
                else
                    overflow_reg <= '0'; -- Clear overflow flag
                end if;
                
                -- Update count_reg with the lower 8 bits of the sum
                count_reg <= temp_sum(7 downto 0); 

            -- If not reset and not enabled (enable = '0'), the counter holds its current value.
            else 

                overflow_reg <= '0'; 

            end if;
        end if;
    end process;

    -- Assign internal registered signals to output ports
    count    <= std_logic_vector(count_reg);
    overflow <= overflow_reg;                

end behavior;