LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tea_tb IS
END tea_tb;

ARCHITECTURE test OF tea_tb IS

    COMPONENT tea2
        PORT (
            clock : IN STD_LOGIC;
            start : IN STD_LOGIC;
            key : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
            plain : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
            cipher : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL t_clock : STD_LOGIC := '0';
    SIGNAL t_start : STD_LOGIC;
    SIGNAL t_key : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL t_plain : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL t_cipher : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL t_done : STD_LOGIC;
BEGIN

    t_clock <= NOT t_clock AFTER 5 ns;
    t_start <= '0', '1' AFTER 30 ns;
    tb : PROCESS
    BEGIN
        t_key <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111";
        t_plain <= "0110111101000001011011000110100101001000011001010110110001101100";
        wait;
    END PROCESS tb;
    uut : tea2 PORT MAP(
        clock => t_clock,
        start => t_start,
        key => t_key,
        plain => t_plain,
        cipher => t_cipher,
        done => t_done
    );
END ARCHITECTURE; -- test
