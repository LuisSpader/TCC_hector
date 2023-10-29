LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
-- USE work.parameters.ALL;

ENTITY sum_4n_Operator IS
  GENERIC (
    BITS       : NATURAL := 16;
    NUM_INPUTS : NATURAL := 3
  );
  PORT (
    s_mult : IN unsigned((BITS * (NUM_INPUTS)) - 1 DOWNTO 0);
    bias   : IN unsigned(BITS - 1 DOWNTO 0); -- s_Win(0 + (BITS * (NUM_INPUTS)))
    ----------------------------------------------
    -- y      : OUT unsigned((BITS + 2) - 1 DOWNTO 0)
--    y      : OUT unsigned((2 * BITS) - 1 DOWNTO 0)
    y      : OUT unsigned(BITS - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF sum_4n_Operator IS

  -------------------- COMPONENTS ---------------------

  -------------------- SIGNALS ---------------------
  SIGNAL sum_all : unsigned(BITS - 1 DOWNTO 0);

BEGIN
  sum_all <= (s_mult((BITS * (0 + 1)) - 1 DOWNTO (BITS * (0))) +
    s_mult((BITS * (1 + 1)) - 1 DOWNTO (BITS * (1))) +
    s_mult((BITS * (2 + 1)) - 1 DOWNTO (BITS * (2))) +
    -- s_mult((BITS * (3 + 1)) - 1 DOWNTO (BITS * (3))) +
    -- s_mult((BITS * (4 + 1)) - 1 DOWNTO (BITS * (4))) +
    -- s_mult((BITS * (5 + 1)) - 1 DOWNTO (BITS * (5))) +
    -- s_mult((BITS * (6 + 1)) - 1 DOWNTO (BITS * (6))) +
    -- s_mult((BITS * (7 + 1)) - 1 DOWNTO (BITS * (7))) +
    -- s_mult((BITS * (8 + 1)) - 1 DOWNTO (BITS * (8))) +
    -- s_mult((BITS * (9 + 1)) - 1 DOWNTO (BITS * (9))) +
    -- s_mult((BITS * (10 + 1)) - 1 DOWNTO (BITS * (10))) +
    -- s_mult((BITS * (11 + 1)) - 1 DOWNTO (BITS * (11))) +
    -- s_mult((BITS * (12 + 1)) - 1 DOWNTO (BITS * (12))) +
    -- s_mult((BITS * (13 + 1)) - 1 DOWNTO (BITS * (13))) +
    -- s_mult((BITS * (14 + 1)) - 1 DOWNTO (BITS * (14))) +
    -- s_mult((BITS * (15 + 1)) - 1 DOWNTO (BITS * (15))) +
    -- s_mult((BITS * (16 + 1)) - 1 DOWNTO (BITS * (16))) +
    -- s_mult((BITS * (17 + 1)) - 1 DOWNTO (BITS * (17))) +
    -- s_mult((BITS * (18 + 1)) - 1 DOWNTO (BITS * (18))) +
    bias);

  y <= unsigned(sum_all);

END arch;