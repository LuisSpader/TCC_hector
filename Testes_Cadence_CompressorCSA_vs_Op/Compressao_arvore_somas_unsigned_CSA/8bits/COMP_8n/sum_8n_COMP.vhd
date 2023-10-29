LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
-- USE work.parameters.ALL;

ENTITY sum_8n_COMP IS
  GENERIC (
    BITS       : NATURAL := 16;
    NUM_INPUTS : NATURAL := 7
  );
  PORT (
    s_mult : IN unsigned((BITS * (NUM_INPUTS)) - 1 DOWNTO 0);
    bias   : IN unsigned(BITS - 1 DOWNTO 0); -- s_Win(0 + (BITS * (NUM_INPUTS)))
    ----------------------------------------------
    y      : OUT unsigned((BITS + 3) - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF sum_8n_COMP IS

  -------------------- SIGNALS ---------------------
  SIGNAL v0, v1, v2, v3, v4, v5, v6 : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL S0, S1, S2                 : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL C0, C1, C2, C3             : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL D0                         : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL S3, C4, S4, D1             : unsigned(BITS DOWNTO 0);

  SIGNAL carry                      : STD_LOGIC_VECTOR (BITS - 2 DOWNTO 0);

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
  v0 <= s_mult((BITS * 1) - 1 DOWNTO (BITS * 0));
  v1 <= s_mult((BITS * 2) - 1 DOWNTO (BITS * 1));
  v2 <= s_mult((BITS * 3) - 1 DOWNTO (BITS * 2));
  v3 <= s_mult((BITS * 4) - 1 DOWNTO (BITS * 3));
  v4 <= s_mult((BITS * 5) - 1 DOWNTO (BITS * 4));
  v5 <= s_mult((BITS * 6) - 1 DOWNTO (BITS * 5));
  v6 <= s_mult((BITS * 7) - 1 DOWNTO (BITS * 6));

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
  --------------------------------- LEVEL 1 ---------------------------------
  -- COMPRESSOR 0 
  level1_CSA0_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S0(i),
      b    => S1(i),
      cin  => v6(i),
      s    => S2(i),
      cout => C2(i)
    );
  END GENERATE;

  -- COMPRESSOR 1  
  level1_CSA1_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => C0(i),
      b    => C1(i),
      cin  => bias(i + 1), --bias s_Win(i + (BITS * (NUM_INPUTS)))
      s    => C3(i),
      cout => D0(i)
    );
  END GENERATE;

  level1_half_adder_inst : half_adder
  PORT MAP(
    a    => C0(BITS - 1),
    b    => C1(BITS - 1),
    s    => C3(BITS - 1),
    cout => D0(BITS - 1)
  );
  --------------------------------- LEVEL 2 ---------------------------------
  -- -- COMPRESSOR 0
  -- level2_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
  --   CSA_inst_loop : full_adder
  --   PORT MAP(
  --     a    => C0(i),
  --     b    => C1(i),
  --     cin  => bias(i + 1), --bias s_Win(i + (BITS * (NUM_INPUTS)))
  --     s    => C3(i),
  --     cout => D0(i)
  --   );
  -- END GENERATE;

  -- level2_CSA_inst : half_adder
  -- PORT MAP(
  --   a    => C0(BITS - 1),
  --   b    => C1(BITS - 1),
  --   s    => C3(BITS - 1),
  --   cout => D0(BITS - 1)
  -- );

  --------------------------------- LEVEL 3 ---------------------------------
  -- COMPRESSOR 0 
  level3_half_adder_inst : half_adder
  PORT MAP(
    a    => S2(0),
    b    => bias(0),
    s    => S3(0),
    cout => C4(0)
  );

  level3_CSA0_port_map : FOR i IN 1 TO (BITS - 1) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S2(i),
      b    => C2(i - 1),
      cin  => C3(i - 1),
      s    => S3(i),
      cout => C4(i)
    );
  END GENERATE;

  level3_CSA_inst : half_adder
  PORT MAP(
    a    => C2(BITS - 1),
    b    => C3(BITS - 1),
    s    => S3(BITS),
    cout => C4(BITS)
  );

  --------------------------------- LEVEL 4 ---------------------------------
  y(0) <= S3(0);

  -- COMPRESSOR 0 
  level4_half_adder_inst : half_adder
  PORT MAP(
    a    => S3(1),
    b    => C4(0),
    s    => S4(0),
    cout => D1(0)
  );

  level4_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
    CSA_inst_loop : full_adder
    PORT MAP(
      a    => S3(i + 2),
      b    => C4(i + 1),
      cin  => D0(i),
      s    => S4(i + 1),
      cout => D1(i + 1)
    );
  END GENERATE;

  level4_CSA_inst : half_adder
  PORT MAP(
    a    => C4(BITS),
    b    => D0(BITS - 1),
    s    => S4(BITS),
    cout => D1(BITS)
  );
  --------------------------------- LEVEL 5 ---------------------------------
  y(1) <= S4(0);
  ------- PRIMEIRO ADDER ------- adder 0
  level5_half_adder_inst : half_adder
  PORT MAP(
    a    => S4(1),
    b    => D1(0),
    s    => y(2),
    cout => carry(0)
  );
  -------  SEGUNDO ADDER ATE O PENULTIMO ------- adders 1 a 7
  loop_port_map : FOR i IN 1 TO (BITS - 2) GENERATE
    full_adder_inst_loop : full_adder
    PORT MAP(
      a    => S4(i + 1),
      b    => D1(i),
      cin  => carry(i - 1),
      s    => y(i + 2),
      cout => carry(i)
    );
  END GENERATE;

  ------- ULTIMO ADDER ------- adder 8
  level5_2_half_adder_inst : half_adder
  PORT MAP(
    a    => carry(BITS - 2),
    b    => D1(BITS - 1),
    s    => y(BITS + 1),
    cout => y(BITS + 2)
  );

END arch;