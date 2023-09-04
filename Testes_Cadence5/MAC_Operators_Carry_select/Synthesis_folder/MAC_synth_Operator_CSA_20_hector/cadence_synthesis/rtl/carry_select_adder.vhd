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
    SIGNAL carry_final                                      : UNSIGNED(bits DOWNTO 0);
    SIGNAL c_lsb, c0, c1                                    : UNSIGNED(bits/2 DOWNTO 0);
    SIGNAL a_LSB, b_LSB, a_MSB_0, b_MSB_0, a_MSB_1, b_MSB_1 : UNSIGNED((bits/2) DOWNTO 0);

BEGIN

    a_LSB             <= '0' & a(7 DOWNTO 0);

    b_LSB             <= '0' & b(7 DOWNTO 0);

    G_LSB(8 DOWNTO 0) <= a_LSB + b_LSB;

    res(7 DOWNTO 0)   <= G_LSB(7 DOWNTO 0);

    a_MSB_0           <= a(15 DOWNTO 8) & '0';

    b_MSB_0           <= b(15 DOWNTO 8) & '0';

    a_MSB_1           <= a(15 DOWNTO 8) & '1';

    b_MSB_1           <= b(15 DOWNTO 8) & '1';

    G_0(8 DOWNTO 0)   <= a_MSB_0 + b_MSB_0;

    G_1(8 DOWNTO 0)   <= a_MSB_1 + b_MSB_1;

    res(15 DOWNTO 8)  <= G_0(8 DOWNTO 1) WHEN G_LSB(8) = 0 ELSE
    G_1(8 DOWNTO 1);
    -- --------------------------------------------------------------------------------
    -- c_lsb((BITS/2) DOWNTO 0)           <= a((BITS/2) - 1 DOWNTO 0) + b((BITS/2) - 1 DOWNTO 0);

    -- c0                                 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1)));

    -- c1                                 <= a(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + b(((BITS/2) * (2)) - 1 DOWNTO ((BITS/2) * (1))) + '1';

    -- carry_final((BITS/2) - 1 DOWNTO 0) <= c_lsb((BITS/2) - 1 DOWNTO 0); -- 7 downto 0

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