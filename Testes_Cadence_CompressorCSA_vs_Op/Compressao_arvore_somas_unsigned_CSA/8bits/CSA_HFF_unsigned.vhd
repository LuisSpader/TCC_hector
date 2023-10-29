LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.parameters.ALL;

ENTITY CSA_FFF_unsigned IS
    GENERIC (
        BITS       : NATURAL := 8;
        NUM_INPUTS : NATURAL := 3
    );
    PORT (
        s_mult : IN unsigned(((2 * BITS) * (NUM_INPUTS)) - 2 DOWNTO 0);
        ----------------------------------------------
        S, C   : OUT unsigned((2 * BITS) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF CSA_FFF_unsigned IS

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
    -- v0(8 bits): 7 downto 0   --> s_mult(i)
    -- v1(8 bits): 15 downto 8  --> s_mult(i + (BITS))
    -- v2(7 bits): 22 downto 16 --> s_mult(i + (BITS * 2))

    loop_CSA0_port_map : FOR i IN 0 TO (BITS - 2) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => s_mult(i),
            b    => s_mult(i + BITS),
            cin  => s_mult(i + (BITS * 2)),
            s    => S(i),
            cout => C(i)
        );
    END GENERATE;

    half_adder_inst : half_adder
    PORT MAP(
        a    => s_mult((BITS - 1)),        -- v0(7)
        b    => s_mult((BITS - 1) + BITS), -- v1(15)
        s    => S(BITS - 1),
        cout => C(BITS - 1)
    );
END arch;