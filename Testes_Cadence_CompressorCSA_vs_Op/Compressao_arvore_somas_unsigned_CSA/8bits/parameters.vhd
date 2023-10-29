
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- USE ieee.math_real.ALL;

PACKAGE parameters IS
    CONSTANT BITS                : INTEGER                                 := 8; --You need to change this depending on each desired input/output BITS
    CONSTANT FIRST_LAYER_NEURONS : INTEGER                                 := 3;
    CONSTANT BITS_FX_IN          : INTEGER                                 := 2 * BITS;
    CONSTANT BITS_FX_OUT         : INTEGER                                 := BITS;
    CONSTANT Leaky_attenuation   : NATURAL                                 := 2;
    CONSTANT Leaky_ReLU_ones     : signed (Leaky_attenuation - 1 DOWNTO 0) := (OTHERS => '1');

    CONSTANT ones                : STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0)    := (OTHERS => '1');                        --"1111..."
    CONSTANT zeros               : signed (BITS - 1 DOWNTO 0)              := (OTHERS => '0');                        --"0000..."
    CONSTANT bias_val            : signed (BITS - 1 DOWNTO 0)              := (BITS - 2 => '1', OTHERS => '0');       --"0000..."

    CONSTANT signed_max_2xbit    : signed ((2 * BITS) - 1 DOWNTO 0)        := ((2 * BITS) - 1 => '0', OTHERS => '1'); --"0000..."
    CONSTANT signed_max          : signed (BITS - 1 DOWNTO 0)              := (BITS - 1 => '0', OTHERS => '1');       --"0000..."

    CONSTANT clk_hz              : INTEGER                                 := 100e6;
    CONSTANT clk_period          : TIME                                    := 1 sec / clk_hz;
--    CONSTANT output_sum_BIT_WIDTH: INTEGER := log2ceil(BITS);
END parameters;

PACKAGE BODY parameters IS
    FUNCTION log2ceil(n : POSITIVE) RETURN POSITIVE IS
        VARIABLE res        : POSITIVE := 0;
    BEGIN
        WHILE 2 ** res < n LOOP
            res := res + 1;
        END LOOP;
        RETURN res;
    END FUNCTION log2ceil;

    FUNCTION gen_adder_tree(inputs : STD_LOGIC_VECTOR; width : POSITIVE) RETURN STD_LOGIC_VECTOR IS
        VARIABLE temp : STD_LOGIC_VECTOR((width * 2) - 1 DOWNTO 0);

    BEGIN
        IF width = 1 THEN
            RETURN inputs;
        ELSE
            temp := gen_adder_tree(inputs(0 TO width - 2) & inputs(width - 1), width/2);
            RETURN (OTHERS => '0') & gen_adder_tree(inputs(width TO width * 2 - 2) & temp(width - 1 DOWNTO 0), width/2);
        END IF;
    END FUNCTION gen_adder_tree;

END parameters;