LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--USE ieee.math_real.ALL;
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;
ENTITY MAC_Operator_20_CSA IS
    GENERIC (
        BITS       : NATURAL := 8;
        NUM_INPUTS : NATURAL := 20
    );
    PORT (
        X : IN signed((1 * BITS) - 1 DOWNTO 0);
        y : OUT signed(((2 * BITS) + 4) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF MAC_Operator_20_CSA IS
    -------------------- COMPONENTS ---------------------
    COMPONENT carry_select_adder IS
        GENERIC (
            bits : POSITIVE := 16
        );
        PORT (
            a, b : IN UNSIGNED(bits - 1 DOWNTO 0);
            res  : OUT UNSIGNED(bits - 1 DOWNTO 0)
        );
    END COMPONENT;
    -------------------- SIGNALS ---------------------
    SIGNAL s_mult                                                               : signed(((2 * BITS) * (NUM_INPUTS - 1)) - 1 DOWNTO 0);
    SIGNAL sum_all                                                              : signed(((2 * BITS) + 4) - 1 DOWNTO 0);
    SIGNAL Y_n112, Y_n108, Y_n107, Y_n76, Y_n75, Y_n60, bias                    : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL Y_n48, Y_n33, Y_n29, Y_n23, Y_3, Y_13, Y_46                          : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL Y_99, Y_104, Y_111, Y_114, Y_119, Y_124                              : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    -- SIGNAL Y_125                                             : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, s_bias      : unsigned((2 * BITS) - 1 DOWNTO 0);
    SIGNAL n0_r0, n0_r1, n0_r2, n0_r3, n0_r4, n0_r5, n0_r6, n0_r7, n0_r8, n0_r9 : unsigned((2 * BITS) - 1 DOWNTO 0);

    SIGNAL n1_r0, n1_r1, n1_r2, n1_r3, n1_r4, n2_r0, n2_r1, n3_r0, n4_r0        : unsigned((2 * BITS) - 1 DOWNTO 0);
BEGIN

    -- Y_n112_LSB(((BITS/2) * (1)) - 1 DOWNTO ((BITS/2) * (0)))   <= X(((BITS/2) * (1)) - 1 DOWNTO ((BITS/2) * (0))) * "0000";     -- -112
    -- Y_n112_MSB_0(((BITS/2) * (3)) - 1 DOWNTO ((BITS/2) * (2))) <= X(((BITS/2) * (3)) - 1 DOWNTO ((BITS/2) * (2))) * "0000";     -- -112
    -- Y_n112_MSB_1(((BITS/2) * (3)) - 1 DOWNTO ((BITS/2) * (2))) <= X(((BITS/2) * (3)) - 1 DOWNTO ((BITS/2) * (2))) * "0000" + 1; -- -112

    Y_n112 <= X * "10010000"; -- -112
    Y_n108 <= X * "10010100"; -- -108
    Y_n107 <= X * "10010101"; -- -107
    Y_n76  <= X * "10110100"; -- -76
    Y_n75  <= X * "10110101"; -- -75
    Y_n60  <= X * "11000100"; -- -60
    Y_n48  <= X * "11010000"; -- -48
    Y_n33  <= X * "11011111"; -- -33
    Y_n29  <= X * "11100011"; -- -29
    Y_n23  <= X * "11101001"; -- -23
    Y_3    <= X * "00000011"; -- 3
    Y_13   <= X * "00001101"; -- 13
    Y_46   <= X * "00101110"; -- 46
    Y_99   <= X * "01100011"; -- 99
    Y_104  <= X * "01101000"; -- 104
    Y_111  <= X * "01101111"; -- 111
    Y_114  <= X * "01110010"; -- 114
    Y_119  <= X * "01110111"; -- 119
    Y_124  <= X * "01111100"; -- 124
    -- Y_125   <= X * "01111101"; -- 125

    s_mult <= (Y_n112 & Y_n108 & Y_n107 & Y_n76 & Y_n75 & Y_n60 & Y_n48 & Y_n33 & Y_n29 & Y_n23 & Y_3 & Y_13 & Y_46 & Y_99 & Y_104 & Y_111 & Y_114 & Y_119 & Y_124);
    bias   <= to_unsigned(100, bias'length);

    A      <= unsigned(s_mult(((2 * BITS) * (0 + 1)) - 1 DOWNTO ((2 * BITS) * (0))));
    B      <= unsigned(s_mult(((2 * BITS) * (1 + 1)) - 1 DOWNTO ((2 * BITS) * (1))));
    carry_select_adder_inst_0 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => A, b => B, res => n0_r0);

    C <= unsigned(s_mult(((2 * BITS) * (2 + 1)) - 1 DOWNTO ((2 * BITS) * (2))));
    D <= unsigned(s_mult(((2 * BITS) * (3 + 1)) - 1 DOWNTO ((2 * BITS) * (3))));
    carry_select_adder_inst_1 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => C, b => D, res => n0_r1);

    E <= unsigned(s_mult(((2 * BITS) * (4 + 1)) - 1 DOWNTO ((2 * BITS) * (4))));
    F <= unsigned(s_mult(((2 * BITS) * (5 + 1)) - 1 DOWNTO ((2 * BITS) * (5))));
    carry_select_adder_inst_2 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => E, b => F, res => n0_r2);

    G <= unsigned(s_mult(((2 * BITS) * (6 + 1)) - 1 DOWNTO ((2 * BITS) * (6))));
    H <= unsigned(s_mult(((2 * BITS) * (7 + 1)) - 1 DOWNTO ((2 * BITS) * (7))));
    carry_select_adder_inst_3 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => G, b => H, res => n0_r3);

    I <= unsigned(s_mult(((2 * BITS) * (8 + 1)) - 1 DOWNTO ((2 * BITS) * (8))));
    J <= unsigned(s_mult(((2 * BITS) * (9 + 1)) - 1 DOWNTO ((2 * BITS) * (9))));
    carry_select_adder_inst_4 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => I, b => J, res => n0_r4);

    K <= unsigned(s_mult(((2 * BITS) * (10 + 1)) - 1 DOWNTO ((2 * BITS) * (10))));
    L <= unsigned(s_mult(((2 * BITS) * (11 + 1)) - 1 DOWNTO ((2 * BITS) * (11))));
    carry_select_adder_inst_5 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => K, b => L, res => n0_r5);

    M <= unsigned(s_mult(((2 * BITS) * (12 + 1)) - 1 DOWNTO ((2 * BITS) * (12))));
    N <= unsigned(s_mult(((2 * BITS) * (13 + 1)) - 1 DOWNTO ((2 * BITS) * (13))));
    carry_select_adder_inst_6 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => M, b => N, res => n0_r6);

    O <= unsigned(s_mult(((2 * BITS) * (14 + 1)) - 1 DOWNTO ((2 * BITS) * (14))));
    P <= unsigned(s_mult(((2 * BITS) * (15 + 1)) - 1 DOWNTO ((2 * BITS) * (15))));
    carry_select_adder_inst_7 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => O, b => P, res => n0_r7);

    Q <= unsigned(s_mult(((2 * BITS) * (16 + 1)) - 1 DOWNTO ((2 * BITS) * (16))));
    R <= unsigned(s_mult(((2 * BITS) * (17 + 1)) - 1 DOWNTO ((2 * BITS) * (17))));
    carry_select_adder_inst_8 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => Q, b => R, res => n0_r8);

    S      <= unsigned(s_mult(((2 * BITS) * (18 + 1)) - 1 DOWNTO ((2 * BITS) * (18))));
    -- bias;
    s_bias <= "00000000" & bias;
    carry_select_adder_inst_9  : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => S, b => s_bias, res => n0_r9);
    -- ----------------------------------------------------------------------------------------------------
    -- n0_r0, n0_r1, n0_r2, n0_r3, n0_r4, n0_r5, n0_r6, n0_r7, n0_r8, n0_r9
    carry_select_adder_inst_10 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n0_r0, b => n0_r1, res => n1_r0);
    carry_select_adder_inst_11 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n0_r2, b => n0_r3, res => n1_r1);
    carry_select_adder_inst_12 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n0_r4, b => n0_r5, res => n1_r2);
    carry_select_adder_inst_13 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n0_r6, b => n0_r7, res => n1_r3);
    carry_select_adder_inst_14 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n0_r8, b => n0_r9, res => n1_r4);

    -- ----------------------------------------------------------------------------------------------------
    -- n1_r0, n1_r1, n1_r2, n1_r3, n1_r4
    carry_select_adder_inst_15 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n1_r0, b => n1_r1, res => n2_r0);
    carry_select_adder_inst_16 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n1_r2, b => n1_r3, res => n2_r1);
    -------------------------------------------------------------------------------------------
    -- n2_r0, n2_r1
    carry_select_adder_inst_17 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n1_r4, b => n2_r0, res => n3_r0);
    -------------------------------------------------------------------------------------------
    -- n3_r0
    carry_select_adder_inst_18 : carry_select_adder GENERIC MAP(bits => 2 * bits) PORT MAP(a => n2_r1, b => n3_r0, res => n4_r0);
    y <= unsigned(n4_r0);
END arch;