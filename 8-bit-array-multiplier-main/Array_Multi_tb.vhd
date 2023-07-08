LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
ENTITY Array_Multiplier_tb IS 
END Array_Multiplier_tb;
ARCHITECTURE myarch_tb OF Array_Multiplier_tb IS 
	COMPONENT Array_Multiplier IS
		--GENERIC  ;
		PORT(
		     multiplicand : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		     multiplier   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		     product	  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		    );
	END COMPONENT;
	SIGNAL multiplicand_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL multiplier_tb   : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL product_tb	   : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	cut : Array_Multiplier GENERIC MAP (8)
						   PORT MAP(multiplicand => multiplicand_tb, multiplier => multiplier_tb, product => product_tb);
	multiplicand_tb <= "10000001", "10010001" AFTER  10 ns, "00001001" AFTER  20 ns;
	multiplier_tb   <= "00000001", "00000010" AFTER  30 ns;
END myarch_tb;

