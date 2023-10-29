LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--USE ieee.math_real.ALL;
-- USE work.parameters.ALL;

ENTITY top IS
    GENERIC (
        BITS       : NATURAL := 16;
        NUM_INPUTS : NATURAL := 3
    );
    PORT (
        s_mult : IN unsigned((BITS * NUM_INPUTS) - 1 DOWNTO 0);
        bias   : IN unsigned(BITS - 1 DOWNTO 0); -- s_Win(0 + (BITS * (NUM_INPUTS)))
        ----------------------------------------------
        y      : OUT unsigned((BITS + 2) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF top IS

    -------------------- SIGNALS ---------------------
    SIGNAL sum_all        : STD_LOGIC_VECTOR((BITS + 2) - 1 DOWNTO 0);
    SIGNAL S0, C0, S1, C1 : STD_LOGIC_VECTOR(BITS - 1 DOWNTO 0);
    SIGNAL S_add          : STD_LOGIC_VECTOR(BITS - 1 DOWNTO 0);
    SIGNAL A, B           : unsigned(17 - 1 DOWNTO 0);

    COMPONENT CSA IS
        PORT (
            a, b : IN UNSIGNED(17 - 1 DOWNTO 0);
            res  : OUT UNSIGNED(17 - 1 DOWNTO 0)
        );
    END COMPONENT;
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

    -- COMPRESSOR 0 --------------------------------- FFF
    loop_CSA0_port_map : FOR i IN 0 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => s_mult(i),
            b    => s_mult(i + BITS),
            cin  => s_mult(i + (BITS * 2)), --bias s_Win(i + (BITS * (NUM_INPUTS)))
            s    => S0(i),
            cout => C0(i)
        );
    END GENERATE;
    -- COMPRESSOR 1 --------------------------------- FFH
    half_adder_inst : half_adder
    PORT MAP(
        a    => S0(0),
        b    => bias(0), --bias s_Win(0 + (BITS * (NUM_INPUTS)))
        s    => S1(0),
        cout => C1(0)
    );

    loop_CSA1_port_map : FOR i IN 1 TO (BITS - 1) GENERATE
        CSA_inst_loop : full_adder
        PORT MAP(
            a    => S0(i),
            b    => C0(i - 1),
            cin  => bias(i), --bias s_Win(i + (BITS * (NUM_INPUTS)))
            s    => S1(i),
            cout => C1(i)
        );
    END GENERATE;
    -- ----------------------------------------------

    sum_all(0) <= S1(0);

    S_add      <= C0(BITS - 1) & S1(BITS - 1 DOWNTO 1);

    A          <= '0' & S_add; -- 17 bits
    B          <= '0' & C1;    -- 17 bits

    level7_adder_CSA_inst : CSA PORT MAP(
        a   => A,
        b   => B,
        res => sum_all((BITS + 2) - 1 DOWNTO 1)
    );

    -- adder_inst : adder_generic_signed_FFH
    -- PORT MAP(
    --     S => S_add,
    --     C => C1,
    --     F => sum_all(BITS + 1 DOWNTO 1)
    -- );
    y <= unsigned(sum_all); -- Numeric_std 

END arch;