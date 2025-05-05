library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab5_controller is
    Port (
        --timing:
        clk_port            : in std_logic;

        --control inputs:
        load_port           : in std_logic;
        clear_port          : in std_logic;

        --control outputs:
        term1_en_port       : out std_logic;
        term2_en_port       : out std_logic;
        sum_en_port         : out std_logic;
        reset_port          : out std_logic);
end lab5_controller;

architecture behavioral_architecture of lab5_controller is

    type state is (S_Idle, S_GotA, S_GotA_Idle, S_GotB, S_GotB_Idle, S_ShowY);

    signal curr_state, next_state : state;

begin

    StateUpdate: process(clk_port, clear_port)
    begin
        if clear_port = '1' then -- Asynchronous clear
            curr_state <= S_Idle;
        elsif rising_edge(clk_port) then -- Synchronous state update
            curr_state <= next_state;
        end if;
    end process StateUpdate;

    NextStateLogic: process(curr_state, load_port)
    begin
        next_state <= curr_state;

        case curr_state is

            when S_Idle =>
                if load_port = '1' then
                    next_state <= S_GotA;
                end if;

            when S_GotA =>
                next_state <= S_GotA_Idle;

            when S_GotA_Idle =>
                if load_port = '1' then 
                    next_state <= S_GotB;
                end if;

            when S_GotB =>
                next_state <= S_GotB_Idle;

            when S_GotB_Idle =>
                if load_port = '1' then
                    next_state <= S_ShowY;
                end if;

            when S_ShowY =>
                -- Stay in S_ShowY until clear_port resets FSM asynchronously
                null;
        end case;
    end process NextStateLogic;

    OutputLogic: process(curr_state)
    begin
        term1_en_port <= '0';
        term2_en_port <= '0';
        sum_en_port   <= '0';
        reset_port    <= '0';

        case curr_state is

            when S_Idle =>
                -- Reset datapath registers in the Idle state
                reset_port <= '1';

            when S_GotA =>
                -- Enable loading and storing the first term (A)
                term1_en_port <= '1';

            when S_GotA_Idle =>
                -- After staying up for a clock cycle, go to idle
                term1_en_port <= '0';

            when S_GotB =>
                -- Enable loading and storing the second term (B)
                term2_en_port <= '1';

            when S_GotB_Idle =>
                -- After staying up for a clock cycle, go to idle
                term2_en_port <= '0';

            when S_ShowY =>
                -- Enable calculating and storage of the sum (Y)
                sum_en_port <= '1';

        end case;
    end process OutputLogic;

end behavioral_architecture;