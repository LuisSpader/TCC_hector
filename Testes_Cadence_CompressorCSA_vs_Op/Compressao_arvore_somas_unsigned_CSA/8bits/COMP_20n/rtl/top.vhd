LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
-- USE work.parameters.ALL;

ENTITY top IS
    GENERIC (
        BITS       : NATURAL := 16;
        NUM_INPUTS : NATURAL := 19
    );
    PORT (
        s_mult : IN unsigned((BITS * (NUM_INPUTS)) - 1 DOWNTO 0);
        bias   : IN unsigned(BITS - 1 DOWNTO 0); -- s_Win(0 + (BITS * (NUM_INPUTS)))
        ----------------------------------------------
        y      : OUT unsigned((BITS + 5) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF top IS

    -------------------- SIGNALS ---------------------
    SIGNAL v0, v1, v2, v3, v4, v5, v6, v7     : unsigned(BITS - 1 DOWNTO 0);
    SIGNAL v8, v9, v10, v11, v12, v13         : unsigned(BITS - 1 DOWNTO 0);
    SIGNAL v14, v15, v16, v17, v18            : unsigned(BITS - 1 DOWNTO 0);
    SIGNAL S0, S1, S2, S3, S4, S5, S6, S7, S8 : unsigned(BITS - 1 DOWNTO 0);
    SIGNAL C0, C1, C2, C3, C4, C5, C6         : unsigned(BITS - 1 DOWNTO 0);
    SIGNAL C7, C8, C9, C10, C11, C12          : unsigned(BITS - 1 DOWNTO 0);
    SIGNAL D0, D1, D2, D3, D4                 : unsigned(BITS - 1 DOWNTO 0);
    SIGNAL E0                                 : unsigned(BITS - 1 DOWNTO 0);
    SIGNAL E2, F1, F2                         : unsigned(BITS DOWNTO 0);
    SIGNAL A, B                               : unsigned(BITS DOWNTO 0);
    SIGNAL S9, C13, C14, D5, D6               : unsigned(BITS DOWNTO 0);

    SIGNAL carry                              : STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);

    -------------------- COMPONENTS ---------------------
    COMPONENT half_adder IS
        PORT (
            a, b    : IN STD_LOGIC;
            s, cout : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT full_adder IS
        PORT (
            a, b, cin : IN STD_LOGIC;
            s, cout   : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT adder_generic_HFH_No_Cout IS
        GENERIC (BITS : NATURAL := 9);
        PORT (
            S, C : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            F    : OUT STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT CSA IS
        PORT (
            a, b : IN UNSIGNED(17 - 1 DOWNTO 0);
            res  : OUT UNSIGNED(17 - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    v0  <= s_mult((BITS * 1) - 1 DOWNTO (BITS * 0));
    v1  <= s_mult((BITS * 2) - 1 DOWNTO (BITS * 1));
    v2  <= s_mult((BITS * 3) - 1 DOWNTO (BITS * 2));
    v3  <= s_mult((BITS * 4) - 1 DOWNTO (BITS * 3));
    v4  <= s_mult((BITS * 5) - 1 DOWNTO (BITS * 4));
    v5  <= s_mult((BITS * 6) - 1 DOWNTO (BITS * 5));
    v6  <= s_mult((BITS * 7) - 1 DOWNTO (BITS * 6));
    v7  <= s_mult((BITS * 8) - 1 DOWNTO (BITS * 7));
    v8  <= s_mult((BITS * 9) - 1 DOWNTO (BITS * 8));
    v9  <= s_mult((BITS * 10) - 1 DOWNTO (BITS * 9));
    v10 <= s_mult((BITS * 11) - 1 DOWNTO (BITS * 10));
    v11 <= s_mult((BITS * 12) - 1 DOWNTO (BITS * 11));
    v12 <= s_mult((BITS * 13) - 1 DOWNTO (BITS * 12));
    v13 <= s_mult((BITS * 14) - 1 DOWNTO (BITS * 13));
    v14 <= s_mult((BITS * 15) - 1 DOWNTO (BITS * 14));
    v15 <= s_mult((BITS * 16) - 1 DOWNTO (BITS * 15));
    v16 <= s_mult((BITS * 17) - 1 DOWNTO (BITS * 16));
    v17 <= s_mult((BITS * 18) - 1 DOWNTO (BITS * 17));
    v18 <= s_mult((BITS * 19) - 1 DOWNTO (BITS * 18));

    --------------------------------- LEVEL 0 ---------------------------------
    -- COMPRESSOR 0  
    level0_CSA0_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => v0(i),
            b    => v1(i),
            cin  => v2(i),
            s    => S0(i),
            cout => C0(i)
        );
    END GENERATE;

    -- COMPRESSOR 1  
    level0_CSA1_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => v3(i),
            b    => v4(i),
            cin  => v5(i),
            s    => S1(i),
            cout => C1(i)
        );
    END GENERATE;

    -- COMPRESSOR 2
    level0_CSA2_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => v6(i),
            b    => v7(i),
            cin  => v8(i),
            s    => S2(i),
            cout => C2(i)
        );
    END GENERATE;

    -- COMPRESSOR 3  
    level0_CSA3_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => v9(i),
            b    => v10(i),
            cin  => v11(i),
            s    => S3(i),
            cout => C3(i)
        );
    END GENERATE;

    -- COMPRESSOR 4  
    level0_CSA4_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => v12(i),
            b    => v13(i),
            cin  => v14(i),
            s    => S4(i),
            cout => C4(i)
        );
    END GENERATE;

    -- COMPRESSOR 5  
    level0_CSA5_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => v15(i),
            b    => v16(i),
            cin  => v17(i),
            s    => S5(i),
            cout => C5(i)
        );
    END GENERATE;

    --------------------------------- LEVEL 1 ---------------------------------
    -- COMPRESSOR 0 
    level1_CSA0_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => C0(i),
            b    => C1(i),
            cin  => C2(i), --bias s_Win(i + (BITS * (NUM_INPUTS)))
            s    => C6(i),
            cout => D0(i)
        );
    END GENERATE;
    -- COMPRESSOR 1  
    level1_CSA1_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => S0(i),
            b    => S1(i),
            cin  => S2(i),
            s    => S6(i),
            cout => C7(i)
        );
    END GENERATE;
    -- COMPRESSOR 2 
    level1_CSA2_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => v18(i),
            b    => bias(i),
            cin  => S3(i),
            s    => S7(i),
            cout => C8(i)
        );
    END GENERATE;
    -- COMPRESSOR 3 
    level1_CSA3_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => C3(i),
            b    => C4(i),
            cin  => C5(i),
            s    => C9(i),
            cout => D1(i)
        );
    END GENERATE;
    --------------------------------- LEVEL 2 ---------------------------------
    -- COMPRESSOR 0   
    level2_HA0_inst : half_adder
    PORT MAP(
        a    => C8(0),
        b    => C9(0),
        s    => C10(0),
        cout => D2(0)
    );
    level2_CSA0_port_map : FOR i IN 1 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => C8(i),
            b    => C9(i),
            cin  => D0(i - 1),
            s    => C10(i),
            cout => D2(i)
        );
    END GENERATE;

    -- COMPRESSOR 1   
    level2_CSA1_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => S7(i + 1),
            b    => C6(i),
            cin  => C7(i),
            s    => C11(i),
            cout => D3(i)
        );
    END GENERATE;
    level2_HA1_inst : half_adder
    PORT MAP(
        a    => C6(BITS - 2),
        b    => C7(BITS - 1),
        s    => C11(BITS - 1),
        cout => D3(BITS - 1)
    );

    -- COMPRESSOR 2   
    level2_CSA2_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => S4(i),
            b    => S5(i),
            cin  => S6(i),
            s    => S8(i),
            cout => C12(i)
        );
    END GENERATE;
    --------------------------------- LEVEL 3 ---------------------------------
    -- COMPRESSOR 0 
    level3_CSA0_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => D1(i),
            b    => D2(i),
            cin  => D3(i),
            s    => D4(i),
            cout => E0(i)
        );
    END GENERATE;

    -- COMPRESSOR 1
    level3_HA0_inst : half_adder
    PORT MAP(
        a    => S7(0),
        b    => S8(0),
        s    => S9(0),
        cout => C13(0)
    );
    level3_CSA1_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => S8(i + 1),
            b    => C10(i),
            cin  => C11(i),
            s    => S9(i + 1),
            cout => C13(i + 1)
        );
    END GENERATE;
    level3_HA1_inst : full_adder
    PORT MAP(
        a    => C12(BITS - 1),
        b    => C10(BITS - 1),
        cin  => C11(BITS - 1),
        s    => S9(BITS),
        cout => C13(BITS)
    );
    y(0) <= S9(0);
    --------------------------------- LEVEL 4 ---------------------------------
    -- COMPRESSOR 0 
    level4_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => S9(i + 1),
            b    => C12(i),
            cin  => C13(i),
            s    => C14(i),
            cout => D5(i)
        );
    END GENERATE;
    level4_FA0_inst : full_adder
    PORT MAP(
        a    => S9(BITS - 1),
        b    => D4(BITS - 2),
        cin  => C13(BITS - 1),
        s    => C14(BITS - 1),
        cout => D5(BITS - 1)
    );
    level4_FA1_inst : full_adder
    PORT MAP(
        a    => D0(BITS - 1),
        b    => D4(BITS - 1),
        cin  => C13(BITS),
        s    => C14(BITS),
        cout => D5(BITS)
    );
    y(1) <= C14(0);
    --------------------------------- LEVEL 5 ---------------------------------
    -- COMPRESSOR 0 
    level5_HA0_inst : full_adder
    PORT MAP(
        a    => C14(1),
        b    => D5(0),
        cin  => D4(0),
        s    => D6(0),
        cout => E2(0)
    );

    level5_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => C14(i + 2),
            b    => D5(i + 1),
            cin  => E0(i),
            s    => D6(i + 1),
            cout => E2(i + 1)
        );
    END GENERATE;

    level5_HA1_inst : half_adder
    PORT MAP(
        a    => D5(BITS),
        b    => E0(BITS - 1),
        -- cin  => E0(i),
        s    => D6(BITS),
        cout => E2(BITS)
    );
    y(2) <= D6(0);
    --------------------------------- LEVEL 6 ---------------------------------
    level6_CSA0_1_port_map : FOR i IN 0 TO (BITS/2) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => D6(i + 1),
            b    => E2(i),
            cin  => D4(i + 1),
            s    => F1(i),
            cout => F2(i)
        );
    END GENERATE;
    y(3) <= F1(0);

    level6_CSA0_2_port_map : FOR i IN (BITS/2) + 1 TO BITS - 1 GENERATE
        CSA_inst_loop : half_adder
        PORT MAP(
            a    => D6(i + 1),
            b    => E2(i),
            s    => F1(i),
            cout => F2(i)
        );
    END GENERATE;
    --------------------------------- LEVEL 7 ---------------------------------
    ------- PRIMEIRO ADDER ------- adder 0
    A <= '0' & E2(BITS - 1) & F1(bits - 1 DOWNTO 1); -- 17 bits
    B <= '0' & F2(bits - 1 DOWNTO 0);                -- 17 bits

    level7_adder_CSA_inst : CSA PORT MAP(
        a   => A,
        b   => B,
        res => y((BITS + 5) - 1 DOWNTO 4)
    );
    -- 
    -- level7_half_adder_inst : half_adder
    -- PORT MAP(
    --     a    => F1(1),
    --     b    => F2(0),
    --     s    => y(4),
    --     cout => carry(0)
    -- );
    -- -------  SEGUNDO ADDER ATE O PENULTIMO ------- adders 1 a 7
    -- level7_loop_port_map : FOR i IN 1 TO (BITS - 2) GENERATE
    --     full_adder_inst_loop : full_adder
    --     PORT MAP(
    --         a    => F1(i + 1),
    --         b    => F2(i),
    --         cin  => carry(i - 1),
    --         s    => y(i + 4),
    --         cout => carry(i)
    --     );
    -- END GENERATE;
    -- level7_FA_inst : full_adder
    -- PORT MAP(
    --     a    => E2(BITS - 1),
    --     b    => F2(BITS - 1),
    --     cin  => carry(BITS - 1 - 1),
    --     s    => y((BITS + 4) - 1),
    --     cout => carry(BITS - 1)
    -- );

    -- y((BITS + 5) - 1) <= carry(BITS - 1);
    -- -- y <= to_signed(to_integer(sum_all), y'length); -- Numeric_std 

END arch;