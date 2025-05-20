LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SCI_Transmitter_tb IS
END SCI_Transmitter_tb;

ARCHITECTURE testbench OF SCI_Transmitter_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT SCI_Transmitter
    PORT(
        clk_port        : IN  std_logic;
        Data_port       : IN  std_logic_vector(7 downto 0);
        New_data_port   : IN  std_logic;
        Tx_port         : OUT std_logic;
        Queue_full_port : OUT std_logic
    );
    END COMPONENT;

    -- Inputs
    signal clk_port      : std_logic := '0';
    signal Data_port     : std_logic_vector(7 downto 0) := (others => '0');
    signal New_data_port : std_logic := '0';

    -- Outputs
    signal Tx_port       : std_logic;
    signal Queue_full_port : std_logic;

    -- Clock period definitions
    constant clk_period : time := 100 ns;  -- Assuming a 10 MHz clock

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: SCI_Transmitter PORT MAP (
        clk_port        => clk_port,
        Data_port       => Data_port,
        New_data_port   => New_data_port,
        Tx_port         => Tx_port,
        Queue_full_port => Queue_full_port
    );

    -- Clock process definitions
    clk_process : process
    begin
        clk_port <= '0';
        wait for clk_period/2;
        clk_port <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        New_data_port <= '0';
        Data_port <= (others => '0');

        wait for clk_period * 10;


        Data_port <= "11110000"; --F0
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;

        Data_port <= "00001111"; --0F
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;
        
        Data_port <= "10101010"; --AA
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;

        Data_port <= "01010011"; --53
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;
        
        Data_port <= "11010010"; --D2
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;

        Data_port <= "11111111"; --FF
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;
        
        Data_port <= "00110001"; --31
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;

        Data_port <= "01010101"; --55
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;
		
        Data_port <= "10001100"; --8C
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;
        
        --Now the queue should be full and adding new data should do nothing
        Data_port <= "10101111"; --AF
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;
        
        
        wait for clk_period * 1000; --wait for at least one transmission to be done
        
        Data_port <= "11111010"; --FA
        New_data_port <= '1';  -- Signal that new data is being written
        wait for clk_period;
        New_data_port <= '0';  -- Reset the new data signal
        wait for clk_period * 5;
        
        wait;
    end process;

END testbench;
