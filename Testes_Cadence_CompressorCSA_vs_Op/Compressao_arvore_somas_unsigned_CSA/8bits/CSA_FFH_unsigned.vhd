LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.parameters.ALL;

ENTITY CSA_FFH_unsigned IS
    GENERIC (
        BITS       : NATURAL := 8;
        NUM_INPUTS : NATURAL := 3
    );
    PORT (
        s_mult : IN unsigned(((2 * BITS) * (NUM_INPUTS)) - 1 DOWNTO 1);
        ----------------------------------------------
        S, C   : OUT unsigned((2 * BITS) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF CSA_FFH_unsigned IS

    -------------------- SIGNALS ---------------------

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

BEGIN
    -- for 8 bits we'll have:
    -- v0(7 bits): 7 downto 1   --> s_mult(i)
    -- v1(8 bits): 15 downto 8  --> s_mult(i + (BITS))
    -- v2(8 bits): 23 downto 16 --> s_mult(i + (BITS * 2))

    half_adder_inst : half_adder
    PORT MAP(
        a    => s_mult(0 + BITS),       -- v1
        b    => s_mult(0 + (BITS * 2)), -- v2
        s    => S(0),
        cout => C(0)
    );
    loop_CSA0_port_map : FOR i IN 1 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => s_mult(i),
            b    => s_mult(i + BITS),
            cin  => s_mult(i + (BITS * 2)),
            s    => S(i),
            cout => C(i)
        );
    END GENERATE;

END arch;