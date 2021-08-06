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
		     eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
		     eje_y        : in STD_LOGIC_VECTOR (9 downto 0));
end enemigo;

architecture Behavioral of enemigo is
	signal X, Y : unsigned (9 downto 0);
	signal xini, yini : unsigned (8 downto 0);
	signal xinivec, yinivec : STD_LOGIC_VECTOR ( 8 downto 0);

	signal addr : unsigned (9 downto 0);
	signal data : unsigned (8 downto 0);

	component car is
		Generic (
				DATA_WIDTH : integer := 9;
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
	generic map (Nbit => 9)
	port map (clk => clk,
		  reset => reset,
		  resets => '0',
		  enable => '1',
		  Q => yinivec
	  );

	yini <= unsigned(yinivec)+desfase_y;
	--xini <= "000000000"+(desfase_x);
	X <= unsigned(eje_x);
	Y <= unsigned(eje_y);
	process(X, Y)
	begin

		if (X > desfase_x) AND (X < (desfase_x + 15)) AND (Y > yini) AND (Y < (yini + 15)) then
			R <= '0'; G <= '0'; B <= '0';
		else
			R <= '1'; G <= '1'; B <= '1';
		end if;

	end process;

end Behavioral;
