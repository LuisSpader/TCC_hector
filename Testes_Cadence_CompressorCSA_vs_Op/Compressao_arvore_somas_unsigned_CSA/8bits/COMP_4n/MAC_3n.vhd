LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.parameters.ALL;

ENTITY MAC_3n IS
  GENERIC (
    BITS       : NATURAL := BITS;
    NUM_INPUTS : NATURAL := 3;
    TOTAL_BITS : NATURAL := 24
  );
  PORT (
    -- clk, rst : IN STD_LOGIC;
    Xi  : IN unsigned(TOTAL_BITS - 1 DOWNTO 0);
    Win : IN unsigned((BITS * (NUM_INPUTS + 1)) - 1 DOWNTO 0);
    ----------------------------------------------
    y   : OUT unsigned((2 * BITS) - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF MAC_3n IS

  ---------- SINAIS ----------
  SIGNAL sum_all : unsigned((2 * BITS) - 1 DOWNTO 0);
  SIGNAL s_Xi    : unsigned((BITS * NUM_INPUTS) - 1 DOWNTO 0);
  SIGNAL s_Win   : unsigned((BITS * (NUM_INPUTS + 1)) - 1 DOWNTO 0);
  SIGNAL s_mult  : unsigned(((2 * BITS) * (NUM_INPUTS)) - 1 DOWNTO 0);

  COMPONENT mult0_v0 IS
    GENERIC (
      BITS : NATURAL := BITS
    );
    PORT (
      X : IN unsigned((BITS) - 1 DOWNTO 0);
      W : IN unsigned((BITS) - 1 DOWNTO 0);
      Y : OUT unsigned((2 * BITS) - 1 DOWNTO 0)
    );
  END COMPONENT;

BEGIN
  s_Xi    <= Xi;
  s_Win   <= Win;
  sum_all <= (s_mult(((2 * BITS) * (0 + 1)) - 1 DOWNTO ((2 * BITS) * (0))) +
    s_mult(((2 * BITS) * (1 + 1)) - 1 DOWNTO ((2 * BITS) * (1))) +
    s_mult(((2 * BITS) * (2 + 1)) - 1 DOWNTO ((2 * BITS) * (2))) +
    s_Win((BITS * (3 + 1)) - 1 DOWNTO (BITS * (3))));

  loop_Mult_port_map : FOR i IN 0 TO (NUM_INPUTS - 1) GENERATE
    mult0_v0_inst_loop : mult0_v0
    PORT MAP(
      X => s_Xi((BITS * (i + 1)) - 1 DOWNTO (BITS * (i))),
      W => s_Win((BITS * (i + 1)) - 1 DOWNTO (BITS * (i))),
      Y => s_mult(((2 * BITS) * (i + 1)) - 1 DOWNTO ((2 * BITS) * (i)))
    );
  END GENERATE;

  y <= unsigned(sum_all);

  -- PROCESS (rst, clk)
  -- BEGIN
  --   IF (rst = '1') THEN
  --     y <= (OTHERS => '0');
  --   ELSE
  --     IF (clk'event AND clk = '1') THEN --se tem evento de clock
  --       y <= unsigned(sum_all);
  --     END IF;
  --   END IF;
  -- END PROCESS;

END arch;