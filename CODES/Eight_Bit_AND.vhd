library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Eight_Bit_AND is
  port (
    A, B : in  std_logic_vector(7 downto 0); -- Inputs
    C    : out std_logic_vector(7 downto 0)  -- Output
  ) ;
end Eight_Bit_AND ;

architecture arch of Eight_Bit_AND is

begin

C <= A and B; -- Perform bitwise AND operation

end architecture ; -- arch