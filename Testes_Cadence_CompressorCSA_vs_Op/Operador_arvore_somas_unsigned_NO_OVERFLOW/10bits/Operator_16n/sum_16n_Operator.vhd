LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
-- USE work.parameters.ALL;

ENTITY sum_16n_Operator IS
  GENERIC (
    BITS       : NATURAL := 20;
    NUM_INPUTS : NATURAL := 15
  );
  PORT (
    s_mult : IN unsigned((BITS * (NUM_INPUTS)) - 1 DOWNTO 0);
    bias   : IN unsigned(BITS - 1 DOWNTO 0); -- s_Win(0 + (BITS * (NUM_INPUTS)))
    ----------------------------------------------
    y      : OUT unsigned((BITS + 4) - 1 DOWNTO 0)
    -- y      : OUT unsigned(BITS - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF sum_16n_Operator IS

  -------------------- COMPONENTS ---------------------

  -------------------- SIGNALS ---------------------
  -- SIGNAL sum_all : unsigned((2 * BITS) - 1 DOWNTO 0);
  SIGNAL sum_all : unsigned((BITS + 4) - 1 DOWNTO 0);

BEGIN
  sum_all <= ("0000" & s_mult((BITS * (0 + 1)) - 1 DOWNTO (BITS * (0)))) +
    ("0000" & s_mult((BITS * (1 + 1)) - 1 DOWNTO (BITS * (1)))) +
    ("0000" & s_mult((BITS * (2 + 1)) - 1 DOWNTO (BITS * (2)))) +
    ("0000" & s_mult((BITS * (3 + 1)) - 1 DOWNTO (BITS * (3)))) +
    ("0000" & s_mult((BITS * (4 + 1)) - 1 DOWNTO (BITS * (4)))) +
    ("0000" & s_mult((BITS * (5 + 1)) - 1 DOWNTO (BITS * (5)))) +
    ("0000" & s_mult((BITS * (6 + 1)) - 1 DOWNTO (BITS * (6)))) +
    ("0000" & s_mult((BITS * (7 + 1)) - 1 DOWNTO (BITS * (7)))) +
    ("0000" & s_mult((BITS * (8 + 1)) - 1 DOWNTO (BITS * (8)))) +
    ("0000" & s_mult((BITS * (9 + 1)) - 1 DOWNTO (BITS * (9)))) +
    ("0000" & s_mult((BITS * (10 + 1)) - 1 DOWNTO (BITS * (10)))) +
    ("0000" & s_mult((BITS * (11 + 1)) - 1 DOWNTO (BITS * (11)))) +
    ("0000" & s_mult((BITS * (12 + 1)) - 1 DOWNTO (BITS * (12)))) +
    ("0000" & s_mult((BITS * (13 + 1)) - 1 DOWNTO (BITS * (13)))) +
    ("0000" & s_mult((BITS * (14 + 1)) - 1 DOWNTO (BITS * (14)))) +
    -- ("00000" & s_mult((BITS * (15 + 1)) - 1 DOWNTO (BITS * (15)))) +
    -- ("00000" & s_mult((BITS * (16 + 1)) - 1 DOWNTO (BITS * (16)))) +
    -- ("00000" & s_mult((BITS * (17 + 1)) - 1 DOWNTO (BITS * (17)))) +
    -- ("00000" & s_mult((BITS * (18 + 1)) - 1 DOWNTO (BITS * (18)))) +
    bias;
  y <= unsigned(sum_all);

END arch;