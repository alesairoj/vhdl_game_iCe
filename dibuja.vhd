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
        signal cx      : integer range 0 to 15 := 5;
        signal cy      : integer range 0 to 15 := 5;
begin

  process(eje_x, eje_y, button_up, cx, cy)
  begin

    R <= '0';
    G <= '0';
    B <= '0';

    if ((to_integer(unsigned(eje_x)) > 320) and (to_integer(unsigned(eje_x)) < 320 + cx) and (to_integer(unsigned(eje_y)) > 240) and (to_integer(unsigned(eje_y)) < 240 + cy)) then
      R <= '1';
      B <= '1';
    end if;

  end process;
end Behavioral;
