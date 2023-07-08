----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:06:41 01/28/2023 
-- Design Name: 
-- Module Name:    booth - Behavioral 
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


entity Booth16 is
    port (
        CLK   : in  std_logic;
        RST   : in  std_logic;
        start : in  std_logic;
        M     : in  std_logic_vector(15 downto 0);
        Q     : in  std_logic_vector(15 downto 0);
        valid : out std_logic;
        P     : out std_logic_vector(31 downto 0)
        );
end entity;


architecture rtl of Booth16 is
    -- signal A : unsigned(15 downto 0) := (others => '0');
    signal S, next_S : unsigned(32 downto 0) := (others => '0');
    signal counter, next_counter : unsigned(4 downto 0) := (others=>'0'); 
	 type state_type is (waiting, run, calculate, done);
	 signal state, next_state : state_type := waiting;

begin

	state_proc: process(CLK)
	begin
		if(rising_edge(clk))then
				if(rst = '1')then
					state <= waiting;
					counter <= (others => '0');
					S <= (others => '0');
				else
					state <= next_state;
					counter <= next_counter;
					S(15 downto 0) <= next_S(16 downto 1);
					S(31 downto 16) <= next_s(32 downto 17);
					S(32) <= next_S(32);
				end if;
		end if;
	end process;
	
	
	general_proc: process(state, start, counter, S)
	begin
	
		next_state <= state;
		
		case state is
		
			when waiting =>
				valid <= '0';
				-- P <= (others => '0');
				next_S <= (others => '0');
				next_counter <= "00000";
				if(start = '1')then
					next_state <= run;
				end if;
				
			when run =>
				valid <= '0';
				next_counter <= "10000";
				next_S(17 downto 2) <= unsigned(Q);
				next_state <= calculate;
				
			when calculate =>
			
				next_counter <= counter - 1 ;
				valid <= '0';
				
				if(counter = 0)then
					next_state <= done;
				else
					if(S(0) = '0' and S(1) = '1')then
						next_s(32 downto 17) <= S(32 downto 17) + unsigned(not M) + 1;
						next_s(16 downto 0) <= S(16 downto 0);
					elsif(S(0) = '1' and S(1) = '0')then
						next_s(32 downto 17) <= S(32 downto 17) + unsigned(M);
						next_s(16 downto 0) <= S(16 downto 0);
					else
						next_s <= S;
					end if;
				end if;
				
			when done =>
				P <= std_logic_vector(S(32 downto 1));
				valid <= '1';
				next_state <= waiting;
				next_counter <= "00000";
		end case;
	end process;
					
					
					
				

end architecture;

