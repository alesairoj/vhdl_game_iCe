LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--USE ieee.numeric_std.ALL;

ENTITY contador_tb IS
	END contador_tb;

ARCHITECTURE behavior OF contador_tb IS 

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT contador
		Generic (Nbit : integer :=8);
		PORT(
			    clk : IN  std_logic;
			    reset : IN  std_logic;
			    resets: IN std_logic;
			    enable: IN std_logic;
			    Q : OUT STD_LOGIC_VECTOR (Nbit-1 downto 0));
	END COMPONENT;


	--Inputs
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal resets : std_logic := '0';
	signal enable : std_logic := '0';

	--Outputs
	signal Q : std_logic_vector (7 downto 0);

	-- Clock period definitions
	constant clk_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: contador 
	GENERIC MAP (Nbit => 8)
	PORT MAP (
			 clk => clk,
			 reset => reset,
			 resets => resets,
			 enable => enable,
			 Q => Q
		 );

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;


	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		reset <='1';
		resets <='1';
		enable <='0';
		wait for 100 ns;	
		reset <='0';
		resets <='0';
		wait for 50 ns;
		enable <='1';
		wait for 50 ns;
		enable <='0';
		wait for clk_period*10;
		enable <='1';
		wait for 97 ns;
		resets <= '1';

		-- insert stimulus here 

		wait;
	end process;

END;
