LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.parameters.ALL;

entity TreeSum is
    generic (
        BITS : positive := 8;  -- Size of each vector
        NUM_INPUTS : positive := 8;    -- Width of each element in bits
		output_sum_BIT_WIDTH: INTEGER := log2ceil(BITS)
    );
    port (
        input_vectors : in  std_  logic_vector((BITS * NUM_INPUTS) - 1 downto 0);
        output_sum    : out std_logic_vector((NUM_INPUTS + output_sum_BIT_WIDTH) - 1 downto 0)
    );
end entity TreeSum;

architecture Behavioral of TreeSum is
    function log2ceil(n : positive) return positive is
        variable res : positive := 0;
    begin
        while 2**res < n loop
            res := res + 1;
        end loop;
        return res;
    end function log2ceil;

    function gen_adder_tree(inputs : std_logic_vector; width : positive) return std_logic_vector is
        variable temp : std_logic_vector((width*2) - 1 downto 0);
    begin
        if width = 1 then
            return inputs;
        else
            temp := gen_adder_tree(inputs(0 to width-2) & inputs(width-1), width/2);
            return (others => '0') & gen_adder_tree(inputs(width to width*2-2) & temp(width-1 downto 0), width/2);
        end if;
    end function gen_adder_tree;
begin
    process(input_vectors)
        variable vectors : std_logic_vector(BITS-1 downto 0)(NUM_INPUTS-1 downto 0);
        variable temp    : std_logic_vector(NUM_INPUTS + log2ceil(BITS) - 1 downto 0);
    begin
        -- Convert input_vectors to array of vectors
        for i in 0 to BITS-1 loop
            vectors(i) := input_vectors(((i+1) * NUM_INPUTS) - 1 downto i * NUM_INPUTS);
        end loop;
        
        -- Sum of vectors using carry-select adders
        temp := gen_adder_tree(vectors(BITS-1), NUM_INPUTS);
        
        -- Assign result to output
        output_sum <= temp;
    end process;
end architecture Behavioral;
