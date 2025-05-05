--=============================================================================
--ENGS 31/ CoSc 56
--Lab 5 Shell
--Ben Dobbins
--Eric Hansen
--=============================================================================

--=============================================================================
--Library Declarations:
--=============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


--=============================================================================
--Entity Declaration:
--=============================================================================
entity lab5_shell is
    Generic(
        CLK_DIVIDER_RATIO : integer := 100; -- Set for 1MHz from 100MHz for synthesis
        STABLE_TIME       : integer := 200 ); -- Default debounce time
    Port (
        clk_ext_port            : in std_logic;                     -- mapped to external IO device (100 MHz Clock)
        term_input_ext_port     : in std_logic_vector(3 downto 0);  -- slide switches SW15 (MSB) down to SW12 (LSB)
        op_ext_port             : in std_logic;                     -- button center
        clear_ext_port          : in std_logic;                     -- button down
        seg_ext_port            : out std_logic_vector(0 to 6);
        dp_ext_port             : out std_logic;
        an_ext_port             : out std_logic_vector(3 downto 0)
    );
end lab5_shell;

--=============================================================================
--Architecture Type:
--=============================================================================
architecture behavioral_architecture of lab5_shell is

    --=============================================================================
    --Sub-Component Declarations:
    --=============================================================================
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --System Clock Generation:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    component system_clock_generation is
        Generic( CLK_DIVIDER_RATIO : integer );
        Port (
            input_clk_port      : in std_logic;
            system_clk_port     : out std_logic);
    end component;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Input Conditioning:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    component button_interface is
        Generic(
            STABLE_TIME : integer );
        Port( clk_port            : in  std_logic;
             button_port         : in  std_logic;
             button_db_port      : out std_logic;
             button_mp_port      : out std_logic);
    end component;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Controller:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    component lab5_controller is
        Port (
            clk_port            : in std_logic;
            load_port           : in std_logic; -- Changed from load_port
            clear_port          : in std_logic;
            term1_en_port       : out std_logic;
            term2_en_port       : out std_logic;
            sum_en_port         : out std_logic;
            reset_port          : out std_logic);
    end component;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Datapath:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    component lab5_datapath is
        Port (
            clk_port             : in std_logic;
            term1_en_port        : in std_logic;
            term2_en_port        : in std_logic;
            sum_en_port          : in std_logic;
            reset_port           : in std_logic;
            term_input_port      : in std_logic_vector(3 downto 0);
            term1_display_port   : out std_logic_vector(3 downto 0);
            term2_display_port   : out std_logic_vector(3 downto 0);
            answer_display_port  : out std_logic_vector(3 downto 0);
            overflow_port        : out std_logic);
    end component;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --7-Segment Display:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    component mux7seg is
        Port ( clk_port     : in  std_logic;
             y3_port        : in  std_logic_vector(3 downto 0);
             y2_port        : in  std_logic_vector(3 downto 0);
             y1_port        : in  std_logic_vector(3 downto 0);
             y0_port        : in  std_logic_vector(3 downto 0);
             dp_set_port    : in  std_logic_vector(3 downto 0);
             seg_port       : out std_logic_vector(0 to 6);
             dp_port        : out std_logic;
             an_port        : out std_logic_vector (3 downto 0) );
    end component;

    --=============================================================================
    --Signal Declarations: (Internal Wires)
    --=============================================================================
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Timing:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    signal system_clk           : std_logic; -- The 1 MHz clock generated internally

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- Button Conditioning Outputs:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    signal op_button_mono       : std_logic; -- Monopulsed OP signal for controller
    signal clear_button_mono    : std_logic; -- Monopulsed CLEAR signal for controller
    -- Debounced signals are not used, map to 'open' in port map

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- Controller <-> Datapath Signals:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    signal term1_en_signal      : std_logic;
    signal term2_en_signal      : std_logic;
    signal sum_en_signal        : std_logic;
    signal reset_datapath_signal: std_logic;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- Datapath -> Display Signals:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    signal term1_display_signal : std_logic_vector(3 downto 0);
    signal term2_display_signal : std_logic_vector(3 downto 0);
    signal answer_display_signal: std_logic_vector(3 downto 0);
    signal overflow             : std_logic := '0'; -- Datapath output for overflow
    signal dp_set               : std_logic_vector(3 downto 0); -- DP control for 7-seg

    --=============================================================================
    --Port Mapping (wiring the component blocks together):
    --=============================================================================
