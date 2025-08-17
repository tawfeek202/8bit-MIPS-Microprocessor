library IEEE;
use IEEE.std_logic_1164.all;

entity Parity_Flag is
    port (
        Data        : in  std_logic_vector(7 downto 0); -- Input
        Parity_out : out std_logic                    -- Output for parity flag
    );
end entity Parity_Flag;

architecture arch of Parity_Flag is
begin
    -- Even parity: 1 if number of 1's is even
    Parity_out <= '1' when (Data(0) xor Data(1) xor Data(2) xor Data(3) xor
                             Data(4) xor Data(5) xor Data(6) xor Data(7)) = '0'
                   else '0';
end architecture;
