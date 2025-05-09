library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CodeGame_tb is
-- No ports for a testbench
end CodeGame_tb;

architecture Testbench of CodeGame_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    component CodeGame
        Port ( clk : in STD_LOGIC;
               Number : in STD_LOGIC_VECTOR(3 downto 0);
               KeyPress : in STD_LOGIC;
               GT : out STD_LOGIC_VECTOR(3 downto 0);
               EQ : out STD_LOGIC_VECTOR(3 downto 0);
               LT : out STD_LOGIC_VECTOR(3 downto 0);
               Win : out STD_LOGIC;
               Lose : out STD_LOGIC);
    end component;

    -- Inputs
    signal clk : STD_LOGIC := '0';
    signal Number : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal KeyPress : STD_LOGIC := '0';

    -- Outputs
    signal GT : STD_LOGIC_VECTOR(3 downto 0);
    signal EQ : STD_LOGIC_VECTOR(3 downto 0);
    signal LT : STD_LOGIC_VECTOR(3 downto 0);
    signal Win : STD_LOGIC;
    signal Lose : STD_LOGIC;

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: CodeGame Port Map (
        clk => clk,
        Number => Number,
        KeyPress => KeyPress,
        GT => GT,
        EQ => EQ,
        LT => LT,
        Win => Win,
        Lose => Lose
    );

    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process to simulate input conditions
    stim_proc: process
    begin
        -- Initialization Phase
        wait for 10 ns;
        KeyPress <= '0';
        Number <= "0000";
        wait for clk_period * 10;

        -- Testing Code Input
        KeyPress <= '1';
        Number <= "1010"; -- 1st digit of the code
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0101"; -- 2nd digit of the code
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0001"; -- 3rd digit of the code
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
		
         KeyPress <= '1';
        Number <= "1111"; -- 4th digit of the code
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 10;
        
        -- Simulate guesses and check outputs
        KeyPress <= '1';
        Number <= "1011"; -- 1st digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0101"; -- 2nd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0001"; -- 3rd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
		
         KeyPress <= '1';
        Number <= "0000"; -- 4th digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 10;
        
        
        --try number 2
        KeyPress <= '1';
        Number <= "1010"; -- 1st digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0101"; -- 2nd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0001"; -- 3rd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
		
         KeyPress <= '1';
        Number <= "1111"; -- 4th digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 10;
        
         -- Testing Code Input
        KeyPress <= '1';
        Number <= "1010"; -- 1st digit of the code
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0101"; -- 2nd digit of the code
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0001"; -- 3rd digit of the code
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
		
         KeyPress <= '1';
        Number <= "1101"; -- 4th digit of the code
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 10;
        
         -- Simulate guesses and check outputs
        KeyPress <= '1';
        Number <= "1011"; -- 1st digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0101"; -- 2nd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0001"; -- 3rd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
		
         KeyPress <= '1';
        Number <= "0000"; -- 4th digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 10;
        
        
        --try number 2
        KeyPress <= '1';
        Number <= "1010"; -- 1st digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0101"; -- 2nd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0001"; -- 3rd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
		
         KeyPress <= '1';
        Number <= "1111"; -- 4th digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 10;
        
         --try number 2
        KeyPress <= '1';
        Number <= "1010"; -- 1st digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0101"; -- 2nd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0001"; -- 3rd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
		
         KeyPress <= '1';
        Number <= "1111"; -- 4th digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 10;
        
         --try number 2
        KeyPress <= '1';
        Number <= "1010"; -- 1st digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0101"; -- 2nd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
        
        KeyPress <= '1';
        Number <= "0001"; -- 3rd digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 2;
		
         KeyPress <= '1';
        Number <= "1111"; -- 4th digit of the guess
        wait for clk_period;
        KeyPress <= '0';
        wait for clk_period * 10;
        

        -- Finish the simulation
        wait;
    end process;

end Testbench;
