library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab5_controller_tb is
end entity;

architecture testbench of lab5_controller_tb is

	-- Simulation clock period 100 MHz
    constant CLK_PERIOD : time := 10 ns;

    component lab5_controller is
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
    end component;

    -- Inputs to UUT
    signal tb_clk           : std_logic := '0';
    signal tb_op            : std_logic := '0';
    signal tb_clear         : std_logic := '0';

    -- Outputs from UUT
    signal tb_term1_en      : std_logic;
    signal tb_term2_en      : std_logic;
    signal tb_sum_en        : std_logic;
    signal tb_reset         : std_logic;

begin

    --Instantiate the Unit Under Test (UUT)
    uut: lab5_controller
        port map(
            clk_port        => tb_clk,
            load_port       => tb_op,    -- Connect to tb_op
            clear_port      => tb_clear, -- Connect to tb_clear
            term1_en_port   => tb_term1_en,
            term2_en_port   => tb_term2_en,
            sum_en_port     => tb_sum_en,
            reset_port      => tb_reset );

    --Clock Generation Process
    clkgen_proc: process
    begin
		tb_clk <= '0';
		wait for CLK_PERIOD / 2;

		tb_clk <= '1';
		wait for CLK_PERIOD / 2;
    end process clkgen_proc;

    --Stimulus Process
    stim_proc: process

        -- Procedure to simulate a monopulse for one clock cycle
        procedure pulse(signal sig : out std_logic) is
        begin

            sig <= '1';
            wait for CLK_PERIOD;
            
            sig <= '0';
            wait for CLK_PERIOD;

        end procedure pulse;

    begin

        tb_op    <= '0';
        tb_clear <= '0';

        wait for CLK_PERIOD * 2;

        -- Test 1: Initial State Check
        -- Check initial outputs (reset='1', others='0' in S_Idle)
        wait for CLK_PERIOD * 5;

        -- Test 2: Asynchronous Reset Test (Pulse Clear)
		-- Check state returns to S_Idle (reset='1', others='0')
        pulse(tb_clear);
        wait for CLK_PERIOD * 5;

        -- Test 3: Normal Operation Sequence
        -- 3a: S_Idle -> S_GotA
		-- Check state is S_GotA (term1_en='1', reset='0', others='0')
        pulse(tb_op);
        wait for CLK_PERIOD * 5;

        -- 3b: S_GotA -> S_GotB
        -- Check state is S_GotB (term2_en='1', reset='0', others='0')
        pulse(tb_op);
        wait for CLK_PERIOD * 5;

        -- 3c: S_GotB -> S_ShowY
        -- Check state is S_ShowY (sum_en='1', reset='0', others='0')
        pulse(tb_op);
        wait for CLK_PERIOD * 5;

        -- Stay in S_ShowY until cleared

        -- Test 4: Reset during Operation
		-- Check state returns to S_Idle (reset='1', others='0')
        pulse(tb_clear);
        wait for CLK_PERIOD * 5;

        -- mid-sequence reset test
        pulse(tb_op); -- Idle -> GotA
        wait for CLK_PERIOD * 2;

		-- Should go back to Idle
        pulse(tb_clear);
        wait for CLK_PERIOD * 5;

        wait;
    end process stim_proc;

end testbench;