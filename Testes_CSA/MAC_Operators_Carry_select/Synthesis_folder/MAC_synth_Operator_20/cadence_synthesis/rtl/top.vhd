LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top IS
    -- GENERIC (
    --     bits : POSITIVE := 16
    -- );
    PORT (
        a, b : IN UNSIGNED(15 DOWNTO 0);
        res  : OUT UNSIGNED(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF top IS
    -- SIGNAL sa, sb : UNSIGNED(16 DOWNTO 0);

BEGIN
    -- sa  <= '0' & a;
    -- sb  <= '0' & b;
    -- res <= sa + sb;
    res <= a + b;

END ARCHITECTURE;