library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Eight_Bit_OR is
  port (
    A, B : in  std_logic_vector(7 downto 0); -- Inputs
    C    : out std_logic_vector(7 downto 0)  -- Output
  );
end Eight_Bit_OR ;

architecture arch of Eight_Bit_OR is

begin

C <= A OR B; -- Perform bitwise OR operation

end architecture ; -- arch