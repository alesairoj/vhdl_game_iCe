library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_driver is
	Port (
		     clk : in STD_LOGIC;
		     reset : in STD_LOGIC;
		     button_center  : in std_logic;
		     button_left  : in std_logic;
		     button_right : in std_logic;
		     VS : out STD_LOGIC;
		     HS : out STD_LOGIC;
		     R : out STD_LOGIC;
		     G : out STD_LOGIC;
		     B : out STD_LOGIC);
end vga_driver;

architecture Behavioral of vga_driver is
	signal clk_pixel : STD_LOGIC;
	signal O3_compX, O3_compY : STD_LOGIC;
	signal Blank_x, Blank_y : STD_LOGIC;
	signal enable_contY : STD_LOGIC;
	signal R_in, G_in, B_in : STD_LOGIC;
	signal VSsignal : STD_LOGIC;

	--Señales enemigos
	signal R_en1, G_en1, B_en1, R_en2, G_en2, B_en2, R_en3, G_en3, B_en3 : STD_LOGIC;
	signal R_player, G_player, B_player, R_fondo, G_fondo, B_fondo, R_gameover, G_gameover, B_gameover, gameover_en : STD_LOGIC;

	signal eje_x, eje_y : STD_LOGIC_VECTOR (9 downto 0);
	signal random : STD_LOGIC_VECTOR (7 downto 0);

	component contador is
		Generic (Nbit : INTEGER := 8);
		port( clk : in  STD_LOGIC;
		      reset : in  STD_LOGIC;
		      resets : in STD_LOGIC;
		      enable : in  STD_LOGIC;
		      Q : out  STD_LOGIC_VECTOR ((Nbit - 1) downto 0));
	end component;

	component comparador is
		Generic (Nbit : integer :=8;
			 End_Of_Screen : integer := 10;
			 Start_Of_Pulse : integer := 20;
			 End_Of_Pulse : integer := 30;
			 End_Of_Line : integer := 40);

		Port (   clk : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 data : in STD_LOGIC_VECTOR (Nbit-1 downto 0);
			 O1 : out STD_LOGIC;
			 O2 : out STD_LOGIC;
			 O3 : out STD_LOGIC);
	end component;

	component enemigo is
		generic (desfase_x : integer :=260;
			 desfase_y : INTEGER := 100);
		Port (
			     R : out STD_LOGIC;
			     G : out STD_LOGIC;
			     B : out STD_LOGIC;
			     reset : in STD_LOGIC;
			     clk : in STD_LOGIC;
			     VS : in STD_LOGIC;
			     random : in STD_LOGIC_VECTOR (7 downto 0);
			     eje_x : in STD_LOGIC_VECTOR (9 downto 0);
			     eje_y : in STD_LOGIC_VECTOR (9 downto 0));
	end component;

        component fondo is
                Port (
                             R : out STD_LOGIC;
                             G : out STD_LOGIC;
                             B : out STD_LOGIC;
                             reset : in STD_LOGIC;
                             clk : in STD_LOGIC;
                             VS : in STD_LOGIC;
                             eje_x : in STD_LOGIC_VECTOR (9 downto 0);
                             eje_y : in STD_LOGIC_VECTOR (9 downto 0));
        end component;

        component gameover is
                Port (
                             R : out STD_LOGIC;
                             G : out STD_LOGIC;
                             B : out STD_LOGIC;
                             reset : in STD_LOGIC;
                             clk : in STD_LOGIC;
                             eje_x : in STD_LOGIC_VECTOR (9 downto 0);
                             eje_y : in STD_LOGIC_VECTOR (9 downto 0));
        end component;

        component random_gen is
                Port (
                             clk : in STD_LOGIC;
                             reset : in STD_LOGIC;
                             random : out STD_LOGIC_VECTOR (7 downto 0));
        end component;

	component cuadrado is
		Port (
			     button_left    : in std_logic;
			     button_center  : in std_logic;
			     button_right : in std_logic;
			     R : out STD_LOGIC;
			     G : out STD_LOGIC;
			     B : out STD_LOGIC;
			     reset : in STD_LOGIC;
			     clk : in STD_LOGIC;
			     VS : in STD_LOGIC;	
			     eje_x : in STD_LOGIC_VECTOR (9 downto 0);
			     eje_y : in STD_LOGIC_VECTOR (9 downto 0));
	end component;

	component selector is
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
	end component;

