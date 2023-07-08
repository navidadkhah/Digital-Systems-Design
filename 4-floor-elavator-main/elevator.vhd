LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.ALL;


ENTITY elevator IS
  PORT (
        clk             : IN    std_logic;
        nreset          : IN    std_logic;
        switch          : IN    std_logic_vector(4 DOWNTO 1);
        cf              : IN    std_logic_vector(4 DOWNTO 1);
        come            : IN    std_logic_vector(4 DOWNTO 1);

        move_state      : OUT   std_logic; --shown in PRJ file table as elevator state
        -- 0 for still and 1 for moving
        current_floor   : OUT   INTEGER RANGE 3 DOWNTO 0;
        motor_down      : OUT   std_logic;
        motor_up        : OUT   std_logic
  ) ;
END elevator;

ARCHITECTURE behavioral OF elevator IS
    TYPE state IS (up, down, staid);
    SIGNAL curr_state : state := staid;
    SIGNAL next_state : state := staid;
    SIGNAL request : INTEGER RANGE 3 DOWNTO 0 := 0;
    SIGNAL tmp_current_floor : INTEGER RANGE 3 DOWNTO 0 := 0;
BEGIN
    current_floor <= tmp_current_floor;


    PROCESS(clk)
    BEGIN
        IF (clk = '1' AND ( NOT (nreset = '1'))) THEN
            curr_state <= next_state;
        END IF;
    END PROCESS;
        
    PROCESS(clk)
    BEGIN
        IF (clk='1' AND nreset='1') THEN --RESET
            motor_down<='0';
            motor_up<='0';
            move_state<='0';
            next_state <= staid;
        ELSIF (clk='1' AND curr_state=staid) THEN 
            motor_down<='0';
            motor_up<='0';
            move_state<='0';
            if (tmp_current_floor=request) THEN
                next_state<= staid;
            ELSIF (tmp_current_floor < request) THEN
                next_state<= up;
            ELSIF(tmp_current_floor > request) THEN
                next_state<= down;
            END IF;
        ELSIF (clk='1' AND curr_state=up) THEN 
            motor_down<='0';
            motor_up<='1';
            move_state<='1';
            IF (tmp_current_floor=request) THEN
                next_state<= staid;
            ELSIF (tmp_current_floor < request) THEN
                next_state<= up;
            END IF;
        ELSIF (clk='1' AND curr_state=down) THEN 
            motor_down<='1';
            motor_up<='0';
            move_state<='1';
            IF (tmp_current_floor=request) THEN
                next_state<= staid;
            ELSIF(tmp_current_floor >= request) THEN
                next_state<= down;
            END IF;
        END IF;
    END PROCESS ;
  
    PROCESS(switch, nreset)
    BEGIN
        IF (nreset'EVENT AND nreset = '1') THEN
            tmp_current_floor <= 0;
        ELSIF(switch'EVENT AND switch="0001") THEN
            tmp_current_floor<=0;
        ELSIF(switch'EVENT AND switch="0010") THEN
            tmp_current_floor<=1;
        ELSIF(switch'EVENT AND switch="0100") THEN
            tmp_current_floor<=2;
        ELSIF(switch'EVENT AND switch="1000") THEN
            tmp_current_floor<=3;
        END IF;
    END PROCESS ;
  
    PROCESS(cf , come, nreset)
    BEGIN
        IF (nreset'EVENT AND nreset = '1') THEN
            request <= 0;
        ELSIF(cf'EVENT AND cf="1000") THEN
            request<=3;
        ELSIF(cf'EVENT AND cf="0100" ) THEN
            request<=2;
        ELSIF(cf'EVENT AND cf="0010" ) THEN
            request<=1;
        ELSIF(cf'EVENT AND cf="0001" ) THEN
            request<=0;
        ELSIF(come'EVENT AND come="1000" ) THEN
            request<=3;
        ELSIF(come'EVENT AND come="0100" ) THEN
            request<=2;
        ELSIF(come'EVENT AND come="0010" ) THEN
            request<=1;
        ELSIF(come'EVENT AND come="0001" ) THEN
            request<=0;
        END IF;
    END PROCESS;
END behavioral;

