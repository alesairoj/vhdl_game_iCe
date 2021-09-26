library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity random_gen is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           random : out  STD_LOGIC_VECTOR (7 downto 0));
end random_gen;

architecture Behavioral of random_gen is

signal p_valor, valor : STD_LOGIC_VECTOR (7 DOWNTO 0);

begin


comb:process(valor)
begin

	p_valor(7) <= valor(6);
	p_valor(6) <= valor(5);
	p_valor(5) <= valor(4);
	p_valor(4) <= valor(3);
	p_valor(3) <= valor(2);
	p_valor(2) <= valor(1);
	p_valor(1) <= valor(0);
	p_valor(0) <= valor(7) XOR valor(5) XOR valor(4) XOR valor(3);
end process;

sinc:process(clk, reset)
begin
	if reset = '1' then
		valor <= "11000010";
	elsif (rising_edge (clk)) then
		valor <= p_valor;
	end if;
end process;
random <= valor;
end Behavioral;
