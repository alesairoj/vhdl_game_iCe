library IEEE;
use IEEE.std_logic_1164.all;

entity biSR is
  port (
    status,notstatus : out std_logic;
    clk, s, r : in std_logic);
end entity;

architecture arch_biSR of biSR is

  signal internalQ : std_logic;
  signal internalSR : std_logic_vector (1 downto 0);

begin

  status <= internalQ;
  notStatus <= not internalQ;

  process (clk)
  begin

    internalSR <= s & r;
    if rising_edge(clk) then
      if internalSR = "00" then
        --internalQ <= internal!;
      elsif internalSR = "01" then
        internalQ <= '0';
      elsif internalSR = "10" then
        internalQ <= '1';
      else --internalSR is "11"
        -- Estado inestable
        internalQ <= 'Z';
      end if;
    end if;

  end process;
  
  end architecture;
