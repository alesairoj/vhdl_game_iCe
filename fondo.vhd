-- Caracteristicas de la pantalla:
-- 640 x 480
-- 60 Hz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fondo is
	Port (
            R            : out STD_LOGIC;
            G            : out STD_LOGIC;
            B            : out STD_LOGIC;
            eje_x        : in STD_LOGIC_VECTOR (9 downto 0);
            eje_y        : in STD_LOGIC_VECTOR (9 downto 0));
end fondo;

architecture Behavioral of fondo is
	signal p_O1, p_O2, p_O3 : STD_LOGIC;
        signal buttons : std_logic_vector(3 downto 0);
	signal X, Y : unsigned (9 downto 0);

        component biSR is
                  port (
                            status,notstatus : out std_logic;
                                    clk, s, r : in std_logic);
                end component;
        
begin

	X <= unsigned(eje_x);
	Y <= unsigned(eje_y);

	process(eje_x, eje_y)
	begin
		if (X > 0) AND (X < 640 ) AND (Y > 0) AND (Y < 680) then
                   R <= '1'; G <= '0'; B <= '1';
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