begin

	contador_x: contador
	generic map (Nbit => 10)
	port map (clk => clk,
		  reset => reset,
		  resets => O3_compX,
		  enable => clk_pixel,
		  Q => eje_x
	  );

	enable_contY <= clk_pixel AND O3_compX;

	contador_y: contador
	generic map (Nbit => 10)
	port map (clk => clk,
		  reset => reset,
		  resets => O3_compY,
		  enable => enable_contY,
		  Q => eje_y
	  );

	comparador_x: comparador
	generic map (Nbit => 10,
		     End_Of_Screen => 639,
		     Start_Of_Pulse => 655,
		     End_Of_Pulse => 751,
		     End_Of_Line => 799
	     )
	port map (clk => clk,
		  reset => reset,
		  data => eje_x,
		  O1 => Blank_x,
		  O2 => HS,
		  O3 => O3_compX
	  );

	comparador_y: comparador
	generic map (Nbit => 10,
		     End_Of_Screen => 479,
		     Start_Of_Pulse => 489,
		     End_Of_Pulse => 491,
		     End_Of_Line => 520
	     )
	port map (clk => clk,
		  reset => reset,
		  data => eje_y,
		  O1 => Blank_y,
		  O2 => VSsignal,
		  O3 => O3_compY
	  );
	VS <= VSsignal;

	selector_instancia: selector
	port map (R_en1 => R_en1,
		  G_en1 => G_en1,
		  B_en1 => B_en1,
		  R_en2 => R_en2,
		  G_en2 => G_en2,
		  B_en2 => B_en2,
                  R_en3 => R_en3,
                  G_en3 => G_en3,
                  B_en3 => B_en3,
		  R_player => R_player,
		  G_player => G_player,
		  B_player => B_player,
                  R_fondo=> R_fondo,
                  G_fondo => G_fondo,
                  B_fondo => B_fondo,
                  R_gameover => R_gameover,
                  G_gameover => G_gameover,
                  B_gameover => B_gameover,
                  gameover_en => gameover_en,
		  R => R_in,
		  G => G_in,
		  B => B_in
	  );

	player:cuadrado
	port map (button_left => button_left,
		  button_center => button_center, 
		  button_right =>button_right, 
		  R =>R_player, 
		  G =>G_player,
		  B =>B_player,
		  reset =>reset,
		  clk =>clk_pixel,
		  VS => VSsignal,
		  eje_x =>eje_x,
		  eje_y =>eje_y
	  );

	enemigo_instancia: enemigo
	generic map (desfase_x => 50,
		     desfase_y => 0)
	port map (eje_x => eje_x,
		  eje_y => eje_y,
		  R => R_en1,
		  G => G_en1,
		  B => B_en1,
                  clk =>clk_pixel,
                  VS => VSsignal,
                  random => random,
		  reset  => reset
	  );
	enemigo_instancia2: enemigo
	generic map (desfase_x => 80,
		     desfase_y => 180)
	port map (eje_x => eje_x,
		  eje_y => eje_y,
		  R => R_en2,
		  G => G_en2,
		  B => B_en2,
		  clk =>clk_pixel,
                  VS => VSsignal,
                  random => random,
		  reset  => reset
	  );
        enemigo_instancia3: enemigo
        generic map (desfase_x => 110,
                     desfase_y => 90)
        port map (eje_x => eje_x,
                  eje_y => eje_y,
                  R => R_en3,
                  G => G_en3,
                  B => B_en3,
                  clk =>clk_pixel,
                  VS => VSsignal,
                  random => random,
                  reset  => reset
          );


        fondo_instancia: fondo
        port map (eje_x => eje_x,
                  eje_y => eje_y,
                  R => R_fondo,
                  G => G_fondo,
                  B => B_fondo,
                  clk =>clk_pixel,
                  VS => VSsignal,
                  reset  => reset
          );

        gameover_instancia: gameover
        port map (eje_x => eje_x,
                  eje_y => eje_y,
                  R => R_gameover,
                  G => G_gameover,
                  B => B_gameover,
                  clk =>clk_pixel,
                  reset  => reset
          );

        random_gen_instancia: random_gen
        port map (clk =>clk_pixel,
                  reset  => reset,
		  random => random
          );


	div_frec:process(clk, reset)
	begin
		if reset='1' then
			clk_pixel<='0';
		elsif rising_edge (clk) then
			clk_pixel <= not clk_pixel;
		end if;
	end process;

	gen_color:process (Blank_x, Blank_y, R_in, G_in, B_in)
	begin
		if (Blank_x = '1' OR Blank_y = '1') then
			R <= '0'; G <= '0'; B <= '0';
		else
			R <= R_in; G <= G_in; B <= B_in;
		end if;
	end process;

	gameover_biestable:process (R_in, G_in, B_in)
	begin
		if reset='1' then
			gameover_en <='0';
		elsif ((R_in='1') AND (G_in='0') AND (B_in='0')) AND rising_edge (clk_pixel) then
			--colision
			gameover_en <='1';
		end if;
	end process;

end Behavioral;
