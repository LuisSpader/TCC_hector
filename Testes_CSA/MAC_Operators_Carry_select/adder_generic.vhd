-- Somador GENERIC  --
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
-- USE ieee.numeric_std.ALL;
-- USE work.config_package.ALL;
USE WORK.ALL;

ENTITY adder_generic IS
  GENERIC (bits : NATURAL := 8);
  PORT (
    val1, val2 : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
    F          : OUT STD_LOGIC_VECTOR (bits DOWNTO 0)
  );
END adder_generic;

ARCHITECTURE arch OF adder_generic IS
  -------------------- COMPONENTS ---------------------

  -------------------- SIGNALS ---------------------
  -------------------- BEGIN LOGIC ---------------------
BEGIN
  F <= (val1 + val2);
END arch;