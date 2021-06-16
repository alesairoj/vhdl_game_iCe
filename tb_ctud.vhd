library ieee;
use ieee.std_logic_1164.all;
--LIBRARY STD;
use STD.TEXTIO.all;
--LIBRARY synospys;
--USE ieee.std_logic_textio.all;


use ieee.numeric_std.all;

entity tb_ctud is
end tb_ctud;

architecture behavior of tb_ctud is

  -- Component Declaration for the Unit Under Test (UUT)

  component ctud
    generic (Nbit : integer := 8);
    port(
      clk     : in  std_logic;
      reset   : in  std_logic;
      enable  : in  std_logic;
      resets  : in  std_logic;
      sentido : in  std_logic;
      Q       : out std_logic_vector (Nbit-1 downto 0));
  end component;


  --Inputs
  signal clk     : std_logic := '0';
  signal reset   : std_logic := '0';
  signal enable  : std_logic := '1';
  signal resets  : std_logic := '0';
  signal sentido : std_logic := '1';

  --Outputs
  signal Q            : std_logic_vector (7 downto 0);
  -- Clock period definitions
  constant clk_period : time                               := 20 ns;


begin

  -- Instantiate the Unit Under Test (UUT)
  uut : ctud
    port map (
      clk           => clk,
      reset         => reset,
      enable => enable,
      resets => resets,
      sentido => sentido,
      Q => Q
      );

  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;


  -- Stimulus process
  stim_proc : process
  begin
    -- hold reset state for 100 ns.
    reset <= '1';
    wait for 100 ns;
    reset <= '0';

    --wait for clk_period*10;
    enable <= '1';
    sentido <= '1';
    wait for 100 ms;
    -- insert stimulus here
    sentido <= '0';
    wait for 200 ms;
    wait;
  end process;

  end;
