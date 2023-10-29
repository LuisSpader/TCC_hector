LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top IS
    GENERIC (
        bits : POSITIVE := 16
    );
    PORT (
        a, b : IN UNSIGNED(15 DOWNTO 0);
        res  : OUT UNSIGNED(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF top IS
    SIGNAL a_LSB, b_LSB, G_LSB                                                  : UNSIGNED(8 DOWNTO 0); -- 8 downto 0 ( 9 bits)

    SIGNAL a_MSB_0, b_MSB_0, a_MSB_1, b_MSB_1, G_0, G_1                         : UNSIGNED(8 DOWNTO 0);
    SIGNAL a_MSB_0_odd, b_MSB_0_odd, a_MSB_1_odd, b_MSB_1_odd, G_0_odd, G_1_odd : UNSIGNED(8 + 1 DOWNTO 0);

BEGIN

    G_LSB(8 DOWNTO 0) <= a_LSB + b_LSB;

    a_LSB             <= '0' & a(7 DOWNTO 0);
    b_LSB             <= '0' & b(7 DOWNTO 0);
    res(7 DOWNTO 0)   <= G_LSB(7 DOWNTO 0);

    a_MSB_0           <= a(15 DOWNTO 8) & '0';
    b_MSB_0           <= b(15 DOWNTO 8) & '0';
    a_MSB_1           <= a(15 DOWNTO 8) & '1';
    b_MSB_1           <= b(15 DOWNTO 8) & '1';

    G_0(8 DOWNTO 0)   <= a_MSB_0 + b_MSB_0;
    G_1(8 DOWNTO 0)   <= a_MSB_1 + b_MSB_1;
    res(15 DOWNTO 8)  <= G_0(8 DOWNTO 1) WHEN G_LSB(8) = '0' ELSE
    G_1(8 DOWNTO 1);

END ARCHITECTURE;