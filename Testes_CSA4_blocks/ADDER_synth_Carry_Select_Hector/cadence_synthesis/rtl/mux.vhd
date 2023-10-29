LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY mux IS
    PORT (
        sel  : IN STD_LOGIC;
        A, B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        Y    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END mux;

ARCHITECTURE Behavioral OF mux IS
BEGIN
    -- PROCESS (sel, A, B)
    -- BEGIN
    --     IF sel = '0' THEN
    --         output <= A;
    --     ELSE
    --         output <= B;
    --     END IF;
    -- END PROCESS;
    output <= A WHEN (sel = '0') ELSE
        B;
END Behavioral;