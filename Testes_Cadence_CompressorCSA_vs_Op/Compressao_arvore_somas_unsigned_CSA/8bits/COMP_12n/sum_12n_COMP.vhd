LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
-- USE work.parameters.ALL;

ENTITY sum_12n_COMP IS
  GENERIC (
    BITS       : NATURAL := 16;
    NUM_INPUTS : NATURAL := 11
  );
  PORT (
    s_mult : IN unsigned((BITS * (NUM_INPUTS)) - 1 DOWNTO 0);
    bias   : IN unsigned(BITS - 1 DOWNTO 0); -- s_Win(0 + (BITS * (NUM_INPUTS)))
    ----------------------------------------------
    y      : OUT unsigned((BITS + 4) - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF sum_12n_COMP IS

  -------------------- SIGNALS ---------------------
  SIGNAL v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10 : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL S0, S1, S2, S3, S4, S5, S6                  : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL C0, C1, C2, C3, C4, C5, C6, C7              : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL D0, D1                                      : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL F0, F1                                      : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL S7                                          : unsigned(BITS DOWNTO 0);
  SIGNAL carry                                       : STD_LOGIC_VECTOR (BITS - 2 DOWNTO 0);

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
      cin  => bias(i),
      s    => S3(i),
      cout => C3(i)
    );
  END GENERATE;
  --------------------------------- LEVEL 1 ---------------------------------
  -- COMPRESSOR 0 
  level1_CSA0_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S0(i),
      b    => S1(i),
      cin  => S2(i),
      s    => S4(i),
      cout => C4(i)
    );
  END GENERATE;

  -- COMPRESSOR 1  
  level1_CSA1_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => C0(i),
      b    => C1(i),
      cin  => C2(i), --bias s_Win(i + (BITS * (NUM_INPUTS)))
      s    => S5(i),
      cout => C5(i)
    );
  END GENERATE;
  --------------------------------- LEVEL 2 ---------------------------------
  -- COMPRESSOR 0   
  level2_CSA0_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S4(i),
      b    => S5(i),
      cin  => S3(i),
      s    => S6(i),
      cout => C6(i)
    );
  END GENERATE;

  -- COMPRESSOR 1   
  level2_CSA1_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => C4(i),
      b    => C5(i),
      cin  => C3(i),
      s    => C7(i),
      cout => D0(i)
    );
  END GENERATE;
  --------------------------------- LEVEL 3 ---------------------------------
  y(0) <= S6(0);

  -- COMPRESSOR 0 
  level3_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S6(i + 1),
      b    => C6(i),
      cin  => C7(i),
      s    => S7(i),
      cout => D1(i)
    );
  END GENERATE;

  level3_CSA_inst : half_adder
  PORT MAP(
    a    => C4(BITS - 2),
    b    => C7(BITS - 1),
    -- cin  => C5(BITS - 1),
    s    => S7(BITS - 1),
    cout => D1(BITS - 1)
  );
  y(1) <= S7(0);
  --------------------------------- LEVEL 4 ---------------------------------
  -- COMPRESSOR 0 
  level4_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S7(i + 1),
      b    => D1(i),
      cin  => D0(i),
      s    => F0(i),
      cout => F1(i)
    );
  END GENERATE;

  level4_half_adder_inst : half_adder
  PORT MAP(
    a    => D0(BITS - 1),
    b    => D1(BITS - 1),
    s    => F0(BITS - 1),
    cout => F1(BITS - 1)
  );
  y(2) <= F0(0);

  --------------------------------- LEVEL 5 ---------------------------------
  ------- PRIMEIRO ADDER ------- adder 0
  level5_half_adder_inst : half_adder
  PORT MAP(
    a    => F0(1),
    b    => F1(0),
    s    => y(3),
    cout => carry(0)
  );
  -------  SEGUNDO ADDER ATE O PENULTIMO ------- adders 1 a 7
  loop_port_map : FOR i IN 1 TO (BITS - 2) GENERATE
    full_adder_inst_loop : full_adder
    PORT MAP(
      a    => F0(i),
      b    => F1(i - 1),
      cin  => carry(i - 1),
      s    => y(i + 3),
      cout => carry(i)
    );
  END GENERATE;
  -- y(BITS + 4) <= carry(BITS - 2);

  ------- ULTIMO ADDER ------- adder 8
  level5_2_half_adder_inst : half_adder
  PORT MAP(
    a    => carry(BITS - 2),
    b    => D1(BITS - 1),
    s    => y(BITS + 2),
    cout => y(BITS + 3)
  );

END arch;