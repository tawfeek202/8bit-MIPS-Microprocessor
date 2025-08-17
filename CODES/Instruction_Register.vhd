library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Instruction_Register is
    port (
            pc_addr : in std_logic_vector (2 downto 0) ;
            IR_out  : out std_logic_vector (7 downto 0) ) ;
end entity ;

-- 8 = 3 opcode,  2  => reg_read 1\2  , 5 lsb => data_memo_address

architecture behavioral of Instruction_Register is

type reg_type is array (0 to 7) of std_logic_vector (7 downto 0);

signal IR_reg : reg_type :=("11100001" ,  
                            "00100010" ,  --ADD opcode = 001, r1=00, r2=01, memo_addr_A = 00010, memo_addr_B = 00011 , result_address = 00100
                            "01000010" ,  --SUB
                            "01100010" ,  --MUL
                            "10000010" ,  --AND
                            "10100010" ,  --OR
                            "11000010" ,  --XOR
                            "00000000"    
                            );
    
    
    begin

        IR_out <= IR_reg (to_integer (unsigned(pc_addr)));


end architecture;