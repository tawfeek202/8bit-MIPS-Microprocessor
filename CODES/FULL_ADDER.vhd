LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
 entity FULL_ADDER is
   port (
     a ,b ,cin: IN STD_LOGIC;
        sum,cout : OUT STD_LOGIC
   ) ;
 end FULL_ADDER ;
 
 architecture arch of FULL_ADDER is
 
 begin
 sum <= a xor b xor cin;
 cout <= (a and b) or (a and cin) or (b and cin);
 
 end architecture ; -- arch