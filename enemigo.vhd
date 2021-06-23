library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity enemigo is
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
	signal xini, yini : unsigned (9 downto 0);
	signal xinivec, yinivec : STD_LOGIC_VECTOR ( 9 downto 0);
--	signal x2vec, y2vec : STD_LOGIC_VECTOR ( 9 downto 0);
	signal x2, y2 : unsigned (9 downto 0);
	signal enctud : STD_LOGIC;

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
begin

        contador_xini: ctud
        generic map (Nbit => 10)
        port map (clk => clk,
                  reset => reset,
                  resets => '0',
                  enable => '1',
                  sentido => '1',
                  Q => xinivec
          );
        contador_yini: contador
        generic map (Nbit => 10)
        port map (clk => clk,
                  reset => reset,
                  resets => '0',
                  enable => '1',
                  Q => yinivec
          );

--         enemigo2_xini: ctud
--           generic map (Nbit => 10)
--           port map (clk => clk,
--                     reset => reset,
--                     resets => '0',
--                     enable => '1',
--                     sentido => '1',
--                     Q => x2vec
--                     );
--         enemigo2_yini: contador
--           generic map (Nbit => 10)
--           port map (clk => clk,
--                     reset => reset,
--                     resets => '0',
--                     enable => '1',
--                     Q => y2vec
--                     );

-- y2 <= unsigned(yinivec)+30;
-- x2 <= unsigned(xinivec)+20;
yini <= unsigned(yinivec);
xini <= unsigned(xinivec)+260;
	X <= unsigned(eje_x);
	Y <= unsigned(eje_y);

	process(X, Y)
	begin

		if (X > xini) AND (X < (xini + 15)) AND (Y > yini) AND (Y < (yini + 15)) then
			R <= '0'; G <= '0'; B <= '0';
		else
			R <= '1'; G <= '1'; B <= '1';
		end if;

	end process;

end Behavioral;
