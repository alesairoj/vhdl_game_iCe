library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity selector is
	Port (
		     R_en1 : in STD_LOGIC;
		     G_en1 : in STD_LOGIC;
		     B_en1 : in STD_LOGIC;
		     R_en2 : in STD_LOGIC;
		     G_en2 : in STD_LOGIC;
		     B_en2 : in STD_LOGIC;
		     R_fon : in STD_LOGIC;
		     G_fon : in STD_LOGIC;
		     B_fon : in STD_LOGIC;
		     R_player : in STD_LOGIC;
		     G_player : in STD_LOGIC;
		     B_player : in STD_LOGIC;
		     R            : out STD_LOGIC;
		     G            : out STD_LOGIC;
		     B            : out STD_LOGIC);
		     --		     xini : in unsigned (9 downto 0);
		     --		     yini : in unsigned (9 downto 0);
		     --reset : in STD_LOGIC;
		     --clk : in STD_LOGIC;
		     --eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
		     --eje_y        : in STD_LOGIC_VECTOR (9 downto 0));
end selector;

architecture Behavioral of selector is
	signal player, enemigo1, enemigo2, fondo, RGB : STD_LOGIC_VECTOR ( 2 downto 0);
	signal enctud : STD_LOGIC;

begin

  enemigo1 <= R_en1 & G_en1 & B_en1;
  enemigo2 <= R_en2 & G_en2 & B_en2;
  player <= R_player & G_player & B_player;
  fondo <= R_fon & G_fon & B_fon;
	R <= RGB(2);
	G <= RGB(1);
	B <= RGB(0);
	
	
	process(enemigo1, player, enemigo2, fondo)
	begin
          if ( ((enemigo1 /= "111") and (player /= "111")) or ((player /= "111") and (enemigo2 /= "111"))) then
			RGB<="100"; --colision
                else
			RGB<= enemigo1 AND player AND enemigo2 and fondo; --no colision
		end if;
	end process;

end Behavioral;
