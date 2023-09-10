LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY carry_select_adder IS
    GENERIC (
        bits : POSITIVE := 16
    );
    PORT (
        a, b : IN UNSIGNED(bits - 1 DOWNTO 0);
        res  : OUT UNSIGNED(bits - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF carry_select_adder IS
    SIGNAL carry_final    : UNSIGNED(bits - 1 DOWNTO 0);
    SIGNAL c_lsb          : UNSIGNED(bits/2 DOWNTO 0);
    SIGNAL c0, c1         : UNSIGNED(bits/2 - 1 DOWNTO 0);
    SIGNAL c0_odd, c1_odd : UNSIGNED((bits/2) + 1 - 1 DOWNTO 0);

BEGIN

    res                                <= carry_final;
    c_lsb((BITS/2) DOWNTO 0)           <= '0' & a((BITS/2) - 1 DOWNTO 0) + b((BITS/2) - 1 DOWNTO 0);
    carry_final((BITS/2) - 1 DOWNTO 0) <= c_lsb((BITS/2) - 1 DOWNTO 0); -- 3 downto 0

    -- Conditional generation based on 'bits' being even or odd
    ig_gen_proc : IF bits MOD 2 = 0 GENERATE
        -- When 'bits' is even

        c0 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1)));
        --    c1                                 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) +  to_unsigned(1, b'length);
        c1 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + to_unsigned(1, 1);

        IF_PROC : PROCESS (c_lsb(BITS/2), c0, c1) -- 4  
        BEGIN
            IF c_lsb(BITS/2) = '0' THEN
                -- 15 downto 8 
                carry_final(BITS - 1 DOWNTO BITS/2) <= c0;
                ELSE
                carry_final(BITS - 1 DOWNTO BITS/2) <= c1;
            END IF;

        END PROCESS;
        ELSE
        GENERATE
            -- When 'bits' is odd
            --             17 -1 downto 8 (9 bits)         
            c0_odd <= a((BITS - 1) DOWNTO BITS/2) + b((BITS - 1) DOWNTO BITS/2);
            --    c1                                 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) +  to_unsigned(1, b'length);
            c1_odd <= a((BITS - 1) DOWNTO BITS/2) + b((BITS - 1) DOWNTO BITS/2) + to_unsigned(1, 1);

            IF_PROC : PROCESS (c_lsb(BITS/2), c0_odd, c1_odd) -- 4  
            BEGIN
                IF c_lsb(BITS/2) = '0' THEN
                    -- 16 downto 8 
                    carry_final((BITS - 1) DOWNTO BITS/2) <= c0_odd;
                    ELSE
                    carry_final((BITS - 1) DOWNTO BITS/2) <= c1_odd;
                END IF;

            END PROCESS;
        END GENERATE;

    END ARCHITECTURE;