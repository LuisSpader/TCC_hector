LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CSA IS
    GENERIC (
        bits : POSITIVE := 17
    );
    PORT (
        a, b : IN UNSIGNED((bits - 1) DOWNTO 0);
        res  : OUT UNSIGNED((bits - 1) DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF CSA IS
    SIGNAL carry_final : UNSIGNED((bits - 1) DOWNTO 0);
    SIGNAL c_lsb       : UNSIGNED((bits/2) DOWNTO 0);
    SIGNAL c0, c1      : UNSIGNED((bits/2) DOWNTO 0);
    -- SIGNAL c0_odd, c1_odd : UNSIGNED(16 DOWNTO 0);

BEGIN

    res                                <= carry_final;
    c_lsb((bits/2) DOWNTO 0)           <= '0' & a((bits/2) - 1 DOWNTO 0) + b((bits/2) - 1 DOWNTO 0);
    carry_final((bits/2) - 1 DOWNTO 0) <= c_lsb((bits/2) - 1 DOWNTO 0); -- 3 downto 0

    c0                                 <= a((bits - 1) DOWNTO (bits/2)) + b((bits - 1) DOWNTO (bits/2));
    --    c1                                 <= a((bits -1) DOWNTO (bits/2)) + b((bits -1) DOWNTO (bits/2)) +  to_unsigned(1, b'length);
    c1                                 <= a((bits - 1) DOWNTO (bits/2)) + b((bits - 1) DOWNTO (bits/2)) + to_unsigned(1, 1);

    IF_PROC : PROCESS (c_lsb((bits/2)), c0, c1) -- 4  
    BEGIN
        IF c_lsb((bits/2)) = '0' THEN
            -- (bits -1) downto (bits/2) 
            carry_final((bits - 1) DOWNTO (bits/2)) <= c0;
        ELSE
            carry_final((bits - 1) DOWNTO (bits/2)) <= c1;
        END IF;

    END PROCESS;
END ARCHITECTURE;