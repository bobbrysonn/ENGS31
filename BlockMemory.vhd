library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity BlockMemory is 
    port (
        cLK             : in std_logic;
        W_ADDR, R_ADDR  : in std_logic_vector(7  downto 0);
        W_DATA          : in std_logic_vector(15 downto 0);
        CLEAR, W_EN     : in std_logic;
        R_DATA          : out std_logic_vector(15 downto 0)
    );
end BlockMemory;

architecture behavioral of BlockMemory is

    constant ADDRBITS : integer := 8;
    constant REGDEPTH : integer := 2**ADDRBITS;
    constant REGWIDTH : integer := 16;

    type regfile_type is array (0 to REGDEPTH-1) of STD_LOGIC_VECTOR(REGWIDTH-1 downto 0);
    signal regfile : regfile_type := (others => (others => '0'));

begin

    -- Synchronous write
    process (cLK)
    begin

        if rising_edge(cLK) then
            -- Write
            if W_EN = '1' then
                regfile(to_integer(unsigned(W_ADDR))) <= W_DATA;
            end if;

            -- Clear
            if CLEAR = '1' then
                regfile <= (others => (others => '0'));
            end if;
        end if;

    end process;

    -- Asynchronous read
    R_DATA <= regfile(to_integer(unsigned(R_ADDR)));

end architecture;
