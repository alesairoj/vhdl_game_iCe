library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dibuja is
	Port (
            button_up    : in std_logic;
            button_down  : in std_logic;
            button_left  : in std_logic;
            button_right : in std_logic;
            R            : out STD_LOGIC;
            G            : out STD_LOGIC;
            B            : out STD_LOGIC;
            eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
            eje_y        : in STD_LOGIC_VECTOR (9 downto 0));
end dibuja;

architecture Behavioral of dibuja is
	signal p_O1, p_O2, p_O3 : STD_LOGIC;
        signal buttons : std_logic_vector(3 downto 0);

begin

	process(eje_x, eje_y)
	begin
            buttons <= button_up & button_down & button_left & button_right;
           case buttons is
               when "0000" =>
                   R <= '1'; G <= '0'; B <= '0';
               when "0001" =>
                   R <= '0'; G <= '1'; B <= '0';
               when "0010" =>
                   R <= '0'; G <= '0'; B <= '1';
               when "0100" =>
                   R <= '0'; G <= '1'; B <= '1';
               when "1000" =>
                   R <= '1'; G <= '1'; B <= '0';
               when others =>
                   R <= '1'; G <= '1'; B <= '1';
           end case;
--	if((to_integer(unsigned(eje_y)) > 119) and (to_integer(unsigned(eje_y)) <359)) then
--		R<='1'; G<='1'; B<='0';
--	else
--		R<='1'; G<='0'; B<='0';
--	end if;
	end process;

end Behavioral;
