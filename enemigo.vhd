library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity enemigo is
	generic (desfase_x : INTEGER := 260;
		 desfase_y : INTEGER := 100);
	Port (
		     R            : out STD_LOGIC;
		     G            : out STD_LOGIC;
		     B            : out STD_LOGIC;
		     reset : in STD_LOGIC;
		     clk : in STD_LOGIC;
		     VS : in STD_LOGIC;
		     random : in STD_LOGIC_VECTOR(7 downto 0);
		     eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
		     eje_y        : in STD_LOGIC_VECTOR (9 downto 0));


end enemigo;

architecture Behavioral of enemigo is
	signal X, Y : unsigned (9 downto 0);
	signal xini : unsigned (8 downto 0);
      	signal yini : unsigned (9 downto 0);
	signal xinivec : STD_LOGIC_VECTOR ( 8 downto 0);
       	signal yinivec : STD_LOGIC_VECTOR ( 9 downto 0);
	signal mem_cont_vector : STD_LOGIC_VECTOR (9 downto 0);
	signal enable_mem_cont, reset_mem : STD_LOGIC;
	signal mem_cont : unsigned (9 downto 0);
	signal mem_data : STD_LOGIC_VECTOR (2 downto 0);
	signal random_reg : STD_LOGIC_VECTOR (7 downto 0);
	signal muerte : STD_LOGIC;

	component coche is
		Generic (
				DATA_WIDTH : integer := 3;
				ADDR_WIDTH : integer := 10 );
		port (clk   : in  std_logic;
		      addri : in  unsigned (ADDR_WIDTH-1 downto 0);
		      datai : in  std_logic_vector (DATA_WIDTH-1 downto 0);
		      we    : in  std_logic;
		      datao : out std_logic_vector (DATA_WIDTH-1 downto 0));
	end component;


	component contador is
		Generic (Nbit : INTEGER :=8);
		port( clk : in  STD_LOGIC;
		      reset : in  STD_LOGIC;
		      enable : in STD_LOGIC;
		      resets : in STD_LOGIC;
		      Q : out  STD_LOGIC_VECTOR ((Nbit - 1) downto 0));
	end component;
begin

	contador_yini: contador
	generic map (Nbit => 10)
	port map (clk => VS,
		  reset => reset,
		  resets => '0',
		  enable => '1',
		  Q => yinivec
	  );

	reset_mem <= reset OR (NOT VS);

	contador_pixelmem: contador
	generic map (Nbit => 10)
	port map (clk => clk,
		  reset => reset_mem,
		  resets => reset_mem,
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

	process (yini)
	begin
		if yini = 752 then
			muerte <='1';
		else
			muerte <='0';
		end if;
	end process;

	registro : process (muerte)
	begin
		if (rising_edge(muerte)) then
			if reset = '1' then
				random_reg <= "00000000";
			else
				random_reg <= random;
			end if;
		end if;
	end process;

	yini <= unsigned(yinivec) + desfase_y + unsigned(random_reg);
	--xini <= "000000000"+(desfase_x);
	X <= unsigned(eje_x);
	Y <= unsigned(eje_y);
	process(X, Y)
	begin
		if (X > desfase_x) AND (X < (desfase_x + 33)) AND (Y > yini) AND (Y < (yini + 33)) then
			R <= mem_data(1); G <= mem_data(2); B <= mem_data(0) ;
			enable_mem_cont <= '1';
		else
			R <= '1'; G <= '1'; B <= '1';
			enable_mem_cont <= '0';
		end if;
	--	if (X > desfase_x) AND (X < (desfase_x + 15)) AND (Y > yini) AND (Y < (yini + 15)) then
	--		R <= '0'; G <= '0'; B <= '0';
	--	else
	--		R <= '1'; G <= '1'; B <= '1';
	--	end if;

	end process;

end Behavioral;
