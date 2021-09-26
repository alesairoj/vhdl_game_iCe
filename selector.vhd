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
                     R_en3 : in STD_LOGIC;
                     G_en3 : in STD_LOGIC;
                     B_en3 : in STD_LOGIC;
		     R_player : in STD_LOGIC;
		     G_player : in STD_LOGIC;
		     B_player : in STD_LOGIC;
		     R_fondo : in STD_LOGIC;
		     G_fondo : in STD_LOGIC;
		     B_fondo : in STD_LOGIC;
                     R_gameover : in STD_LOGIC;
                     G_gameover : in STD_LOGIC;
                     B_gameover : in STD_LOGIC;
                     gameover_en : in STD_LOGIC;
		     R            : out STD_LOGIC;
		     G            : out STD_LOGIC;
		     B            : out STD_LOGIC);
end selector;

architecture Behavioral of selector is
	signal entidades, fondo1, player, enemigo1, enemigo2, enemigo3, gameover, gameover_enabled, RGB : STD_LOGIC_VECTOR ( 2 downto 0);
	signal enctud : STD_LOGIC;

begin
	enemigo1 <= R_en1 & G_en1 & B_en1;
	enemigo2 <= R_en2 & G_en2 & B_en2;
	enemigo3 <= R_en3 & G_en3 & B_en3;
	fondo1 <= R_fondo & G_fondo & B_fondo;
	player <= R_player & G_player & B_player;
	gameover_enabled <= gameover_en & gameover_en & gameover_en;
	gameover <= R_gameover & G_gameover & B_gameover;
	R <= RGB(2);
	G <= RGB(1);
	B <= RGB(0);

	process(enemigo1, player, enemigo2)
	begin
		if ( ((enemigo1 /= "111") and (player /= "111")) or ((player /= "111") and (enemigo2 /= "111")) or ((enemigo3 /= "111") and (player /= "111"))  ) then
			entidades<="100"; --colision
		else
			entidades<= enemigo1 AND player AND enemigo2 AND enemigo3; --no colision
		end if;

		if (entidades /= "111") then
			RGB <= (entidades AND (NOT gameover_enabled)) OR (gameover AND gameover_enabled);
		else
			RGB <= (fondo1 AND (NOT gameover_enabled)) OR (gameover AND gameover_enabled);
		end if;
	end process;

end Behavioral;
