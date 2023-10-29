LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top IS
    GENERIC (
        bits : POSITIVE := 16
    );
    PORT (
        a, b : IN UNSIGNED((bits - 1) DOWNTO 0);
        res  : OUT UNSIGNED((bits - 1) DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF top IS
    SIGNAL a_LSB, b_LSB, G_LSB                                                  : UNSIGNED(8 DOWNTO 0); -- 8 downto 0 ( 9 bits)

    SIGNAL a_MSB_0, b_MSB_0, a_MSB_1, b_MSB_1, G_0, G_1                         : UNSIGNED(8 DOWNTO 0);
    SIGNAL a_MSB_0_odd, b_MSB_0_odd, a_MSB_1_odd, b_MSB_1_odd, G_0_odd, G_1_odd : UNSIGNED(8 + 1 DOWNTO 0);

BEGIN

    G_LSB(8 DOWNTO 0) <= a_LSB + b_LSB;

    -- Conditional generation based on 'bits' being even or odd
    -- When 'bits' is even
    ig_gen_proc : IF bits MOD 2 = 0 GENERATE
        a_LSB                    <= '0' & a((8 - 1) DOWNTO 0);
        b_LSB                    <= '0' & b((8 - 1) DOWNTO 0);
        res((8 - 1) DOWNTO 0)    <= G_LSB((8 - 1) DOWNTO 0);

        a_MSB_0                  <= a((bits - 1) DOWNTO 8) & '0';
        b_MSB_0                  <= b((bits - 1) DOWNTO 8) & '0';
        a_MSB_1                  <= a((bits - 1) DOWNTO 8) & '1';
        b_MSB_1                  <= b((bits - 1) DOWNTO 8) & '1';

        G_0(8 DOWNTO 0)          <= a_MSB_0 + b_MSB_0;
        G_1(8 DOWNTO 0)          <= a_MSB_1 + b_MSB_1;
        res((bits - 1) DOWNTO 8) <= G_0(8 DOWNTO 1) WHEN G_LSB(8) = '0' ELSE
        G_1(8 DOWNTO 1);

    ELSE
        GENERATE
            -- When 'bits' is odd 16 downto 9 (8 bits)
            --                                        17/2 = 8 -1 = 7 (8 bits)
            -- a_LSB                     <= '0' & a(7 DOWNTO 0);
            a_LSB                    <= '0' & a((8 - 1) DOWNTO 0);
            b_LSB                    <= '0' & b((8 - 1) DOWNTO 0);
            res((8 - 1) DOWNTO 0)    <= G_LSB((8 - 1) DOWNTO 0); -- 7 downto 0

            --                                17 -1 =16         (17-1)/2 =8 (9 bits) & '0' (10 bits)
            -- a_MSB_0                   <= a(16 DOWNTO 8) & '0';
            a_MSB_0_odd              <= a((bits - 1) DOWNTO (15)) & '0';
            b_MSB_0_odd              <= b((bits - 1) DOWNTO (15)) & '0';
            a_MSB_1_odd              <= a((bits - 1) DOWNTO (15)) & '1';
            b_MSB_1_odd              <= b((bits - 1) DOWNTO (15)) & '1';

            G_0_odd                  <= a_MSB_0_odd + b_MSB_0_odd;
            G_1_odd                  <= a_MSB_1_odd + b_MSB_1_odd;
            -- res(16 DOWNTO 8) <= G_0(9 DOWNTO 1) WHEN G_LSB(8) = '0' ELSE
            -- G_1(9 DOWNTO 1);
            res((bits - 1) DOWNTO 8) <= G_0_odd(8 + 1 DOWNTO 1) WHEN G_LSB(8) = '0' ELSE
            G_1_odd(8 + 1 DOWNTO 1);

        END GENERATE;

        -- G_0(8 + 1 DOWNTO 0) <= a_MSB_0 + b_MSB_0;

        -- G_1(8 + 1 DOWNTO 0) <= a_MSB_1 + b_MSB_1;

        -- res((bits -1) DOWNTO 8)    <= G_0(8 + 1 DOWNTO 2) WHEN G_LSB(8) = '0' ELSE
        -- G_1(8 + 1 DOWNTO 2);

        -- --------------------------------------------------------------------------------
        -- G_0(8 DOWNTO 0)          <= a_MSB_0 + b_MSB_0;

        -- G_1(8 DOWNTO 0)          <= a_MSB_1 + b_MSB_1;

        -- res((bits - 1) DOWNTO 8) <= G_0(8 DOWNTO 1) WHEN G_LSB(8) = '0' ELSE
        -- G_1(8 DOWNTO 1);

        -- --------------------------------------------------------------------------------
        -- c_lsb((BITS/2) DOWNTO 0)           <= a((BITS/2) - 1 DOWNTO 0) + b((BITS/2) - 1 DOWNTO 0);

        -- c0                                 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1)));

        -- c1                                 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + '1';

        -- carry_final((BITS/2) - 1 DOWNTO 0) <= c_lsb((BITS/2) - 1 DOWNTO 0); -- 8 -1 downto 0

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