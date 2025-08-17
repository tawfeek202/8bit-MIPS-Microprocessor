library IEEE;
use IEEE.std_logic_1164.all;

entity Eight_Bit_Subtractor is
  port (
    a, b          : in  std_logic_vector(7 downto 0); -- Inputs
    sub           : out std_logic_vector(7 downto 0); -- Subtraction result
    cout          : out std_logic;                    -- Carry out
    Overflow_Flag : out std_logic                     -- Overflow flag
  );
end Eight_Bit_Subtractor;

architecture arch of Eight_Bit_Subtractor is

  component FULL_ADDER
    port (
      a, b, cin : in  std_logic;
      sum, cout : out std_logic
    );
  end component;

  signal c          : std_logic_vector(6 downto 0); -- Internal carries
  signal Sub_Out    : std_logic_vector(7 downto 0); -- Internal result
  signal b_inverted : std_logic_vector(7 downto 0); -- NOT(B)

begin
  -- Invert B for two’s complement
  b_inverted <= not b;

  -- Instantiate 8-bit ripple carry adder for A + (~B) + 1
  FULL_ADDER0: FULL_ADDER port map(a(0), b_inverted(0), '1', Sub_Out(0), c(0));
  FULL_ADDER1: FULL_ADDER port map(a(1), b_inverted(1), c(0), Sub_Out(1), c(1));
  FULL_ADDER2: FULL_ADDER port map(a(2), b_inverted(2), c(1), Sub_Out(2), c(2));
  FULL_ADDER3: FULL_ADDER port map(a(3), b_inverted(3), c(2), Sub_Out(3), c(3));
  FULL_ADDER4: FULL_ADDER port map(a(4), b_inverted(4), c(3), Sub_Out(4), c(4));
  FULL_ADDER5: FULL_ADDER port map(a(5), b_inverted(5), c(4), Sub_Out(5), c(5));
  FULL_ADDER6: FULL_ADDER port map(a(6), b_inverted(6), c(5), Sub_Out(6), c(6));
  FULL_ADDER7: FULL_ADDER port map(a(7), b_inverted(7), c(6), Sub_Out(7), cout);

  -- Output assignment
  sub <= Sub_Out;

  -- Overflow detection for subtraction (signed numbers)
  Overflow_Flag <= (a(7) xor b(7)) and (Sub_Out(7) xor a(7));

end architecture;