begin
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Wire the system clock generator into the shell with a port map:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    clocking: system_clock_generation
        generic map (
            clk_divider_ratio => clk_divider_ratio -- Pass generic down
        )
        port map(
            input_clk_port  => clk_ext_port,        -- External 100MHz clock in
            system_clk_port => system_clk           -- Internal 1MHz clock out
        );

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Wire the input conditioning block into the shell with a port map:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- Instance for the OP button
    op_monopulse: button_interface
        generic map (
            stable_time         => stable_time      -- Pass generic down
        )
        port map(
            clk_port            => system_clk,      -- Use 1MHz system clock
            button_port         => op_ext_port,     -- External OP button in
            button_db_port      => open,            -- Debounced output not used here
            button_mp_port      => op_button_mono   -- Monopulsed output to controller
        );

    -- Instance for the CLEAR button
    clear_monopulse: button_interface
        generic map (
            stable_time         => stable_time      -- Pass generic down
        )
        port map(
            clk_port            => system_clk,      -- Use 1MHz system clock
            button_port         => clear_ext_port,  -- External CLEAR button in
            button_db_port      => open,            -- Debounced output not used here
            button_mp_port      => clear_button_mono -- Monopulsed output to controller
        );

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Wire the controller into the shell with a port map:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    controller: lab5_controller port map(
            clk_port          => system_clk,            -- Use 1MHz system clock
            load_port         => op_button_mono,        -- Monopulsed OP signal in
            clear_port        => clear_button_mono,     -- Monopulsed CLEAR signal in
            term1_en_port     => term1_en_signal,       -- Enable signal out to Datapath
            term2_en_port     => term2_en_signal,       -- Enable signal out to Datapath
            sum_en_port       => sum_en_signal,         -- Enable signal out to Datapath
            reset_port        => reset_datapath_signal  -- Reset signal out to Datapath
        );

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Wire the datapath into the shell with a port map:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    datapath: lab5_datapath port map(
            clk_port            => system_clk,            -- Use 1MHz system clock
            term1_en_port       => term1_en_signal,       -- Enable signal in from Controller
            term2_en_port       => term2_en_signal,       -- Enable signal in from Controller
            sum_en_port         => sum_en_signal,         -- Enable signal in from Controller
            reset_port          => reset_datapath_signal, -- Reset signal in from Controller
            term_input_port     => term_input_ext_port,   -- External switch inputs in
            term1_display_port  => term1_display_signal,  -- Term 1 value out to Display
            term2_display_port  => term2_display_signal,  -- Term 2 value out to Display
            answer_display_port => answer_display_signal, -- Answer value out to Display
            overflow_port       => overflow               -- Overflow signal out
        );

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Wire the 7-segment display into the shell with a port map:
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    -- overflow signal to the decimal point for the answer digit (y0)
    dp_set <= "000" & overflow; -- dp_set(0) driven by overflow, others '0'

    seven_seg: mux7seg port map(
            clk_port    => system_clk,            -- Use 1MHz system clock
            y3_port     => term1_display_signal,  -- Display Term 1 on leftmost digit
            y2_port     => term2_display_signal,  -- Display Term 2 on center-left digit
            y1_port     => "0000",                -- Center-right digit unused (tied low)
            y0_port     => answer_display_signal, -- Display Answer on rightmost digit
            dp_set_port => dp_set,                -- Connect generated DP control signal
            seg_port    => seg_ext_port,          -- Segments to external pins
            dp_port     => dp_ext_port,           -- Decimal point to external pin
            an_port     => an_ext_port            -- Anodes to external pins
        );

end behavioral_architecture;