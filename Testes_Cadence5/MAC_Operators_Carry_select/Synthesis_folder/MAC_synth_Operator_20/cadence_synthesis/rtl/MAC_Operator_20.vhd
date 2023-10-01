LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--USE ieee.math_real.ALL;
--use ieee.std_logic_signed.all;
--use ieee.std_logic_signed.all;

ENTITY MAC_Operator_20 IS
    GENERIC (
        BITS       : NATURAL := 8;
        NUM_INPUTS : NATURAL := 20
    );
    PORT (
        X : IN signed((1 * BITS) - 1 DOWNTO 0);
        -- y : OUT signed((2 * BITS) - 1 DOWNTO 0)
        y : OUT signed(((2 * BITS) + 5) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF MAC_Operator_20 IS
    -------------------- COMPONENTS ---------------------

    -------------------- SIGNALS ---------------------
    SIGNAL s_mult                                            : signed(((2 * BITS) * (NUM_INPUTS - 1)) - 1 DOWNTO 0);
    -- SIGNAL sum_all                                           : signed(((2 * BITS) + 4) - 1 DOWNTO 0);
    SIGNAL sum_all                                           : signed(((2 * BITS) + 5) - 1 DOWNTO 0);
    SIGNAL Y_n112, Y_n108, Y_n107, Y_n76, Y_n75, Y_n60, bias : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL Y_n48, Y_n33, Y_n29, Y_n23, Y_3, Y_13, Y_46       : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL Y_99, Y_104, Y_111, Y_114, Y_119, Y_124           : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    -- SIGNAL Y_125                                             : signed((1 * 2 * BITS) - 1 DOWNTO 0);

BEGIN
    Y_n112  <= X * "10010000"; -- -112
    Y_n108  <= X * "10010100"; -- -108
    Y_n107  <= X * "10010101"; -- -107
    Y_n76   <= X * "10110100"; -- -76
    Y_n75   <= X * "10110101"; -- -75
    Y_n60   <= X * "11000100"; -- -60
    Y_n48   <= X * "11010000"; -- -48
    Y_n33   <= X * "11011111"; -- -33
    Y_n29   <= X * "11100011"; -- -29
    Y_n23   <= X * "11101001"; -- -23
    Y_3     <= X * "00000011"; -- 3
    Y_13    <= X * "00001101"; -- 13
    Y_46    <= X * "00101110"; -- 46
    Y_99    <= X * "01100011"; -- 99
    Y_104   <= X * "01101000"; -- 104
    Y_111   <= X * "01101111"; -- 111
    Y_114   <= X * "01110010"; -- 114
    Y_119   <= X * "01110111"; -- 119
    Y_124   <= X * "01111100"; -- 124
    -- Y_125   <= X * "01111101"; -- 125

    s_mult  <= (Y_n112 & Y_n108 & Y_n107 & Y_n76 & Y_n75 & Y_n60 & Y_n48 & Y_n33 & Y_n29 & Y_n23 & Y_3 & Y_13 & Y_46 & Y_99 & Y_104 & Y_111 & Y_114 & Y_119 & Y_124);
    bias    <= to_signed(100, bias'length);

    sum_all <= ("00000" & s_mult(((2 * BITS) * (0 + 1)) - 1 DOWNTO ((2 * BITS) * (0)))) +
        ("00000" & s_mult(((2 * BITS) * (1 + 1)) - 1 DOWNTO ((2 * BITS) * (1)))) +
        ("00000" & s_mult(((2 * BITS) * (2 + 1)) - 1 DOWNTO ((2 * BITS) * (2)))) +
        ("00000" & s_mult(((2 * BITS) * (3 + 1)) - 1 DOWNTO ((2 * BITS) * (3)))) +
        ("00000" & s_mult(((2 * BITS) * (4 + 1)) - 1 DOWNTO ((2 * BITS) * (4)))) +
        ("00000" & s_mult(((2 * BITS) * (5 + 1)) - 1 DOWNTO ((2 * BITS) * (5)))) +
        ("00000" & s_mult(((2 * BITS) * (6 + 1)) - 1 DOWNTO ((2 * BITS) * (6)))) +
        ("00000" & s_mult(((2 * BITS) * (7 + 1)) - 1 DOWNTO ((2 * BITS) * (7)))) +
        ("00000" & s_mult(((2 * BITS) * (8 + 1)) - 1 DOWNTO ((2 * BITS) * (8)))) +
        ("00000" & s_mult(((2 * BITS) * (9 + 1)) - 1 DOWNTO ((2 * BITS) * (9)))) +
        ("00000" & s_mult(((2 * BITS) * (10 + 1)) - 1 DOWNTO ((2 * BITS) * (10)))) +
        ("00000" & s_mult(((2 * BITS) * (11 + 1)) - 1 DOWNTO ((2 * BITS) * (11)))) +
        ("00000" & s_mult(((2 * BITS) * (12 + 1)) - 1 DOWNTO ((2 * BITS) * (12)))) +
        ("00000" & s_mult(((2 * BITS) * (13 + 1)) - 1 DOWNTO ((2 * BITS) * (13)))) +
        ("00000" & s_mult(((2 * BITS) * (14 + 1)) - 1 DOWNTO ((2 * BITS) * (14)))) +
        ("00000" & s_mult(((2 * BITS) * (15 + 1)) - 1 DOWNTO ((2 * BITS) * (15)))) +
        ("00000" & s_mult(((2 * BITS) * (16 + 1)) - 1 DOWNTO ((2 * BITS) * (16)))) +
        ("00000" & s_mult(((2 * BITS) * (17 + 1)) - 1 DOWNTO ((2 * BITS) * (17)))) +
        ("00000" & s_mult(((2 * BITS) * (18 + 1)) - 1 DOWNTO ((2 * BITS) * (18)))) +
        ("00000" & bias);

    -- sum_all <= (s_mult(((2 * BITS) * (0 + 1)) - 1 DOWNTO ((2 * BITS) * (0)))) +
    -- (s_mult(((2 * BITS) * (1 + 1)) - 1 DOWNTO ((2 * BITS) * (1)))) +
    -- (s_mult(((2 * BITS) * (2 + 1)) - 1 DOWNTO ((2 * BITS) * (2)))) +
    -- (s_mult(((2 * BITS) * (3 + 1)) - 1 DOWNTO ((2 * BITS) * (3)))) +
    -- (s_mult(((2 * BITS) * (4 + 1)) - 1 DOWNTO ((2 * BITS) * (4)))) +
    -- (s_mult(((2 * BITS) * (5 + 1)) - 1 DOWNTO ((2 * BITS) * (5)))) +
    -- (s_mult(((2 * BITS) * (6 + 1)) - 1 DOWNTO ((2 * BITS) * (6)))) +
    -- (s_mult(((2 * BITS) * (7 + 1)) - 1 DOWNTO ((2 * BITS) * (7)))) +
    -- (s_mult(((2 * BITS) * (8 + 1)) - 1 DOWNTO ((2 * BITS) * (8)))) +
    -- (s_mult(((2 * BITS) * (9 + 1)) - 1 DOWNTO ((2 * BITS) * (9)))) +
    -- (s_mult(((2 * BITS) * (10 + 1)) - 1 DOWNTO ((2 * BITS) * (10)))) +
    -- (s_mult(((2 * BITS) * (11 + 1)) - 1 DOWNTO ((2 * BITS) * (11)))) +
    -- (s_mult(((2 * BITS) * (12 + 1)) - 1 DOWNTO ((2 * BITS) * (12)))) +
    -- (s_mult(((2 * BITS) * (13 + 1)) - 1 DOWNTO ((2 * BITS) * (13)))) +
    -- (s_mult(((2 * BITS) * (14 + 1)) - 1 DOWNTO ((2 * BITS) * (14)))) +
    -- (s_mult(((2 * BITS) * (15 + 1)) - 1 DOWNTO ((2 * BITS) * (15)))) +
    -- (s_mult(((2 * BITS) * (16 + 1)) - 1 DOWNTO ((2 * BITS) * (16)))) +
    -- (s_mult(((2 * BITS) * (17 + 1)) - 1 DOWNTO ((2 * BITS) * (17)))) +
    -- (s_mult(((2 * BITS) * (18 + 1)) - 1 DOWNTO ((2 * BITS) * (18)))) +
    -- (bias);

    -- bias;
    y <= signed(sum_all);
END arch;