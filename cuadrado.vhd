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
                     VS  : in STD_LOGIC;
		     clk : in STD_LOGIC;
		     eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
		     eje_y        : in STD_LOGIC_VECTOR (9 downto 0));
end cuadrado;

architecture Behavioral of cuadrado is
	signal buttons : std_logic_vector(2 downto 0);
	signal X, Y : unsigned (9 downto 0);
	signal xini, yini : unsigned (9 downto 0);
	signal xinivec, yinivec : STD_LOGIC_VECTOR ( 9 downto 0);
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

yini <= unsigned(yinivec)+420;
xini <= unsigned(xinivec)+260;
	X <= unsigned(eje_x);
	Y <= unsigned(eje_y);
	buttons <= button_left & not(button_center) & button_right;

	process(X, Y)
	begin
		--           case buttons is
		--               when "0000" =>
		--                   R <= '1'; G <= '0'; B <= '0';
		--               when "0001" =>
		--                   R <= '0'; G <= '1'; B <= '0';
		--               when "0010" =>
		--                   R <= '0'; G <= '0'; B <= '1';
		--               when "0100" =>
		--                   R <= '0'; G <= '1'; B <= '1';
		--               when "1000" =>
		--                   R <= '1'; G <= '1'; B <= '0';
		--               when others =>
		--                   R <= '1'; G <= '1'; B <= '1';
		--           end case;

		if (X > xini) AND (X < (xini + 50)) AND (Y > yini) AND (Y < (yini + 50)) then
			R <= '0'; G <= '1'; B <= '0';
		else
			R <= '1'; G <= '1'; B <= '1';
		end if;
	--	if((to_integer(unsigned(eje_y)) > 119) and (to_integer(unsigned(eje_y)) <359)) then
	--		R<='1'; G<='1'; B<='0';
	--	else
	--		R<='1'; G<='0'; B<='0';
	--	end if;
	end process;

end Behavioral;
