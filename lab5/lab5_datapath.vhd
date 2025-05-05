library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab5_datapath is
    Port (
        --timing:
        clk_port             : in std_logic;

        --control inputs:
        term1_en_port        : in std_logic; -- Enable for storing term 1 (A)
        term2_en_port        : in std_logic; -- Enable for storing term 2 (B)
        sum_en_port          : in std_logic; -- Enable for storing the sum (Y) and overflow
        reset_port           : in std_logic; -- Reset for all registers

        --datapath inputs:
        term_input_port      : in std_logic_vector(3 downto 0); -- Input value from switches

        --datapath outputs:
        term1_display_port   : out std_logic_vector(3 downto 0); -- Displays stored term 1 (A)
        term2_display_port   : out std_logic_vector(3 downto 0); -- Displays stored term 2 (B)
        answer_display_port  : out std_logic_vector(3 downto 0); -- Displays stored sum (Y)
        overflow_port        : out std_logic);                    -- Overflow indicator
end lab5_datapath;

architecture behavioral_architecture of lab5_datapath is

    -- Internal signals to hold the stored values (registers)
    signal term1_reg         : std_logic_vector(3 downto 0) := (others => '0');
    signal term2_reg         : std_logic_vector(3 downto 0) := (others => '0');
    signal sum_reg           : std_logic_vector(3 downto 0) := (others => '0');
    signal overflow_reg      : std_logic := '0';

    -- Internal signal for the full 5-bit sum result (4 bits + carry)
    signal adder_sum_internal: unsigned(4 downto 0); -- Needs 5 bits for A(3:0) + B(3:0)

begin

    -- Process for registering Term 1 (A)
    RegTerm1_Proc: process(clk_port, reset_port)
    begin
        if reset_port = '1' then
            term1_reg <= (others => '0');
        elsif rising_edge(clk_port) then
            if term1_en_port = '1' then
                term1_reg <= term_input_port;
            end if;
        end if;
    end process RegTerm1_Proc;

    -- Process for registering Term 2 (B)
    RegTerm2_Proc: process(clk_port, reset_port)
    begin
        if reset_port = '1' then
            term2_reg <= (others => '0');
        elsif rising_edge(clk_port) then
            if term2_en_port = '1' then
                term2_reg <= term_input_port;
            end if;
        end if;
    end process RegTerm2_Proc;

    -- Combinational logic for the adder
    -- Calculate A + B.
    adder_sum_internal <= unsigned('0' & term1_reg) + unsigned('0' & term2_reg);

    -- Process for registering the Sum (Y) and Overflow status
    RegSumOverflow_Proc: process(clk_port, reset_port)
    begin
        if reset_port = '1' then
            sum_reg <= (others => '0');
            overflow_reg <= '0';
        elsif rising_edge(clk_port) then
            if sum_en_port = '1' then
                sum_reg <= std_logic_vector(adder_sum_internal(3 downto 0)); -- Store lower 4 bits
                overflow_reg <= adder_sum_internal(4);                     -- Store the 5th bit (overflow)
            end if;
        end if;
    end process RegSumOverflow_Proc;

    -- Connect internal registers to output display ports
    term1_display_port  <= term1_reg;
    term2_display_port  <= term2_reg;
    answer_display_port <= sum_reg;
    overflow_port       <= overflow_reg; -- Output the registered overflow status

end behavioral_architecture;