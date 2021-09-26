--  TODO:
--  * que sume al pulsar derecha y reste al pulsar izquierda

--   * y luego le pones que para que no vaya tan rápido, por ejemplo que el clk de contador no sea el clk de 25MHz sino el pulso de HS que va a 60Hz

--  * y luego implementarlo en el cuadrado.vhd poniendole VS como reloj

--  * luego que no cuente de 0 a 2^10, sino de 300 a 500 o algo así para que esté siempre en pantalla y en unos márgenes, y que no sature
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ctud is
  generic (Nbit : integer := 7);
  port (clk     : in  std_logic;
        reset   : in  std_logic;
        enable  : in  std_logic;
        resets  : in  std_logic;
        sentido : in  std_logic;
        Q       : out std_logic_vector (Nbit-1 downto 0));
end ctud;

architecture Behavioral of ctud is

  signal salida, p_salida : unsigned(Nbit-1 downto 0);

begin

  Q <= std_logic_vector(salida);

  comb : process(salida, enable, sentido)
  begin
    p_salida <= salida;
    if (resets = '1') then
      p_salida <= (others => '0');

    elsif (enable = '1') then
      if (sentido = '1') then

        if (salida >= 80) then

          p_salida <= salida;
        else
          p_salida <= salida + 1;
        end if;
      --p_salida <= salida + 1;
      else
        if (salida = "0000000") then
          p_salida <= salida;
        else
          p_salida <= salida - 1;
        end if;
      --p_salida <= salida - 1;
      end if;
    else
      p_salida <= salida;
    end if;

  end process;

  sinc : process(resets, clk)
  begin
    if (reset = '1') then
      salida <= (others => '0');
    elsif (rising_edge(clk)) then
      salida <= p_salida;
    end if;

  end process;

end Behavioral;
