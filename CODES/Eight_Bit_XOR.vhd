library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Eight_Bit_XOR is
  port (
    A, B : in  std_logic_vector(7 downto 0); -- Inputs
    C    : out std_logic_vector(7 downto 0)  -- Output
  );
end Eight_Bit_XOR ;

architecture arch of Eight_Bit_XOR is

begin

C <= A xor B; -- Perform bitwise XOR operation

end architecture ; -- arch