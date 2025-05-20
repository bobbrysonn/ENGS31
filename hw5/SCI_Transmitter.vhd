library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY SCI_Transmitter IS
PORT (
    clk_port        :   in  STD_LOGIC;
    Data_port       :   in  STD_LOGIC_VECTOR(7 downto 0);
    New_data_port   :   in  STD_LOGIC;
    Tx_port         :   out STD_LOGIC;
    Queue_full_port :   out STD_LOGIC
);
end SCI_Transmitter;

ARCHITECTURE behavior of SCI_Transmitter is

type state_type is (idle, load, transmit);
signal CS, NS : state_type := idle;

signal s_queue_read     : std_logic := '0';
signal s_queue_empty    : std_logic;
signal s_queue_full     : std_logic;
signal s_sci_tx_load    : std_logic := '0';
signal s_sci_tx_done    : std_logic;

Component Queue
PORT (
    clk     :   in  STD_LOGIC;
    Write   :   in  STD_LOGIC;
    read    :   in  STD_LOGIC;
    Data_in :   in  STD_LOGIC_VECTOR(7 downto 0);
    Data_out:   out STD_LOGIC_VECTOR(7 downto 0);
    Empty   :   out STD_LOGIC;
    Full    :   out STD_LOGIC
);
end component;

COMPONENT SCI_Tx
PORT(
    clk      : IN  std_logic;
    Data_in  : IN  std_logic_vector(7 downto 0);
    Load     : IN  std_logic;
    Tx       : OUT std_logic;
    Tx_done  : OUT std_logic
);
END COMPONENT;

signal s_queue_data_out : std_logic_vector(7 downto 0);

begin
    Queue_inst : Queue
    PORT MAP (
        clk         => clk_port,
        Write       => New_data_port,
        read        => s_queue_read,
        Data_in     => Data_port,
        Data_out    => s_queue_data_out,
        Empty       => s_queue_empty,
        Full        => s_queue_full
    );
    Queue_full_port <= s_queue_full;

    SCI_Tx_inst : SCI_Tx
    PORT MAP (
        clk         => clk_port,
        Data_in     => s_queue_data_out,
        Load        => s_sci_tx_load,
        Tx          => Tx_port,
        Tx_done     => s_sci_tx_done
    );

    process(clk_port)
    begin
        if rising_edge(clk_port) then
            CS <= NS;
        end if;
    end process;

    process(CS, s_queue_empty, s_sci_tx_done)
    begin
        s_queue_read    <= '0';
        s_sci_tx_load   <= '0';
        NS              <= CS;
        case CS is
            when idle =>
                if s_queue_empty = '0' then
                    NS <= load;
                else
                    NS <= idle;
                end if;
            when load =>
                s_queue_read  <= '1';
                s_sci_tx_load <= '1';
                NS <= transmit;
            when transmit =>
                if s_sci_tx_done = '1' then
                    NS <= idle;
                else
                    NS <= transmit;
                end if;
        end case;
    end process;
end architecture behavior;