LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
ENTITY Array_Multiplier IS 
	
	PORT(
		 multiplicand : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		 multiplier   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		 product	  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
END Array_Multiplier;
ARCHITECTURE myarch OF Array_Multiplier IS 
	TYPE array_of_product IS ARRAY (0 TO 8) OF STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL bit_product, bit_carry, bit_sum : array_of_product;
BEGIN
	
	gen1:FOR i IN multiplier'REVERSE_RANGE GENERATE
		gen2:FOR j IN multiplicand'REVERSE_RANGE GENERATE
			bit_product(i)(j)<=multiplicand(j) and multiplier(i);
		END GENERATE;
		bit_carry(0)(i)<='0';
		--last line is adding the 0 we need after each time of multiplication
	END GENERATE;
	bit_sum(0)<=bit_product(0);
	product(0)<=bit_product(0)(0);												
	
	add1:FOR i IN 1 TO 7 GENERATE
		add2:FOR j IN 0 TO 6 GENERATE
			bit_sum(i)(j)  <= bit_product(i)(j) xor bit_sum(i-1)(j+1) xor bit_carry(i-1)(j);
			bit_carry(i)(j)<=(bit_product(i)(j) and bit_carry(i-1)(j)) or
			                 (bit_product(i)(j) and bit_sum(i-1)(j+1)) or
			                 (bit_carry(i-1)(j) and bit_sum(i-1)(j+1));
		END GENERATE;
		product(i)<=bit_sum(i)(0);
		bit_sum(i)(7)<=bit_product(i)(7); 
	END GENERATE;
	bit_carry(8)(0)<='0';
	
	
	
	lastadd:FOR k IN 1 TO 7 GENERATE
			bit_sum(8)(k)  <= bit_carry(8)(k-1)  xor bit_sum(7)(k) xor bit_carry(7)(k-1);
			bit_carry(8)(k)<=(bit_carry(8)(k-1)  and bit_carry(7)(k-1)) or
					         (bit_carry(8)(k-1)  and bit_sum(7)(k)) 	  or
		                     (bit_carry(7)(k-1)and bit_sum(7)(k));
    END GENERATE;
	product(15) <= bit_carry(8)(7);
	product(14 DOWNTO 8)<=bit_sum(8)(7 DOWNTO 1);
END myarch;

