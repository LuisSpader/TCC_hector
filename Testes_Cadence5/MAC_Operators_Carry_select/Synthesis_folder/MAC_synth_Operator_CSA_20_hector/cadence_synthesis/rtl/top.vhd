LIBRARY ieee;
USE ieee.std_logic_1(2 * BITS)4.ALL;
USE ieee.numeric_std.ALL;
--USE ieee.math_real.ALL;
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;
ENTITY top IS
    GENERIC (
        BITS       : NATURAL := 8;
        NUM_INPUTS : NATURAL := 20
    );
    PORT (
        X : IN signed(((1 * BITS) - 1) DOWNTO 0);
        -- y : OUT signed(((2*BITS) + 4) - 1 DOWNTO 0)
        y : OUT signed((((2 * BITS) + 4) - 1) DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF top IS
    -------------------- COMPONENTS ---------------------
    COMPONENT carry_select_adder IS
        GENERIC (
            bits : POSITIVE := BITS
        );
        PORT (
            a, b : IN UNSIGNED((bits - 1) DOWNTO 0);
            res  : OUT UNSIGNED((bits - 1) DOWNTO 0)
        );
    END COMPONENT;
    -------------------- SIGNALS ---------------------
    SIGNAL s_mult                                                          : signed(((2 * BITS) * (NUM_INPUTS - 1)) - 1 DOWNTO 0);
    SIGNAL sum_all                                                         : signed(((2 * BITS) + 4) - 1 DOWNTO 0);
    SIGNAL bias                                                            : signed(BITS - 1 DOWNTO 0);
    SIGNAL Y_n112, Y_n108, Y_n107, Y_n76, Y_n75, Y_n60                     : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL Y_n48, Y_n33, Y_n29, Y_n23, Y_3, Y_13, Y_46                     : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL Y_99, Y_104, Y_111, Y_114, Y_119, Y_124                         : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    -- SIGNAL Y_125                                             : signed((1 * 2 * BITS) - 1 DOWNTO 0);
    SIGNAL A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, s_bias : unsigned((2 * BITS) DOWNTO 0);

    SIGNAL n0_r0, n0_r1, n0_r2, n0_r3, n0_r4, n0_r5                        : unsigned((2 * BITS) DOWNTO 0);
    SIGNAL n0_r6, n0_r7, n0_r8, n0_r9                                      : unsigned((2 * BITS) DOWNTO 0);
    SIGNAL s_n0_r0, s_n0_r1, s_n0_r2, s_n0_r3, s_n0_r4                     : unsigned((2 * BITS) + 1 DOWNTO 0);
    SIGNAL s_n0_r5, s_n0_r6, s_n0_r7, s_n0_r8, s_n0_r9                     : unsigned((2 * BITS) + 1 DOWNTO 0);

    SIGNAL n1_r0, n1_r1, n1_r2, n1_r3, n1_r4                               : unsigned((2 * BITS) + 2 DOWNTO 0);
    SIGNAL s_n1_r0, s_n1_r1, s_n1_r2, s_n1_r3, s_n1_r4                     : unsigned((2 * BITS) + 3 DOWNTO 0);

    SIGNAL n2_r0, n2_r1                                                    : unsigned((2 * BITS) + 3 DOWNTO 0);
    SIGNAL s_n2_r0, s_n2_r1                                                : unsigned((2 * BITS) + 4 DOWNTO 0);

    SIGNAL n3_r0, n4_r0                                                    : unsigned((2 * BITS) + 4 DOWNTO 0);

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
    bias   <= to_signed(100, bias'length);

    A      <= '0' & unsigned(s_mult(15 DOWNTO ((2 * BITS) * (0))));
    B      <= '0' & unsigned(s_mult(31 DOWNTO ((2 * BITS) * (1))));
    carry_select_adder_inst_0 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => A, b => B, res => n0_r0);

    C <= '0' & unsigned(s_mult(47 DOWNTO ((2 * BITS) * (2))));
    D <= '0' & unsigned(s_mult(63 DOWNTO ((2 * BITS) * (3))));
    carry_select_adder_inst_1 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => C, b => D, res => n0_r1);

    E <= '0' & unsigned(s_mult(79 DOWNTO ((2 * BITS) * (4))));
    F <= '0' & unsigned(s_mult(95 DOWNTO ((2 * BITS) * (5))));
    carry_select_adder_inst_2 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => E, b => F, res => n0_r2);

    G <= '0' & unsigned(s_mult(111 DOWNTO ((2 * BITS) * (6))));
    H <= '0' & unsigned(s_mult(127 DOWNTO ((2 * BITS) * (7))));
    carry_select_adder_inst_3 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => G, b => H, res => n0_r3);

    I <= '0' & unsigned(s_mult(143 DOWNTO ((2 * BITS) * (8))));
    J <= '0' & unsigned(s_mult(159 DOWNTO ((2 * BITS) * (9))));
    carry_select_adder_inst_4 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => I, b => J, res => n0_r4);

    K <= '0' & unsigned(s_mult(175 DOWNTO ((2 * BITS) * (10))));
    L <= '0' & unsigned(s_mult(191 DOWNTO ((2 * BITS) * (11))));
    carry_select_adder_inst_5 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => K, b => L, res => n0_r5);

    M <= '0' & unsigned(s_mult(207 DOWNTO ((2 * BITS) * (12))));
    N <= '0' & unsigned(s_mult(223 DOWNTO ((2 * BITS) * (13))));
    carry_select_adder_inst_6 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => M, b => N, res => n0_r6);

    O <= '0' & unsigned(s_mult(239 DOWNTO ((2 * BITS) * (14))));
    P <= '0' & unsigned(s_mult(255 DOWNTO ((2 * BITS) * (15))));
    carry_select_adder_inst_7 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => O, b => P, res => n0_r7);

    Q <= '0' & unsigned(s_mult(272 DOWNTO ((2 * BITS) * (16))));
    R <= '0' & unsigned(s_mult(287 DOWNTO ((2 * BITS) * (17))));
    carry_select_adder_inst_8 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => Q, b => R, res => n0_r8);

    S      <= '0' & unsigned(s_mult(303 DOWNTO (2 * BITS) * (18)));
    -- bias;
    -- s_bias <= '0' & "00000000" & bias;
    s_bias <= ("000000000" & unsigned(bias));
    carry_select_adder_inst_9 : carry_select_adder GENERIC MAP(bits => (2 * bits + 1)) PORT MAP(a => S, b => s_bias, res => n0_r9);
    -- ----------------------------------------------------------------------------------------------------
    -- n0_r0, n0_r1, n0_r2, n0_r3, n0_r4, n0_r5, n0_r6, n0_r7, n0_r8, n0_r9
    s_n0_r0 <= '0' & n0_r0;
    s_n0_r1 <= '0' & n0_r1;
    s_n0_r2 <= '0' & n0_r2;
    s_n0_r3 <= '0' & n0_r3;
    s_n0_r4 <= '0' & n0_r4;
    s_n0_r5 <= '0' & n0_r5;
    s_n0_r6 <= '0' & n0_r6;
    s_n0_r7 <= '0' & n0_r7;
    s_n0_r8 <= '0' & n0_r8;
    s_n0_r9 <= '0' & n0_r9;

    carry_select_adder_inst_10 : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 2)) PORT MAP(a => s_n0_r0, b => s_n0_r1, res => n1_r0);
    carry_select_adder_inst_11 : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 2)) PORT MAP(a => s_n0_r2, b => s_n0_r3, res => n1_r1);
    carry_select_adder_inst_12 : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 2)) PORT MAP(a => s_n0_r4, b => s_n0_r5, res => n1_r2);
    carry_select_adder_inst_13 : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 2)) PORT MAP(a => s_n0_r6, b => s_n0_r7, res => n1_r3);
    carry_select_adder_inst_14 : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 2)) PORT MAP(a => s_n0_r8, b => s_n0_r9, res => n1_r4);

    -- ----------------------------------------------------------------------------------------------------
    -- n1_r0, n1_r1, n1_r2, n1_r3, n1_r4
    s_n1_r0 <= '0' & n1_r0;
    s_n1_r1 <= '0' & n1_r1;
    s_n1_r2 <= '0' & n1_r2;
    s_n1_r3 <= '0' & n1_r3;
    s_n1_r4 <= '0' & n1_r4;

    carry_select_adder_inst_15         : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 3)) PORT MAP(a => s_n1_r0, b => s_n1_r1, res => n2_r0);
    carry_select_adder_inst_(2 * BITS) : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 3)) PORT MAP(a => s_n1_r2, b => s_n1_r3, res => n2_r1);
    -------------------------------------------------------------------------------------------
    -- n2_r0, n2_r1
    s_n2_r0 <= '0' & n2_r0;
    s_n2_r1 <= '0' & n2_r1;

    carry_select_adder_inst_17 : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 4)) PORT MAP(a => s_n1_r4, b => s_n2_r0, res => n3_r0);
    -------------------------------------------------------------------------------------------
    -- n3_r0
    -- s_n3_r0 <= '0' & n3_r0;

    carry_select_adder_inst_18 : carry_select_adder GENERIC MAP(bits => ((2 * bits) + 4)) PORT MAP(a => s_n2_r1, b => n3_r0, res => n4_r0);

    y <= signed(n4_r0);
END arch;