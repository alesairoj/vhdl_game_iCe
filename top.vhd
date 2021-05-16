library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port (
		     clk12         : in  std_logic;
		     rst           : in  std_logic;
		     button_left   : in  std_logic;
		     button_center : in  std_logic;
		     button_right  : in  std_logic;
		     pll_locked_led : out std_logic;
		     heart_led_50  : out std_logic;
		     hs            : out std_logic;
		     vs            : out std_logic;
		     r             : out std_logic_vector (3 downto 0);
		     g             : out std_logic_vector (3 downto 0);
		     b             : out std_logic_vector (3 downto 0));
end top;

architecture top_arch of top is

	signal clk : std_logic;

	    -- Internal component (hardware primitive) of the ICE40 FPGA
	component SB_PLL40_PAD is
		generic (
				FEEDBACK_PATH : string                       := "SIMPLE";
				DIVR          : std_logic_vector(3 downto 0) := "0000";
				DIVF          : std_logic_vector(6 downto 0) := "1000001";
				DIVQ          : std_logic_vector(2 downto 0) := "011";
				FILTER_RANGE  : std_logic_vector(2 downto 0) := "001"
			);
		port (
			     PACKAGEPIN   : in  std_logic;
			     PLLOUTGLOBAL : out std_logic;
			     RESETB       : in  std_logic;
			     BYPASS       : in  std_logic;
			     LOCK         : out std_logic
		     );
	end component;

	signal pll_lock, pll_lock_r : std_logic;
	signal rst_high             : std_logic;
	signal count_50, p_count_50        : integer range 0 to 50_000_000 - 1;
	signal heartbeat_50, p_heartbeat_50 : std_logic;
	signal button_down : std_logic;

begin

	vgadrv_inst : entity work.vga_driver
	port map (
			 clk           => clk,
			 reset         => rst_high,
			 button_left   => button_left,
			 button_up     => button_center,
			 button_right  => button_right,
			 button_down   => button_down,
			 Hs            => hs,
			 Vs            => vs,
			 R             => r(3),
			 G             => g(3),
			 B             => b(3)
		 );

	r(2 downto 0) <= "000";
	g(2 downto 0) <= "000";
	b(2 downto 0) <= "000";

											-- Reset button is active low, but our modules have active high resets
	rst_high <= not rst;

											  -- Connect an internal PLL (Phase-Locked Loop) to the 12 MHz clk to generate
											  -- the 50 MHz clk we will use internally
											  --
											  -- DIVR : Reference clk divider (0 to 15)
											  -- DIVF : Feedback divider (0 to 63)
											  -- DIVQ : VCO divicer (1 to 6)
											  -- FILTER_RANGE : PLL filter range (0 to 7)
											  --
											  -- The iCE40 sysCLOCK PLL Design and Usage Guide explains how F_pllout is
											  -- calculated with respect to the DIV* parameters.
											  -- If FEEDBACK_PATH="SIMPLE":
											  --
											  --              F_referenceclk * (DIVF+1)
											  --   F_pllout = -------------------------
											  --              (2**DIVQ) * (DIVR+1)
											  --
											  -- In our case we want to generate a 50MHz clock from a 12MHz clock, so we 
											  -- want to multiply by 50/12 = 25/6:
											  --
											  --              F_reference_clk * (24+1)
											  --   F_pllout = ------------------------
											  --                  (2**1) * (2+1)
											  --
	pll_inst : SB_PLL40_PAD
	generic map (
			    FEEDBACK_PATH => "SIMPLE",
			    DIVR          => std_logic_vector(to_unsigned(2,4)),
			    DIVF          => std_logic_vector(to_unsigned(24,7)),
			    DIVQ          => std_logic_vector(to_unsigned(1,3)),
			    FILTER_RANGE  => "001"
		    )
	port map (
			 PACKAGEPIN   => clk12,
			 PLLOUTGLOBAL => clk,
			 RESETB       => '1',
			 BYPASS       => '0',
			 LOCK         => pll_lock
		 );

																					    -- Sync pll lock with generated clock
	sync : process (clk)
	begin
		if rising_edge(clk) then
			pll_lock_r <= pll_lock;
		end if;
	end process;

																											-- Divide 50 MHz clock to drive a led, checking the clock is correctly
																											-- connected

	heartbeat_comb: process (count_50)
	begin
		p_count_50 <= count_50+1;
		p_heartbeat_50 <= heartbeat_50;
		if count_50 = 50_000_000 - 1 then
			p_count_50 <= 0;
			p_heartbeat_50 <= not heartbeat_50;
		end if;
	end process;

	hearbeat_sync: process (rst_high, clk)
	begin
		if rst_high = '1' then
			count_50 <= 0;
			heartbeat_50 <= '0';
		elsif rising_edge(clk) then
			count_50 <= p_count_50;
			heartbeat_50 <= p_heartbeat_50;
		end if;
	end process;

	heart_led_50 <= heartbeat_50;
	pll_locked_led <= NOT pll_lock_r;

end top_arch;

