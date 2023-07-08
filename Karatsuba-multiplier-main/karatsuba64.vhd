----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:44:22 01/29/2023 
-- Design Name: 
-- Module Name:    karatsuba64 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity karatsuba64 is 
-- generic( nbit : integer := 16);

port( clock, reset, start : in std_logic;
		x : in std_logic_vector(63 downto 0);
		y : in std_logic_vector(63 downto 0);
		z : out std_logic_vector(127 downto 0);
		done : out std_logic);
end karatsuba64;

architecture Behavioral of karatsuba64 is
type state_type is (waiting, pre, calculate, sum, ending);
signal state, next_state : state_type := waiting;
signal x1 : std_logic_vector(31 downto 0) := (others => '0');
signal x0 : std_logic_vector(31 downto 0) := (others => '0');
signal y1 : std_logic_vector(31 downto 0) := (others => '0');
signal y0 : std_logic_vector(31 downto 0) := (others => '0');
signal x2 , y2 : unsigned(31 downto 0) := (others => '0');
-- signal z0, z1_p, z1, z2 : unsigned(31 downto 0) := (others => '0');
signal z0_s, z1_p_s, z2_s : std_logic_vector(63 downto 0) := (others => '0');
signal B2m : std_logic_vector(63 downto 0) := (others => '0');
signal Bm : std_logic_vector(31 downto 0) := (others => '0');

signal z_reg : unsigned(127 downto 0) := (others => '0');
signal start_calculate : std_logic := '0';
signal done_calculate : std_logic_vector(2 downto 0) := (others=>'0');

component karatsuba32 is
	port(
		clock, reset, start : in std_logic;
		x : in std_logic_vector(31 downto 0);
		y : in std_logic_vector(31 downto 0);
		z : out std_logic_vector(63 downto 0);
		done : out std_logic);
end component;


begin
	state_proc: process(clock)
	begin
		if(rising_edge(clock))then
			state<=next_state;
		end if;
		
	end process;


	general_proc: process(state, start, done_calculate, y1, y0, x1, x0, z1_p_s, z2_s, z0_s, z_reg)
	begin
		x1 <= (x(63 downto 32));
		x0 <= (x(31 downto 0));
		y1 <= (y(63 downto 32));
		y0 <= (y(31 downto 0));
	
		next_state <= state;
		start_calculate <= '0';
		
		case state is
			when waiting=>
				if(start = '1')then
					next_state <= pre;
				end if;
				done <= '0';
				
			when pre =>
				done <= '0';
				-- start_calculate <= '1';
				next_state <= calculate;
				x2 <= unsigned(x1) + unsigned(x0);
				y2 <= unsigned(y1) + unsigned(y0);
				
			when calculate =>
				start_calculate <= '1';
				if(done_calculate = "111")then
					next_state <= sum;
				end if;
				done <= '0';
			
			when sum =>
				z_reg <= unsigned(z2_s & B2m) + unsigned(std_logic_vector(unsigned(z1_p_s)-unsigned(z2_s)-unsigned(z0_s))& Bm) + unsigned(z0_s);
				next_state <= ending;
				done <= '0';
				
			when ending =>
				done <= '1';
				z <= std_logic_vector(z_reg);
				
				next_state <= waiting;
		end case;	
	end process;
	b2m <= (others => '0');
	bm <= (others => '0');
	
	
	z0_booth: karatsuba32 port map(clock, reset, start_calculate, x0, y0, z0_s, done_calculate(0));
	z1_booth: karatsuba32 port map(clock, reset, start_calculate, std_logic_vector(x2), std_logic_vector(y2), z1_p_s, done_calculate(1));
	z2_booth: karatsuba32 port map(clock, reset, start_calculate, x1, y1, z2_s, done_calculate(2));

	
	
	
	
end Behavioral;

