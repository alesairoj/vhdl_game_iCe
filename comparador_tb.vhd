LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY comparador_tb IS
	END comparador_tb;

ARCHITECTURE behavior OF comparador_tb IS 

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT comparador
		Generic (Nbit : integer :=8;
			 End_Of_Screen : integer := 10;
			 Start_Of_Pulse : integer := 20;
			 End_Of_Pulse : integer := 30;
			 End_Of_Line : integer := 40);

		PORT(
			    clk : in STD_LOGIC;
			    reset : in STD_LOGIC;
			    data : in STD_LOGIC_VECTOR (Nbit-1 downto 0);
			    O1 : out STD_LOGIC;
			    O2 : out STD_LOGIC;
			    O3 : out STD_LOGIC);
	END COMPONENT;


	--Inputs
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal data : std_logic_vector (7 downto 0) := "00000000";

	--Outputs
	signal O1, O2, O3 : std_logic;

	-- Clock period definitions
	constant clk_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: comparador 
	GENERIC MAP (Nbit => 8,
                 End_Of_Screen => 10,
                 Start_Of_Pulse => 20,
                 End_Of_Pulse => 30,
                 End_Of_Line => 40 )
	PORT MAP (
			 clk => clk,
			 reset => reset,
			 data => data,
			 O1 => O1,
			 O2 => O2,
			 O3 => O3
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
		wait for 100 ns;	
		reset <='0';
		wait for 50 ns;
		data <= "00100111";
		wait for 50 ns;
		data <= "00101000";
		wait for 50 ns;
		data <= "00101001";
		wait for clk_period*10;

		-- insert stimulus here 

		wait;
	end process;

END;
