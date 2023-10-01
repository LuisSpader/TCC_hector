LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
-- USE ieee.numeric_std.ALL;
-- USE work.config_package.ALL;
USE WORK.ALL;

ENTITY full_adder_NO_Cin IS
  PORT (
    a, b : IN STD_LOGIC;
    s, cout : OUT STD_LOGIC
  );
END full_adder_NO_Cin;

ARCHITECTURE behavior OF full_adder_NO_Cin IS
BEGIN
  s <= a XOR b XOR '0';
  -- cout <= (a AND b) OR (a AND cin) OR (b AND cin);
  cout <= (a AND b);
END behavior;