LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS END testbench;

ARCHITECTURE tb OF testbench IS
	COMPONENT uart2 IS	
	PORT (
		rst   : IN  std_logic;
		clk   : IN  std_logic;
 
	   -- Parallel 2 Serial
	   start : IN  std_logic;
	   din	 : IN  std_logic_vector(7 DOWNTO 0);
	   tx    : OUT std_logic;			

	   -- Serial 2 Parallel
	   rx    : IN  std_logic;			
	   dout  : OUT std_logic_vector(7 DOWNTO 0);
	   done  : OUT std_logic;

	   baud  : IN  std_logic_vector(7 DOWNTO 0)
   );

	END COMPONENT;

	SIGNAL clk 						: std_logic := '1';
	SIGNAL r_rst 					: std_logic;
	SIGNAL t_rst 					: std_logic;
	SIGNAL r_start ,  r_done 	    : std_logic;
	SIGNAL t_start ,  t_done 	    : std_logic;
	SIGNAL wire_A, wire_B			: std_logic;
	SIGNAL r_din , r_dout			: std_logic_vector(7 DOWNTO 0);
	SIGNAL t_din , t_dout			: std_logic_vector(7 DOWNTO 0);
	SIGNAL baud						: std_logic_vector(7 DOWNTO 0);


BEGIN

	receiver	:	uart2 PORT MAP (r_rst, clk, r_start, r_din, wire_A, wire_B, r_dout, r_done, baud);
	transmitter	: 	uart2 PORT MAP (t_rst, clk, t_start, t_din, wire_B, wire_A, t_dout, t_done, baud);

	PROCESS
	BEGIN
		clk <= '1';
		WAIT FOR 5 ns;
		clk <= '0';
		WAIT FOR 5 ns;
	END PROCESS;
	PROCESS
	BEGIN
		t_rst <= '0', '1' AFTER 12 ns;
		r_rst <= '0', '1' AFTER 12 ns;

		t_din <= "11101011";
		baud <= "00000010";
		t_start <= '1', '0' AFTER 30 ns;

		r_din <= "10000001";
		
		r_start <= '0' , '1'AFTER 300 ns, '0' AFTER 330 ns;

		WAIT;
	END PROCESS;
END tb;