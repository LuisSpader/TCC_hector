LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
-- USE ieee.numeric_std.ALL;
-- USE work.config_package.ALL;
USE WORK.ALL;

ENTITY full_adder_NO_COUT IS
  PORT (
    a, b, cin : IN STD_LOGIC;
    s : OUT STD_LOGIC
  );
END full_adder_NO_COUT;

ARCHITECTURE behavior OF full_adder_NO_COUT IS
BEGIN
  s <= a XOR b XOR cin;
END behavior;