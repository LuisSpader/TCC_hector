LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--USE ieee.math_real.ALL;
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;

ENTITY MAC_Operator_20 IS
    GENERIC (
        BITS       : NATURAL := 8;
        NUM_INPUTS : NATURAL := 20
    );
    PORT (
        X : IN unsigned((1 * BITS) - 1 DOWNTO 0);
        y : OUT unsigned(((2 * BITS) + 4) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF MAC_Operator_20 IS
    -------------------- COMPONENTS ---------------------

    -------------------- SIGNALS ---------------------
    SIGNAL s_mult                                            : unsigned(((2 * BITS) * (NUM_INPUTS - 1)) - 1 DOWNTO 0);
    SIGNAL sum_all                                           : unsigned(((2 * BITS) + 4) - 1 DOWNTO 0);
    SIGNAL Y_n112, Y_n108, Y_n107, Y_n76, Y_n75, Y_n60, bias : unsigned((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL Y_n48, Y_n33, Y_n29, Y_n23, Y_3, Y_13, Y_46       : unsigned((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL Y_99, Y_104, Y_111, Y_114, Y_119, Y_124           : unsigned((1 * 2 * BITS) - 1 DOWNTO 0);
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
    bias    <= to_unsigned(100, bias'length);

    sum_all <= ("0000" & s_mult(((2 * BITS) * (0 + 1)) - 1 DOWNTO ((2 * BITS) * (0)))) +
        ("0000" & s_mult(((2 * BITS) * (1 + 1)) - 1 DOWNTO ((2 * BITS) * (1)))) +
        ("0000" & s_mult(((2 * BITS) * (2 + 1)) - 1 DOWNTO ((2 * BITS) * (2)))) +
        ("0000" & s_mult(((2 * BITS) * (3 + 1)) - 1 DOWNTO ((2 * BITS) * (3)))) +
        ("0000" & s_mult(((2 * BITS) * (4 + 1)) - 1 DOWNTO ((2 * BITS) * (4)))) +
        ("0000" & s_mult(((2 * BITS) * (5 + 1)) - 1 DOWNTO ((2 * BITS) * (5)))) +
        ("0000" & s_mult(((2 * BITS) * (6 + 1)) - 1 DOWNTO ((2 * BITS) * (6)))) +
        ("0000" & s_mult(((2 * BITS) * (7 + 1)) - 1 DOWNTO ((2 * BITS) * (7)))) +
        ("0000" & s_mult(((2 * BITS) * (8 + 1)) - 1 DOWNTO ((2 * BITS) * (8)))) +
        ("0000" & s_mult(((2 * BITS) * (9 + 1)) - 1 DOWNTO ((2 * BITS) * (9)))) +
        ("0000" & s_mult(((2 * BITS) * (10 + 1)) - 1 DOWNTO ((2 * BITS) * (10)))) +
        ("0000" & s_mult(((2 * BITS) * (11 + 1)) - 1 DOWNTO ((2 * BITS) * (11)))) +
        ("0000" & s_mult(((2 * BITS) * (12 + 1)) - 1 DOWNTO ((2 * BITS) * (12)))) +
        ("0000" & s_mult(((2 * BITS) * (13 + 1)) - 1 DOWNTO ((2 * BITS) * (13)))) +
        ("0000" & s_mult(((2 * BITS) * (14 + 1)) - 1 DOWNTO ((2 * BITS) * (14)))) +
        ("0000" & s_mult(((2 * BITS) * (15 + 1)) - 1 DOWNTO ((2 * BITS) * (15)))) +
        ("0000" & s_mult(((2 * BITS) * (16 + 1)) - 1 DOWNTO ((2 * BITS) * (16)))) +
        ("0000" & s_mult(((2 * BITS) * (17 + 1)) - 1 DOWNTO ((2 * BITS) * (17)))) +
        ("0000" & s_mult(((2 * BITS) * (18 + 1)) - 1 DOWNTO ((2 * BITS) * (18)))) +
        ("0000" & bias);
    -- bias;
    y <= unsigned(sum_all);
END arch;
