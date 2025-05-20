LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SCI_Tx_tb IS
END SCI_Tx_tb;

ARCHITECTURE testbench OF SCI_Tx_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT SCI_Tx
    PORT(
        clk      : IN  std_logic;
        Data_in  : IN  std_logic_vector(7 downto 0);
        Load     : IN  std_logic;
        Tx       : OUT std_logic;
        Tx_done  : OUT std_logic
    );
    END COMPONENT;
    
    --Inputs
    signal clk     : std_logic := '0';
    signal Data_in : std_logic_vector(7 downto 0) := (others => '0');
    signal Load    : std_logic := '0';

    --Outputs
    signal Tx      : std_logic;
    signal Tx_done : std_logic;

    -- Clock period definitions
    constant clk_period : time := 100 ns; -- 10 MHz

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: SCI_Tx PORT MAP (
        clk     => clk,
        Data_in => Data_in,
        Load    => Load,
        Tx      => Tx,
        Tx_done => Tx_done
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin        
        -- Initialize Inputs
        Load <= '0';
        Data_in <= (others => '0');
        
        wait for clk_period * 10;
        
        -- Scenario 1: Load data "10101010"
        Data_in <= "10101010";
        Load <= '1';  -- Load the data
        wait for clk_period;
        Load <= '0';

        -- Wait for transmission to complete
        wait for clk_period * 500;
        
        -- Scenario 2: Load data "11001100"
        Data_in <= "11001100";
        Load <= '1';  -- Load the data
        wait for clk_period;
        Load <= '0';

        -- Wait for transmission to complete
        wait for clk_period * 500;

        -- Add more scenarios as necessary

        -- Complete the simulation
        wait;
    end process;

END testbench;
