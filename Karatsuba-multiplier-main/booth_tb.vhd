----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:07:13 01/28/2023 
-- Design Name: 
-- Module Name:    booth_tb - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity booth_tb is
end booth_tb;

architecture Behavioral of booth_tb is
signal clk_tb, start_tb, rst_tb, valid_tb : std_logic := '0';
signal m_tb, q_tb : std_logic_vector(15 downto 0) := (others => '0');
signal p_tb : std_logic_vector(31 downto 0) := (others => '0');
begin	
	clock: process
	begin
		clk_tb <= '0';
		wait for 10ns;
		clk_tb <= '1';
		wait for 10ns;
	end process;
	m_tb <= "0000000000010111";
	q_tb <= "0000000000000111";
	rst_tb <= '0';
	start_tb <= '1';
	boothentity: entity work.Booth16 port map(clk_tb, rst_tb, start_tb, m_tb, q_tb, valid_tb, p_tb);

end Behavioral;

