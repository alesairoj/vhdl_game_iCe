LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--LIBRARY STD;
USE STD.TEXTIO.ALL;
--LIBRARY synospys;
--USE ieee.std_logic_textio.all;


USE ieee.numeric_std.ALL;

ENTITY tb_vgadriver IS
	END tb_vgadriver;

ARCHITECTURE behavior OF tb_vgadriver IS 

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT vga_driver
		PORT(
			    clk : IN  std_logic;
			    reset : IN  std_logic;
			    button_center : IN  std_logic;
			    button_left : IN  std_logic;
			    button_right : IN  std_logic;
			    VS: OUT std_logic;
			    HS: OUT std_logic;
			    R: OUT std_logic;
			    G: OUT std_logic;
			    B: OUT std_logic);
	END COMPONENT;


	--Inputs
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';

	--Outputs
	signal VS : std_logic;
	signal HS : std_logic;
	signal R : std_logic;
	signal G : std_logic;
	signal B : std_logic;
	signal button_center : std_logic;
	signal button_left : std_logic;
	signal button_right : std_logic;
	-- Clock period definitions
	constant clk_period : time := 20 ns;

	--Fichero
	--Copias sin std
	signal VSt, HSt : integer range 0 to 1;
	signal Rt, Gt, Bt : integer range 0 to 255;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: vga_driver 
	PORT MAP (
			 clk => clk,
			 reset => reset,
			 button_center => button_center,
			 button_left => button_left,
			 button_right => button_right,
			 VS => VS,
			 HS => HS,
			 R => R,
			 G => G,
			 B => B
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
		--wait for clk_period*10;

		-- insert stimulus here 

		wait;
	end process;

		button_center <= '0';
		button_left <= '0';
		button_right <= '0';

	VSt <= 1 when (VS='1') else 0;
	HSt <= 1 when (HS='1') else 0;
	Rt <= 111 when (R='1') else 000;
	Gt <= 111 when (G='1') else 000;
	Bt <= 111 when (B='1') else 000;

	--log to file
	writing: process (clk)
		file file_pointer: text open WRITE_MODE is "write.txt";
		variable line_el: line;
		constant puntitos : character := ':';
		constant espacio : character :=' ';
	begin
		--file_open(file_pointer, "salida_vga.txt", write_mode);

		if rising_edge(clk) then

			write(line_el, now); --V93
			write(line_el, String'(":")); --V93

			write(line_el, String'(" ")); --V93
			write(line_el, HSt); --V93

			write(line_el, String'(" ")); --V93
			write(line_el, VSt); --V93

			write(line_el, String'(" ")); --V93
			write(line_el, Rt); --V93

			write(line_el, String'(" ")); --V93
			write(line_el, Gt); --V93

			write(line_el, String'(" ")); --V93
			write(line_el, Bt); --V93

			writeline(file_pointer, line_el); --V93

		end if;
	end process;


END;
