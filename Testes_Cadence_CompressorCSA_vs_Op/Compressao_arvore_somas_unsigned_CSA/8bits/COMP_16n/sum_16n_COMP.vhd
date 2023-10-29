LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
-- USE work.parameters.ALL;

ENTITY sum_16n_COMP IS
  GENERIC (
    BITS       : NATURAL := 16;
    NUM_INPUTS : NATURAL := 15
  );
  PORT (
    s_mult : IN unsigned((BITS * (NUM_INPUTS)) - 1 DOWNTO 0);
    bias   : IN unsigned(BITS - 1 DOWNTO 0); -- s_Win(0 + (BITS * (NUM_INPUTS)))
    ----------------------------------------------
    y      : OUT unsigned((BITS + 4) - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF sum_16n_COMP IS

  -------------------- SIGNALS ---------------------
  SIGNAL v0, v1, v2, v3, v4, v5         : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL v6, v7, v8, v9, v10, v11       : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL v12, v13, v14, v15             : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL S0, S1, S2, S3, S4, S5, S6, S7 : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL C0, C1, C2, C3, C4, C5, C6     : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL C7, C8, C9, C10                : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL D0, D1, D2, D3                 : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL E0                             : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL C11, D4                        : unsigned(BITS DOWNTO 0);
  SIGNAL F0, F1                         : unsigned(BITS DOWNTO 0);
  -- SIGNAL D1                                          : unsigned(BITS DOWNTO 0);

  SIGNAL carry                          : STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);

  -------------------- COMPONENTS ---------------------
  COMPONENT half_adder IS
    PORT (
      a, b    : IN STD_LOGIC;
      s, cout : OUT STD_LOGIC
    );
  END COMPONENT;
  
  COMPONENT half_adder_NO_COUT IS
    PORT (
      a, b    : IN STD_LOGIC;
      s : OUT STD_LOGIC
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
  -- v15 <= s_mult((BITS * 16) - 1 DOWNTO (BITS * 15));
  -- v16 <= s_mult((BITS * 17) - 1 DOWNTO (BITS * 16));
  -- v17 <= s_mult((BITS * 18) - 1 DOWNTO (BITS * 17));
  -- v18 <= s_mult((BITS * 19) - 1 DOWNTO (BITS * 18));
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
      cin  => bias(i),
      s    => S4(i),
      cout => C4(i)
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
      s    => C5(i),
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
      s    => S5(i),
      cout => C6(i)
    );
  END GENERATE;

  -- COMPRESSOR 2 
  level1_CSA2_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => v14(i),
      b    => S3(i),
      cin  => S4(i),
      s    => S6(i),
      cout => C7(i)
    );
  END GENERATE;
  --------------------------------- LEVEL 2 ---------------------------------
  -- COMPRESSOR 0   
  level2_CSA0_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => C4(i),
      b    => C5(i),
      cin  => C6(i),
      s    => C8(i),
      cout => D1(i)
    );
  END GENERATE;

  -- COMPRESSOR 1   
  level2_HA_inst : half_adder
  PORT MAP(
    a    => S5(0),
    b    => S6(0),
    s    => S7(0),
    cout => C9(0)
  );

  level2_CSA1_port_map : FOR i IN 1 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S5(i),
      b    => S6(i),
      cin  => C3(i - 1),
      s    => S7(i),
      cout => C9(i)
    );
  END GENERATE;
  y(0) <= S7(0);
  --------------------------------- LEVEL 3 ---------------------------------
  -- y(0) <= S4(0);

  -- COMPRESSOR 0 
  level3_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => C8(i + 1),
      b    => D0(i),
      cin  => D1(i),
      s    => D2(i),
      cout => E0(i)
    );
  END GENERATE;

  level3_HA0_inst : half_adder
  PORT MAP(
    a    => D0(BITS - 1),
    b    => D1(BITS - 1),
    s    => D2(BITS - 1),
    cout => E0(BITS - 1)
  );
  -- y(1) <= S5(0);

  -- COMPRESSOR 1
  level3_CSA1_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S7(i + 1),
      b    => C7(i),
      cin  => C9(i),
      s    => C10(i),
      cout => D3(i)
    );
  END GENERATE;

  level3_FA0_inst : full_adder
  PORT MAP(
    a    => C3(BITS - 1),
    b    => C7(BITS - 1),
    cin  => C9(BITS - 1),
    s    => C10(BITS - 1),
    cout => D3(BITS - 1)
  );
  --------------------------------- LEVEL 4 ---------------------------------
  -- COMPRESSOR 0 
  level4_HA0_inst : half_adder
  PORT MAP(
    a    => C8(0),
    b    => C10(0),
    s    => C11(0),
    cout => D4(0)
  );

  level4_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => C10(i + 1),
      b    => D2(i),
      cin  => D3(i),
      s    => C11(i + 1),
      cout => D4(i + 1)
    );
  END GENERATE;

  level4_FA_inst : full_adder
  PORT MAP(
    a    => D2(BITS - 1),
    b    => D3(BITS - 1),
    cin  => E0(BITS - 2),
    s    => C11(BITS),
    cout => D4(BITS)
  );
  y(1) <= C11(0);

  --------------------------------- LEVEL 5 ---------------------------------
  -- COMPRESSOR 0 
  level5_HA0_inst : half_adder
  PORT MAP(
    a    => C11(1),
    b    => D4(0),
    s    => F0(0),
    cout => F1(0)
  );
  y(2) <= F0(0);

  level5_CSA0_port_map : FOR i IN 0 TO (BITS - 3) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => C11(i + 2),
      b    => D4(i + 1),
      cin  => E0(i),
      s    => F0(i + 1),
      cout => F1(i + 1)
    );
  END GENERATE;

  level5_HA1_inst : half_adder
  PORT MAP(
    a    => C11(BITS),
    b    => D4(BITS - 1),
    s    => F0(BITS - 1),
    cout => F1(BITS - 1)
  );

  level5_HA2_inst : half_adder
  PORT MAP(
    a    => E0(BITS - 1),
    b    => D4(BITS),
    s    => F0(BITS),
    cout => F1(BITS)
  );
  --------------------------------- LEVEL 6 ---------------------------------
  ------- PRIMEIRO ADDER ------- adder 0
  level5_half_adder_inst : half_adder
  PORT MAP(
    a    => F0(1),
    b    => F1(0),
    s    => y(3),
    cout => carry(0)
  );
  -------  SEGUNDO ADDER ATE O PENULTIMO ------- adders 1 a 7
  loop_port_map : FOR i IN 1 TO (BITS - 1) GENERATE
    full_adder_inst_loop : full_adder
    PORT MAP(
      a    => F0(i),
      b    => F1(i - 1),
      cin  => carry(i - 1),
      s    => y(i + 3),
      cout => carry(i)
    );
  END GENERATE;

  ------- ULTIMO ADDER ------- adder 8
  level5_2_half_adder_inst : half_adder_NO_COUT
  PORT MAP(
    a    => carry(BITS - 1),
    b    => F1(BITS - 1),
    s    => y(BITS + 3)
--    cout => y(BITS + 4)
  );

  -- y <= to_signed(to_integer(sum_all), y'length); -- Numeric_std 

END arch;