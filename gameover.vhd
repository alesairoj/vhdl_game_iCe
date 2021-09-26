library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gameover is
	Port (
		     R            : out STD_LOGIC;
		     G            : out STD_LOGIC;
		     B            : out STD_LOGIC;
		     reset : in STD_LOGIC;
		     clk : in STD_LOGIC;
		     eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
		     eje_y        : in STD_LOGIC_VECTOR (9 downto 0));
end gameover;

architecture Behavioral of gameover is
	signal X, Y : unsigned (9 downto 0);
	--signal xini, yini : unsigned (8 downto 0);
	--signal xinivec, yinivec : STD_LOGIC_VECTOR ( 8 downto 0);
	signal mem_cont_vector : STD_LOGIC_VECTOR (11 downto 0);
        signal enable_mem_cont : STD_LOGIC;
	signal mem_cont : unsigned (11 downto 0);
	signal mem_data : STD_LOGIC_VECTOR (2 downto 0);

	component gameover_ram is
		Generic (
				DATA_WIDTH : integer := 3;
				ADDR_WIDTH : integer := 12 );
		port (clk   : in  std_logic;
		      addri : in  unsigned (ADDR_WIDTH-1 downto 0);
		      datai : in  std_logic_vector (DATA_WIDTH-1 downto 0);
		      we    : in  std_logic;
		      datao : out std_logic_vector (DATA_WIDTH-1 downto 0));
	end component;


	component contador is
		Generic (Nbit : INTEGER :=15);
		port( clk : in  STD_LOGIC;
		      reset : in  STD_LOGIC;
		      enable : in STD_LOGIC;
		      resets : in STD_LOGIC;
		      Q : out  STD_LOGIC_VECTOR ((Nbit - 1) downto 0));
	end component;
begin
--
--contador_yini: contador
--generic map (Nbit => 9)
--port map (clk => VS,
--	  reset => reset,
--	  resets => '0',
--	  enable => '1',
--	  Q => yinivec
--  );

	contador_pixelmem: contador
        generic map (Nbit => 12)
        port map (clk => clk,
                  reset => reset,
                  resets => '0',
                  enable => enable_mem_cont,
                  Q => mem_cont_vector
          );
        mem_cont <= unsigned(mem_cont_vector) + 1;

	memoria_gameover: gameover_ram
        port map (clk => clk,
                  addri => mem_cont,
                  datai => mem_data,
                  we => '0',
                  datao => mem_data
          );


	--yini <= unsigned(yinivec)+desfase_y;
	--xini <= "000000000"+(desfase_x);
	X <= unsigned(eje_x);
	Y <= unsigned(eje_y);
	process(X, Y)
	begin
                if (X > 250) AND (X < ( 250+ 65)) AND (300 > Y) AND (300 < (Y + 65)) then
                        R <= mem_data(2); G <= mem_data(1); B <= mem_data(0) ;
                        enable_mem_cont <= '1';
		elsif (X > 200) then
                        R <= '0'; G <= '0'; B <= '1';
                        enable_mem_cont <= '0';
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
