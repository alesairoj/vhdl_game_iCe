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

	--Señales de los elementos de la pantalla
	signal R_en1, G_en1, B_en1, R_en2, G_en2, B_en2 : STD_LOGIC;
	signal R_player, G_player, B_player : STD_LOGIC;
        signal R_fon, G_fon, B_fon : STD_LOGIC;


	signal eje_x, eje_y : STD_LOGIC_VECTOR (9 downto 0);

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
			     eje_x : in STD_LOGIC_VECTOR (9 downto 0);
			     eje_y : in STD_LOGIC_VECTOR (9 downto 0));
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
                             VS  : in STD_LOGIC;                             
			     eje_x : in STD_LOGIC_VECTOR (9 downto 0);
			     eje_y : in STD_LOGIC_VECTOR (9 downto 0));
	end component;

        component fondo is
            Port (
              R            : out STD_LOGIC;
              G            : out STD_LOGIC;
              B            : out STD_LOGIC;
              eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
              eje_y        : in STD_LOGIC_VECTOR (9 downto 0));
          end component;

	component selector is
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
                  R_fon => R_fon,
                  G_fon => G_fon,
                  B_fon => B_fon,
                  R_player => R_player,
		  G_player => G_player,
		  B_player => B_player,
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
		  clk =>clk,
                  VS => VSsignal,
		  eje_x =>eje_x,
		  eje_y =>eje_y
	  );

	enemigo_instancia: enemigo
	generic map (desfase_x => 260,
		     desfase_y => 0)
	port map (eje_x => eje_x,
		  eje_y => eje_y,
		  R => R_en1,
		  G => G_en1,
		  B => B_en1,
		  clk => VSsignal,
		  reset  => reset
	  );
	enemigo_instancia2: enemigo
	generic map (desfase_x => 324,
		     desfase_y => 100)
	port map (eje_x => eje_x,
		  eje_y => eje_y,
		  R => R_en2,
		  G => G_en2,
		  B => B_en2,
		  clk => VSsignal,
		  reset  => reset
	  );

        fondo_instancia: fondo
          port map (
            R            => R_fon,
            G            => G_fon,
            B            => B_fon,
            eje_x        => eje_x,
            eje_y        => eje_y
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

end Behavioral;
