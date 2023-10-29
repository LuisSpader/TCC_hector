LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
-- USE ieee.numeric_std.ALL;
-- USE work.config_package.ALL;
USE WORK.ALL;

ENTITY half_adder_NO_COUT IS
  PORT (
    a, b : IN STD_LOGIC;
    s    : OUT STD_LOGIC
  );
END half_adder_NO_COUT;

ARCHITECTURE behavior OF half_adder_NO_COUT IS
BEGIN
  s <= a XOR b;
  -- cout <= (a AND b) OR (a AND cin) OR (b AND cin);
  -- cout <= (a AND b);
END behavior;