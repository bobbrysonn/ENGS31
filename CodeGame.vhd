library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CodeGame is
    Port ( clk      : in  STD_LOGIC;
           Number   : in  STD_LOGIC_VECTOR(3 downto 0); -- Input digit from user
           KeyPress : in  STD_LOGIC;                   -- High for 1 cycle when Number is valid
           GT       : out STD_LOGIC_VECTOR(3 downto 0); -- Code[i] > Guess[i]
           EQ       : out STD_LOGIC_VECTOR(3 downto 0); -- Code[i] = Guess[i]
           LT       : out STD_LOGIC_VECTOR(3 downto 0); -- Code[i] < Guess[i]
           Win      : out STD_LOGIC;                   -- Player B wins
           Lose     : out STD_LOGIC);                  -- Player B loses
end CodeGame;

architecture Behavioral of CodeGame is

    -- FSM State Definition
    type State_type is (sInit, sEnterCode, sEnterGuess, sCheck, sWin, sLose);
    signal current_state, next_state : State_type;

    -- Datapath Registers
    type four_digit_array is array (0 to 3) of STD_LOGIC_VECTOR(3 downto 0);
    signal code_r  : four_digit_array; -- Stores Player A's code
    signal guess_r : four_digit_array; -- Stores Player B's current guess

    -- Counters
    signal digit_idx_r         : unsigned(1 downto 0); -- Counts 0 to 3 for digit entry index
    signal attempts_r          : unsigned(2 downto 0); -- Counts 0 to 4 for guess attempts

    -- Internal Datapath Status Signals (inputs to FSM logic)
    signal digits_entered_4_s   : STD_LOGIC; -- True when 4 digits have been input for current code/guess
    signal code_is_correct_s    : STD_LOGIC; -- True if all guess digits match code digits
    signal attempts_reached_4_s : STD_LOGIC := '0'; -- True if 4 guesses have been made

begin

    -- Datapath Logic

    -- 1. Code and Guess Registers
    process(clk)
    begin
        if rising_edge(clk) then
            -- Actions based on FSM state and KeyPress
            if current_state = sInit then
                code_r <= (others => (others => '0')); -- Clear code register
                guess_r <= (others => (others => '0')); -- Clear guess register
            end if;

            if KeyPress = '1' then
                if current_state = sEnterCode then
                    code_r(to_integer(digit_idx_r)) <= Number;
                elsif current_state = sEnterGuess then
                    guess_r(to_integer(digit_idx_r)) <= Number;
                end if;
            end if;
        end if;
    end process;

    -- 2. Digit Index Counter (for code_r and guess_r)
    process(clk)
    begin
        if rising_edge(clk) then
            if current_state = sInit or next_state = sEnterCode or next_state = sEnterGuess then
                 -- Reset when initializing or when starting a new code/guess entry phase
                if (current_state /= sEnterCode and next_state = sEnterCode) or 
                   (current_state /= sEnterGuess and next_state = sEnterGuess) or
                   current_state = sInit then
                    digit_idx_r <= (others => '0');
                end if;
            end if;
            
            if KeyPress = '1' and (current_state = sEnterCode or current_state = sEnterGuess) then
                if digit_idx_r < 3 then
                    digit_idx_r <= digit_idx_r + 1;
                else
                    digit_idx_r <= (others => '0'); -- Ready for next phase 
                end if;
            end if;
        end if;
    end process;

    -- Status signal: 4 digits entered for the current phase
    digits_entered_4_s <= '1' when KeyPress = '1' and 
                                   (current_state = sEnterCode or current_state = sEnterGuess) and 
                                   digit_idx_r = "11" else '0';

    -- 3. Guess Attempt Counter
    process(clk)
    begin
        if rising_edge(clk) then
            if current_state = sInit then
                attempts_r <= (others => '0');
            elsif current_state = sEnterGuess and digits_entered_4_s = '1' then 
                -- Increment when a full guess has been entered and we are about to check
                if attempts_r < 4 then -- only increment if not already at max useful count for check
                    attempts_r <= attempts_r + 1;
                end if;
            end if;
        end if;
    end process;

    -- Status signal: 4 attempts made (check after current guess is processed)
    attempts_reached_4_s <= '1' when attempts_r = 4 else '0'; -- attempts_r will be 1 after 1st guess, 4 after 4th

    -- 4. Comparators and Game Outputs (GT, EQ, LT)
    comparators_gen: for i in 0 to 3 generate
    begin
        GT(i) <= '1' when code_r(i) > guess_r(i) else '0';
        EQ(i) <= '1' when code_r(i) = guess_r(i) else '0';
        LT(i) <= '1' when code_r(i) < guess_r(i) else '0'; 
    end generate;

    -- Status signal: Current guess is correct
    code_is_correct_s <= EQ(0) and EQ(1) and EQ(2) and EQ(3);


    -- FSM Logic

    -- Process for determining next_state and combinatorial FSM outputs (Win, Lose)
    fsm_next_state_logic: process(current_state, KeyPress, digits_entered_4_s, code_is_correct_s, attempts_reached_4_s)
    begin
        -- Default assignments
        next_state <= current_state; 
        Win <= '0';
        Lose <= '0';

        case current_state is
            when sInit =>
                next_state <= sEnterCode;

            when sEnterCode =>
                if digits_entered_4_s = '1' then -- 4th digit of code was just entered
                    next_state <= sEnterGuess;
                else
                    next_state <= sEnterCode; -- Wait for more digits
                end if;

            when sEnterGuess =>
                if digits_entered_4_s = '1' then -- 4th digit of guess was just entered
                    next_state <= sCheck;
                else
                    next_state <= sEnterGuess; -- Wait for more digits
                end if;

            when sCheck =>
                if code_is_correct_s = '1' then
                    next_state <= sWin;
                elsif attempts_reached_4_s = '1' then -- And code is not correct
                    next_state <= sLose;
                else -- Code incorrect, more attempts left
                    next_state <= sEnterGuess;
                end if;

            when sWin =>
                Win <= '1'; -- Assert Win for one cycle
                next_state <= sInit; -- Go back to init for a new game

            when sLose =>
                Lose <= '1'; -- Assert Lose for one cycle
                next_state <= sInit; -- Go back to init for a new game
                
            when others =>
                next_state <= sInit;

        end case;
    end process fsm_next_state_logic;

    -- Process for updating current_state
    fsm_state_register: process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process fsm_state_register;

end Behavioral;