LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

------------------------------------------------------------------------
-- 8-bit Full Adder (Structural)
------------------------------------------------------------------------
ENTITY Eight_Bit_Full_Adder IS
  PORT (
    a, b          : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- Inputs                    -- Carry in
    sum           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Sum output
    cout          : OUT STD_LOGIC;                    -- Carry out
    Overflow_Flag : OUT STD_LOGIC                     -- Overflow flag
  );
END Eight_Bit_Full_Adder;

------------------------------------------------------------------------
ARCHITECTURE arch OF Eight_Bit_Full_Adder IS

  -- Full Adder component
  COMPONENT FULL_ADDER
    PORT (
      a, b, cin : IN  STD_LOGIC;
      sum, cout : OUT STD_LOGIC
    );
  END COMPONENT;

  -- Internal carry signals
  SIGNAL c : STD_LOGIC_VECTOR(6 DOWNTO 0);

  -- Internal sum (used to avoid reading from OUT port)
  SIGNAL Sum_Out : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

  -- Instantiate 8 full adders (ripple carry style)
  FULL_ADDER0: FULL_ADDER PORT MAP(a(0), b(0), '0' , Sum_Out(0), c(0));
  FULL_ADDER1: FULL_ADDER PORT MAP(a(1), b(1), c(0), Sum_Out(1), c(1));
  FULL_ADDER2: FULL_ADDER PORT MAP(a(2), b(2), c(1), Sum_Out(2), c(2));
  FULL_ADDER3: FULL_ADDER PORT MAP(a(3), b(3), c(2), Sum_Out(3), c(3));
  FULL_ADDER4: FULL_ADDER PORT MAP(a(4), b(4), c(3), Sum_Out(4), c(4));
  FULL_ADDER5: FULL_ADDER PORT MAP(a(5), b(5), c(4), Sum_Out(5), c(5));
  FULL_ADDER6: FULL_ADDER PORT MAP(a(6), b(6), c(5), Sum_Out(6), c(6));
  FULL_ADDER7: FULL_ADDER PORT MAP(a(7), b(7), c(6), Sum_Out(7), cout);

  -- Assign final sum output
  sum <= Sum_Out;

  -- Overflow detection for signed numbers
  Overflow_Flag <= (a(7) AND b(7) AND NOT Sum_Out(7)) OR
                   (NOT a(7) AND NOT b(7) AND Sum_Out(7));

END ARCHITECTURE;
