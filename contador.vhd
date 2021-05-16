----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:32:16 03/06/2020 
-- Design Name: 
-- Module Name:    contador - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contador is
	Generic (Nbit : INTEGER := 8);
	Port ( clk : in  STD_LOGIC;
	       reset : in  STD_LOGIC;
	       resets : in STD_LOGIC;
	       enable : in  STD_LOGIC;
	       Q : out  STD_LOGIC_VECTOR ((Nbit - 1) downto 0));
end contador;

architecture Behavioral of contador is
	signal p_cuenta, cuenta : UNSIGNED (Nbit-1 downto 0);

begin

	comb:process(cuenta, enable, resets)
	begin
		if resets = '1' then
			p_cuenta <= (others => '0');
		elsif (enable = '1') then
			--if ( cuenta = 9) then
			--	p_cuenta <= (others => '0');
			--else
				p_cuenta <= cuenta + 1;
			--end if;
		else
			p_cuenta <= cuenta;
		end if;
	end process;

	sinc:process(clk, reset)
	begin
		if reset = '1' then
			cuenta <= (others => '0');
		elsif rising_edge (clk) then
			cuenta <= p_cuenta;
		end if;
	end process;

	Q<= std_logic_vector(cuenta);

end Behavioral;

