library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cuadrado is
	Port (
		     button_left : in STD_LOGIC;
		     button_center : in STD_LOGIC;
		     button_right : in STD_LOGIC;
		     R            : out STD_LOGIC;
		     G            : out STD_LOGIC;
		     B            : out STD_LOGIC;
		     --		     xini : in unsigned (9 downto 0);
		     --		     yini : in unsigned (9 downto 0);
		     reset : in STD_LOGIC;
		     clk : in STD_LOGIC;
		     VS : in STD_LOGIC;
		     eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
		     eje_y        : in STD_LOGIC_VECTOR (9 downto 0));
end cuadrado;

architecture Behavioral of cuadrado is
	signal buttons : std_logic_vector(2 downto 0);
	signal X, Y : unsigned (9 downto 0);
	signal xini, yini : unsigned (9 downto 0);
	signal xinivec, yinivec, mem_cont_vector : STD_LOGIC_VECTOR ( 9 downto 0);
	signal enable_mem_cont : STD_LOGIC;
	signal enctud : STD_LOGIC;
	signal mem_cont : unsigned (9 downto 0);
	signal mem_data : STD_LOGIC_VECTOR (2 downto 0); 

	component ctud is
		Generic (Nbit : INTEGER :=8);
		port( clk : in  STD_LOGIC;
		      reset : in  STD_LOGIC;
		      enable : in STD_LOGIC;
		      resets : in STD_LOGIC;
		      sentido : in  STD_LOGIC;
		      Q : out  STD_LOGIC_VECTOR ((Nbit - 1) downto 0));
	end component;


	component contador is
		Generic (Nbit : INTEGER :=8);
		port( clk : in  STD_LOGIC;
		      reset : in  STD_LOGIC;
		      enable : in STD_LOGIC;
		      resets : in STD_LOGIC;
		      Q : out  STD_LOGIC_VECTOR ((Nbit - 1) downto 0));
	end component;

	component coche is 
		generic (
				DATA_WIDTH : integer := 3 ;
				ADDR_WIDTH : integer := 10 );
		port (clk   : in  std_logic;
		      addri : in  unsigned (ADDR_WIDTH-1 downto 0);
		      datai : in  std_logic_vector (DATA_WIDTH-1 downto 0);
		      we    : in  std_logic;
		      datao : out std_logic_vector (DATA_WIDTH-1 downto 0));
	end component ;

begin

	enctud <= button_left XOR button_right;

	contador_xini: ctud
	generic map (Nbit => 10)
	port map (clk => VS,
		  reset => reset,
		  resets => '0',
		  enable => enctud,
		  sentido => button_right,
		  Q => xinivec
	  );
	contador_yini: ctud
	generic map (Nbit => 10)
	port map (clk => VS,
		  reset => reset,
		  resets => '0',
		  enable => '1',
		  sentido => button_center,
		  Q => yinivec
	  );
	--Memoria imagen coche
	contador_pixelmem: contador
	generic map (Nbit => 10)
	port map (clk => clk,
		  reset => reset,
		  resets => '0',
		  enable => enable_mem_cont,
		  Q => mem_cont_vector
	  );
	mem_cont <= unsigned(mem_cont_vector) + 1;

	memoria_coche: coche
	port map (clk => clk,
		  addri => mem_cont,
		  datai => mem_data,
		  we => '0',
		  datao => mem_data
	  );

	yini <= 400 - unsigned(yinivec);
	xini <= unsigned(xinivec)+40;
	X <= unsigned(eje_x);
	Y <= unsigned(eje_y);
	--buttons <= button_left & button_center & button_right;

	process(X, Y)
	begin
		if (X > xini) AND (X < (xini + 33)) AND (Y > yini) AND (Y < (yini + 33)) then
			R <= mem_data(2); G <= mem_data(1); B <= mem_data(0) ;
			enable_mem_cont <= '1';
		else
			R <= '1'; G <= '1'; B <= '1';
			enable_mem_cont <= '0';
		end if;
	--	if((to_integer(unsigned(eje_y)) > 119) and (to_integer(unsigned(eje_y)) <359)) then
	--		R<='1'; G<='1'; B<='0';
	--	else
	--		R<='1'; G<='0'; B<='0';
	--	end if;
	end process;

end Behavioral;
