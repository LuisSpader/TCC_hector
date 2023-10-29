-- Somador GENERIC  --
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
-- USE ieee.numeric_std.ALL;
-- USE work.config_package.ALL;
USE WORK.ALL;

ENTITY adder_generic_signed IS
  GENERIC (BITS : NATURAL := BITS);
  PORT (
    val1, val2 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
    F          : OUT STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0)
  );
END adder_generic_signed;

ARCHITECTURE arch OF adder_generic_signed IS
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

  COMPONENT full_adder_NO_COUT IS
    PORT (
      a, b, cin : IN STD_LOGIC;
      s         : OUT STD_LOGIC
    );
  END COMPONENT;

  -------------------- SIGNALS ---------------------

  SIGNAL carry : STD_LOGIC_VECTOR (BITS - 2 DOWNTO 0);

  -------------------- BEGIN LOGIC ---------------------
BEGIN

  ------- PRIMEIRO ADDER ------- adder 0
  half_adder_inst : half_adder
  PORT MAP(
    a    => val1(0),
    b    => val2(0),
    s    => F(0),
    cout => carry(0)
  );
  ----------------------------------------------

  -------  SEGUNDO ADDER ATE O PENULTIMO ------- adders 1 a 6
  loop_port_map : FOR i IN 1 TO ((BITS - 1) - 1) GENERATE
    full_adder_inst_loop : full_adder
    PORT MAP(
      a    => val1(i),
      b    => val2(i),
      cin  => carry(i - 1),
      s    => F(i),
      cout => carry(i)
    );
  END GENERATE;

  ------- ULTIMO ADDER (sem Cout pois o somador eh com sinal -> Cout n faz sentido neste caso) ------- adder 7

  half_adder_end_inst : ENTITY work.half_adder
    PORT MAP(
      a    => val1(BITS - 1),
      b    => val2(BITS - 1),
      s    => carry(BITS - 2),
      cout => F(BITS - 1)
    );

  -- full_adder_NO_COUT_inst : ENTITY work.full_adder_NO_COUT
  --   PORT MAP(
  --     a   => val1(BITS - 1),
  --     b   => val2(BITS - 1),
  --     cin => carry(BITS - 2),
  --     s   => F(BITS - 1)
  --   );
END arch;