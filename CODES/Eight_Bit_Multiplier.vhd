library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Eight_Bit_Multiplier is
    port(
        a, b           : in  std_logic_vector(7 downto 0);
        product        : out std_logic_vector(15 downto 0);
        Overflow_Flag  : out std_logic
    );
end entity;

architecture Structural of Eight_Bit_Multiplier is
    signal temp_prod : unsigned(15 downto 0) := (others => '0');
begin
    process(a, b)
        variable A_unsigned : unsigned(7 downto 0);
        variable B_unsigned : unsigned(7 downto 0);
        variable prod       : unsigned(15 downto 0);
    begin
        A_unsigned := unsigned(a);
        B_unsigned := unsigned(b);
        prod := (others => '0');

        for i in 0 to 7 loop
            if B_unsigned(i) = '1' then
                prod := prod + (A_unsigned sll i);
            end if;
        end loop;

        temp_prod <= prod;
    end process;

    -- Overflow check: if any bit above bit 7 is 1, overflow for 8-bit result
    Overflow_Flag <= '1' when temp_prod(15 downto 8) /= "00000000" else '0';

    product <= std_logic_vector(temp_prod);
end architecture;
