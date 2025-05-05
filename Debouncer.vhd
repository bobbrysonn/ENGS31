-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


ENTITY Debouncer IS
PORT ( 	clk				:	in	STD_LOGIC;
		Switch_In		:	in	STD_LOGIC;
        Debounce_Out	:	out	STD_LOGIC);
end Debouncer;


ARCHITECTURE behavior of Debouncer is
    constant CLK_PERIOD : time := 10 ns;

    type state_type is (idle_low, idle_high, wait_low, wait_high);

    signal curr_state, next_state : state_type := idle_low;

BEGIN

    output_logic: PROCESS(ALL)
    begin
        case (curr_state) is
            when idle_low => Debounce_Out <= '0';
            when idle_high => Debounce_Out <= '1';
            when wait_low => Debounce_Out <= '0';
            when wait_high => Debounce_Out <= '1';
            when others => next_state <= idle_low;
        end case;
    end process;

    state_logic: PROCESS(ALL)
    begin
        next_state <= idle_low;

        case (curr_state) IS 
            when idle_low =>
                if Switch_In = '1' then
                    next_state <= wait_low;
                end if;

            when idle_high =>
                if Switch_In = '0' then
                    next_state <= wait_high;
                end if;

            when wait_low =>
                wait for 100 * CLK_PERIOD;

                if Switch_In = '1' then
                    next_state <= idle_high;
                end if;

            when wait_high =>
                wait for 100 * CLK_PERIOD;

                if Switch_In = '0' then
                    next_state <= idle_low;
                end if;

            WHEN others => next_state <= idle_low;
        END CASE;
    END PROCESS;

	state_update: PROCESS(clk)
    BEGIN 
        if rising_edge(clk) then
            curr_state <= next_state;
        end if;
    END PROCESS;

end behavior;