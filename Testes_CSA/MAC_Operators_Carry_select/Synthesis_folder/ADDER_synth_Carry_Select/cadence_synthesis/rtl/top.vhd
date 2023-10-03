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
    SIGNAL carry_final : UNSIGNED(15 DOWNTO 0);
    SIGNAL c_lsb       : UNSIGNED(8 DOWNTO 0);
    SIGNAL c0, c1      : UNSIGNED(7 DOWNTO 0);
    -- SIGNAL c0_odd, c1_odd : UNSIGNED(16 DOWNTO 0);

BEGIN

    res                     <= carry_final;
    c_lsb(8 DOWNTO 0)       <= '0' & a(7 DOWNTO 0) + b(7 DOWNTO 0);
    carry_final(7 DOWNTO 0) <= c_lsb(7 DOWNTO 0); -- 3 downto 0

    c0                      <= a(16 - 1 DOWNTO 8) + b(16 - 1 DOWNTO 8);
    --    c1                                 <= a(16 - 1 DOWNTO 8) + b(16 - 1 DOWNTO 8) +  to_unsigned(1, b'length);
    c1                      <= a(16 - 1 DOWNTO 8) + b(16 - 1 DOWNTO 8) + to_unsigned(1, 1);

    IF_PROC : PROCESS (c_lsb(8), c0, c1) -- 4  
    BEGIN
        IF c_lsb(8) = '0' THEN
            -- 15 downto 8 
            carry_final(15 DOWNTO 8) <= c0;
        ELSE
            carry_final(15 DOWNTO 8) <= c1;
        END IF;

    END PROCESS;
END ARCHITECTURE;