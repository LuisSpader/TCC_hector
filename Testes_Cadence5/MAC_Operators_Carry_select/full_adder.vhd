LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
-- USE ieee.numeric_std.ALL;
-- USE work.config_package.ALL;
USE WORK.ALL;

ENTITY full_adder IS
  PORT (
    a, b, cin : IN STD_LOGIC;
    s, cout : OUT STD_LOGIC
  );
END full_adder;

ARCHITECTURE behavior OF full_adder IS
BEGIN
  s <= a XOR b XOR cin;
  cout <= (a AND b) OR (a AND cin) OR (b AND cin);
END behavior;