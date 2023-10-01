LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY carry_select_adder IS
    GENERIC (
        bits : POSITIVE := 16
    );
    PORT (
        a, b : IN UNSIGNED((bits - 1) DOWNTO 0);
        res  : OUT UNSIGNED((bits - 1) DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF carry_select_adder IS
    -- SIGNAL carry_final                                             : UNSIGNED(bits DOWNTO 0);
    -- SIGNAL c_lsb, c0, c1                                           : UNSIGNED(bits/2 DOWNTO 0);
    SIGNAL a_LSB, b_LSB, G_LSB                                                  : UNSIGNED((bits/2) DOWNTO 0); -- 8 downto 0 ( 9 bits)
    -- SIGNAL a_MSB_0, b_MSB_0, a_MSB_1, b_MSB_1, G_0, G_1 : UNSIGNED((bits/2) + 1 DOWNTO 0);

    SIGNAL a_MSB_0, b_MSB_0, a_MSB_1, b_MSB_1, G_0, G_1                         : UNSIGNED((bits/2) DOWNTO 0);
    SIGNAL a_MSB_0_odd, b_MSB_0_odd, a_MSB_1_odd, b_MSB_1_odd, G_0_odd, G_1_odd : UNSIGNED((bits/2) + 1 DOWNTO 0);

BEGIN

    G_LSB((bits/2) DOWNTO 0) <= a_LSB + b_LSB;
    -- a_MSB_0                      <= a((bits - 1) DOWNTO (bits/2)) & '0';

    -- b_MSB_0                      <= b((bits - 1) DOWNTO (bits/2)) & '0';

    -- a_MSB_1                  <= a((bits - 1) DOWNTO (bits/2)) & '1';

    -- b_MSB_1                  <= b((bits - 1) DOWNTO (bits/2)) & '1';

    -- Conditional generation based on 'bits' being even or odd
    -- When 'bits' is even
    ig_gen_proc : IF bits MOD 2 = 0 GENERATE
        a_LSB                           <= '0' & a(((bits/2) - 1) DOWNTO 0);
        b_LSB                           <= '0' & b(((bits/2) - 1) DOWNTO 0);
        res(((bits/2) - 1) DOWNTO 0)    <= G_LSB(((bits/2) - 1) DOWNTO 0);

        a_MSB_0                         <= a((bits - 1) DOWNTO (bits/2)) & '0';
        b_MSB_0                         <= b((bits - 1) DOWNTO (bits/2)) & '0';
        a_MSB_1                         <= a((bits - 1) DOWNTO (bits/2)) & '1';
        b_MSB_1                         <= b((bits - 1) DOWNTO (bits/2)) & '1';

        G_0((bits/2) DOWNTO 0)          <= a_MSB_0 + b_MSB_0;
        G_1((bits/2) DOWNTO 0)          <= a_MSB_1 + b_MSB_1;
        res((bits - 1) DOWNTO (bits/2)) <= G_0((bits/2) DOWNTO 1) WHEN G_LSB((bits/2)) = '0' ELSE
        G_1((bits/2) DOWNTO 1);

        ELSE
        GENERATE
            -- When 'bits' is odd 16 downto 9 (8 bits)
            --                                        17/2 = 8 -1 = 7 (8 bits)
            -- a_LSB                     <= '0' & a(7 DOWNTO 0);
            a_LSB                           <= '0' & a(((bits/2) - 1) DOWNTO 0);
            b_LSB                           <= '0' & b(((bits/2) - 1) DOWNTO 0);
            res(((bits/2) - 1) DOWNTO 0)    <= G_LSB(((bits/2) - 1) DOWNTO 0); -- 7 downto 0

            --                                17 -1 =16         (17-1)/2 =8 (9 bits) & '0' (10 bits)
            -- a_MSB_0                   <= a(16 DOWNTO 8) & '0';
            a_MSB_0_odd                     <= a((bits - 1) DOWNTO ((bits - 1) / 2)) & '0';
            b_MSB_0_odd                     <= b((bits - 1) DOWNTO ((bits - 1) / 2)) & '0';
            a_MSB_1_odd                     <= a((bits - 1) DOWNTO ((bits - 1) / 2)) & '1';
            b_MSB_1_odd                     <= b((bits - 1) DOWNTO ((bits - 1) / 2)) & '1';

            G_0_odd                         <= a_MSB_0_odd + b_MSB_0_odd;
            G_1_odd                         <= a_MSB_1_odd + b_MSB_1_odd;
            -- res(16 DOWNTO 8) <= G_0(9 DOWNTO 1) WHEN G_LSB((bits/2)) = '0' ELSE
            -- G_1(9 DOWNTO 1);
            res((bits - 1) DOWNTO (bits/2)) <= G_0_odd((bits/2) + 1 DOWNTO 1) WHEN G_LSB((bits/2)) = '0' ELSE
            G_1_odd((bits/2) + 1 DOWNTO 1);

        END GENERATE;

        -- G_0((bits/2) + 1 DOWNTO 0) <= a_MSB_0 + b_MSB_0;

        -- G_1((bits/2) + 1 DOWNTO 0) <= a_MSB_1 + b_MSB_1;

        -- res((bits -1) DOWNTO (bits/2))    <= G_0((bits/2) + 1 DOWNTO 2) WHEN G_LSB((bits/2)) = '0' ELSE
        -- G_1((bits/2) + 1 DOWNTO 2);

        -- --------------------------------------------------------------------------------
        -- G_0((bits/2) DOWNTO 0)          <= a_MSB_0 + b_MSB_0;

        -- G_1((bits/2) DOWNTO 0)          <= a_MSB_1 + b_MSB_1;

        -- res((bits - 1) DOWNTO (bits/2)) <= G_0((bits/2) DOWNTO 1) WHEN G_LSB((bits/2)) = '0' ELSE
        -- G_1((bits/2) DOWNTO 1);

        -- --------------------------------------------------------------------------------
        -- c_lsb((BITS/2) DOWNTO 0)           <= a((BITS/2) - 1 DOWNTO 0) + b((BITS/2) - 1 DOWNTO 0);

        -- c0                                 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1)));

        -- c1                                 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + '1';

        -- carry_final((BITS/2) - 1 DOWNTO 0) <= c_lsb((BITS/2) - 1 DOWNTO 0); -- (bits/2) -1 downto 0

        -- IF_PROC : PROCESS (c_lsb(BITS/2))                                   -- 4  
        -- BEGIN
        --     IF c_lsb(BITS/2) = '0' THEN
        --         carry_final(BITS DOWNTO BITS/2) <= c0;
        --     ELSE
        --         carry_final(BITS DOWNTO BITS/2) <= c1;
        --     END IF;

        -- END PROCESS;

        -- res <= carry_final;
    END ARCHITECTURE;