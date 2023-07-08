LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;


ENTITY elevator_tb IS
END elevator_tb;


ARCHITECTURE test OF elevator_tb IS 
	COMPONENT elevator IS
    PORT (
        clk             : IN    std_logic;
        nreset          : IN    std_logic;
        switch          : IN    std_logic_vector(4 DOWNTO 1);
        cf              : IN    std_logic_vector(4 DOWNTO 1);
        come            : IN    std_logic_vector(4 DOWNTO 1);
        move_state      : OUT   std_logic;
        current_floor   : OUT   INTEGER RANGE 3 DOWNTO 0;
        motor_down      : OUT   std_logic;
        motor_up        : OUT   std_logic
    );
    END COMPONENT;

    SIGNAL clk_tb             :    std_logic := '0';
    SIGNAL nreset_tb          :    std_logic;
    SIGNAL switch_tb          :    std_logic_vector(4 DOWNTO 1);
    SIGNAL cf_tb              :    std_logic_vector(4 DOWNTO 1);
    SIGNAL come_tb            :    std_logic_vector(4 DOWNTO 1);
    SIGNAL move_state_tb      :    std_logic;
    SIGNAL current_floor_tb   :    INTEGER RANGE 3 DOWNTO 0;
    SIGNAL motor_down_tb      :    std_logic;
    SIGNAL motor_up_tb        :    std_logic;
BEGIN
	-------------------------
	--  CUT Instantiation
	-------------------------
	CUT: elevator PORT MAP (clk_tb, nreset_tb, switch_tb, cf_tb, come_tb, move_state_tb, current_floor_tb, motor_down_tb, motor_up_tb);

	------------------------------
	--  Input Stimuli Assignment
    ------------------------------

    -- change floor after 40 ns
    
    clk_tb <= NOT clk_tb AFTER 5 ns;

    nreset_tb <= '1' AFTER 0 ns , '0' AFTER 6 ns;

    cf_tb <= "0100" AFTER 14 ns, "0000" AFTER 17 ns;

    switch_tb <= "0001" AFTER 0 ns, "0010" AFTER 55 ns, "0100" AFTER 95 ns, "0010" AFTER 195 ns;

    come_tb <= "0000" AFTER 0 ns, "0010" AFTER 150 ns;

END test;

