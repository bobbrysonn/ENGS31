library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Stack IS
PORT ( 	clk		:	in	STD_LOGIC; --10 MHz clock
		Push	: 	in 	STD_LOGIC;
		Pop		: 	in 	STD_LOGIC;
        Clear	: 	in	STD_LOGIC;
        Data_in	:	in	STD_LOGIC_VECTOR(7 downto 0);
        Full	:	out	STD_LOGIC;
        Empty	:	out	STD_LOGIC;
		Data_out:	out	STD_LOGIC_VECTOR(7 downto 0));
end Stack;


architecture behavior of Stack is

    constant STACK_DEPTH: integer := 8;

    type t_stack_reg is array(0 to STACK_DEPTH - 1) of std_logic_vector(7 downto 0);

    -- Stack declaration
    signal sp : integer := 0; -- Stack pointer. Starts at 0
    signal stack_reg : t_stack_reg := (others => (others => '0'));

begin

--code your design here. This is all done with datapath components (no FSM).
--Carefully think about which elements should be synchronous versus asynchronous

    stack_proc: process(clk)
    begin
        -- Push, pop, clear are synchronous
        if rising_edge(clk) then

            if Clear = '1' then

                stack_reg <= (others => (others => '0'));
                sp <= 0;

            elsif Pop = '1' then

                -- Check if stack is empty
                if sp > 0 then
                    sp <= sp - 1;
                end if;

            elsif Push = '1' then

                -- Check if stack is full
                if sp < STACK_DEPTH then
                    stack_reg(sp) <= Data_in;
                    sp <= sp + 1;
                end if;

            end if;
        end if;

    end process stack_proc;

    
    -- Asynchronous assignments
    process (sp, stack_reg)
    begin

        if sp > 0 then

            Data_out <= stack_reg(sp - 1);

        else

            Data_out <= "00000000";

        end if;

    end process;

    Empty <= '1' when sp = 0 else '0';
    Full  <= '1' when sp = STACK_DEPTH else '0';

end behavior;
        
        