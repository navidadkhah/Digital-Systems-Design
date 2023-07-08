LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
ENTITY uart2 IS
	PORT (
         rst   : IN  std_logic;
         clk   : IN  std_logic;
  
        -- Parallel 2 Serial : Send
        start : IN  std_logic;
        din	  : IN  std_logic_vector(7 DOWNTO 0);
        tx    : OUT std_logic;			

        -- Serial 2 Parallel : RECIEVE
        rx    : IN  std_logic;			
        dout  : OUT std_logic_vector(7 DOWNTO 0);
        done  : OUT std_logic;

		baud  : IN  std_logic_vector(7 DOWNTO 0)
	);

END uart2;

ARCHITECTURE test OF uart2 IS
	--registers
	SIGNAL data_in_reg : std_logic_vector(7 DOWNTO 0);
	SIGNAL data_out_reg : std_logic_vector(7 DOWNTO 0);
	SIGNAL is_sending : std_logic;
	SIGNAL is_receiving : std_logic;
	SIGNAL parity : std_logic;
	SIGNAL reset_send : std_logic;
	SIGNAL data_is_ready : std_logic := '0';
	SIGNAL tx_reg : std_logic := '1';
	--counters
	SIGNAL clk_counter : INTEGER := 0;
	SIGNAL baud_counter : INTEGER := 0;
BEGIN
	seq : PROCESS (clk)
	BEGIN
		IF clk = '1' THEN
			IF rst = '0' THEN -- this variable changed to notreset but we kept the name as it is
				is_sending <= '0';
				is_receiving <= '0';
				baud_counter <= 0;
			ELSIF is_sending = '0' AND is_receiving = '0' THEN
				IF start = '1' THEN
					is_sending <= '1';
					clk_counter <= 1;
					baud_counter <= 1;
				ELSIF rx = '0' THEN
					is_receiving <= '1';
					clk_counter <= 1;
					baud_counter <= 1;
				END IF;
			ELSE
				IF clk_counter = to_integer(unsigned(baud)) THEN
					IF reset_send = '1' THEN
						baud_counter <= 1;
					ELSIF baud_counter = 13 THEN
						is_sending <= '0';
						is_receiving <= '0';
						baud_counter <= 0;
					ELSE
						baud_counter <= baud_counter + 1;
					END IF;
					clk_counter <= 1;
				ELSE
					clk_counter <= clk_counter + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS seq;

	rt : PROCESS (baud_counter)
	BEGIN
		IF is_sending = '1' THEN
			IF baud_counter = 1 THEN
				tx_reg <= '0';
				if reset_send = '1' then
					reset_send <= '0';
				else
					data_in_reg <= din;
					parity <= din(0) XOR din(1) XOR din(2) XOR din(3) XOR din(4) XOR din(5) XOR din(6) XOR din(7);
					end if;
			ELSIF baud_counter > 1 AND baud_counter <= 9 THEN
				tx_reg <= data_in_reg(0);
				data_in_reg <= '0' & data_in_reg(7 DOWNTO 1);
			ELSIF baud_counter = 10 THEN
				tx_reg <= parity;
			ELSIF baud_counter = 11 THEN
				tx_reg <= '1';
			ELSIF baud_counter = 13 THEN
				IF rx = '0' THEN
					reset_send <= '1';
				END IF;
			END IF;
		ELSIF is_receiving = '1' THEN
			IF baud_counter = 0 THEN
				data_is_ready <= '0';
				tx_reg <= '1';
			ELSIF baud_counter > 1 AND baud_counter <= 9 THEN
				tx_reg <= '1';
				data_out_reg <= rx & data_out_reg(7 DOWNTO 1);
			ELSIF baud_counter = 10 THEN
				parity <= rx;
			ELSIF baud_counter = 11 THEN
				IF parity = (data_out_reg(0) XOR data_out_reg(1) XOR data_out_reg(2) XOR data_out_reg(3) XOR data_out_reg(4) XOR data_out_reg(5) XOR data_out_reg(6) XOR data_out_reg(7)) THEN
					data_is_ready <= '1';
				ELSE
					tx_reg <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS rt;

	tx <= tx_reg;
	done <= data_is_ready;
	dout <= data_out_reg;

End test;