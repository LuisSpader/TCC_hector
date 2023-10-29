LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;
-- USE work.config_package.ALL;
USE WORK.ALL;

ENTITY tb_top IS -- entity declaration
  CONSTANT BITS       : INTEGER := 12;
  CONSTANT NUM_INPUTS : NATURAL := 11;
  -- CONSTANT clk_hz     : INTEGER := 100e6;
  -- CONSTANT clk_period : TIME    := 1 sec / clk_hz;
END tb_top;
----------------------------------------------------------------

ARCHITECTURE arq_tb OF tb_top IS
  --------------------- SINAIS ---------------------
  -- SIGNAL clk                     : STD_LOGIC := '0';
  SIGNAL s_mult                         : unsigned((BITS * (NUM_INPUTS)) - 1 DOWNTO 0);
  SIGNAL bias                           : unsigned((BITS) - 1 DOWNTO 0);
  SIGNAL Y                              : unsigned((BITS + 3) - 1 DOWNTO 0);
  SIGNAL v0, v1, v2, v3, v4, v5, v6, v7 : unsigned(BITS - 1 DOWNTO 0);
  SIGNAL v8, v9, v10                    : unsigned(BITS - 1 DOWNTO 0);

  --------------------- COMPONENTE -----------------

  COMPONENT top IS
    PORT (
      s_mult : IN unsigned((BITS * (NUM_INPUTS)) - 1 DOWNTO 0);
      bias   : IN unsigned(BITS - 1 DOWNTO 0); -- s_Win(0 + (BITS * (NUM_INPUTS)))
      ----------------------------------------------
      -- y      : OUT unsigned((BITS + 3) - 1 DOWNTO 0)
      y      : OUT unsigned(BITS - 1 DOWNTO 0)
    );
  END COMPONENT;

BEGIN
  s_mult((BITS * 1) - 1 DOWNTO (BITS * 0))   <= v0;
  s_mult((BITS * 2) - 1 DOWNTO (BITS * 1))   <= v1;
  s_mult((BITS * 3) - 1 DOWNTO (BITS * 2))   <= v2;
  s_mult((BITS * 4) - 1 DOWNTO (BITS * 3))   <= bias;
  s_mult((BITS * 5) - 1 DOWNTO (BITS * 4))   <= v3;
  s_mult((BITS * 6) - 1 DOWNTO (BITS * 5))   <= v4;
  s_mult((BITS * 7) - 1 DOWNTO (BITS * 6))   <= v5;
  s_mult((BITS * 8) - 1 DOWNTO (BITS * 7))   <= v6;
  s_mult((BITS * 9) - 1 DOWNTO (BITS * 8))   <= v7;
  s_mult((BITS * 10) - 1 DOWNTO (BITS * 9))  <= v8;
  s_mult((BITS * 11) - 1 DOWNTO (BITS * 10)) <= v9;
  s_mult((BITS * 12) - 1 DOWNTO (BITS * 11)) <= v10;
  -- s_mult((BITS * 13) - 1 DOWNTO (BITS * 12)) <= v11;
  -- s_mult((BITS * 14) - 1 DOWNTO (BITS * 13)) <= v12;
  -- s_mult((BITS * 15) - 1 DOWNTO (BITS * 14)) <= v13;
  -- s_mult((BITS * 16) - 1 DOWNTO (BITS * 15)) <= v14;
  -- s_mult((BITS * 17) - 1 DOWNTO (BITS * 16)) <= v15;
  -- s_mult((BITS * 18) - 1 DOWNTO (BITS * 17)) <= v16;
  -- s_mult((BITS * 19) - 1 DOWNTO (BITS * 18)) <= v17;
  -- s_mult((BITS * 20) - 1 DOWNTO (BITS * 19)) <= v18;

  v0                                         <= to_unsigned(112, v0'length);  -- Numeric_std 
  v1                                         <= to_unsigned(108, v1'length);  -- Numeric_std 
  v2                                         <= to_unsigned(107, v2'length);  -- Numeric_std 
  bias                                       <= to_unsigned(76, bias'length); -- Numeric_std 
  v3                                         <= to_unsigned(75, v3'length);   -- Numeric_std 
  v4                                         <= to_unsigned(60, v4'length);   -- Numeric_std 
  v5                                         <= to_unsigned(48, v5'length);   -- Numeric_std 
  v6                                         <= to_unsigned(33, v6'length);   -- Numeric_std 
  v7                                         <= to_unsigned(29, v7'length);   -- Numeric_std 
  v8                                         <= to_unsigned(23, v8'length);   -- Numeric_std 
  v9                                         <= to_unsigned(3, v9'length);    -- Numeric_std 
  v10                                        <= to_unsigned(13, v10'length);  -- Numeric_std 
  -- v11                                        <= to_unsigned(46, v11'length);  -- Numeric_std 
  -- v12                                        <= to_unsigned(99, v12'length);  -- Numeric_std 
  -- v13                                        <= to_unsigned(104, v13'length); -- Numeric_std 
  -- v14                                        <= to_unsigned(111, v14'length); -- Numeric_std 
  -- v15                                        <= to_unsigned(114, v15'length); -- Numeric_std 
  -- v16                                        <= to_unsigned(119, v16'length); -- Numeric_std 
  -- v17                                        <= to_unsigned(124, v17'length); -- Numeric_std 
  -- v18                                        <= to_unsigned(125, v18'length); -- Numeric_std 

  -- -- processo gerador de clock
  -- clk_gen : PROCESS
  --   --constant period: time := 20 ns;
  -- BEGIN
  --   clk <= '0';
  --   WAIT FOR clk_period/2;
  --   clk <= '1';
  --   WAIT FOR clk_period/2;
  -- END PROCESS;

  top_inst : top
  PORT MAP(
    s_mult => s_mult,
    bias   => bias,
    y      => y
  );
  -- -----------------------------------------------------------
  -- X <= "11111111";
  -- W <= "00000010";
END arq_tb;