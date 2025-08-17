library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Reg_File is
    port(
        write_data : in std_logic_vector (7 downto 0);
        reg_write  : in std_logic_vector (1 downto 0);
        reg_read1  : in std_logic_vector (1 downto 0);
        reg_read2  : in std_logic_vector (1 downto 0);
        write_en   : in std_logic;
        CLK        : in std_logic;

        read_data1 : out std_logic_vector (7 downto 0);
        read_data2 : out std_logic_vector (7 downto 0)
    );
end entity;

architecture behavioral of Reg_File is

    -- 4 registers of 8 bits each
    type reg_file_type is array (0 to 3) of std_logic_vector(7 downto 0);
    signal reg_comb : reg_file_type := (others => (others => '0'));


        
begin

    -- Write on rising edge if enabled
    process (CLK)
    begin
        if rising_edge(CLK) then
            if (write_en = '1') then
                reg_comb(to_integer(unsigned(reg_write))) <= write_data;
            
            end if;

        end if;
    end process;


read_data1 <= reg_comb(to_integer(unsigned(reg_read1)));
read_data2 <= reg_comb(to_integer(unsigned(reg_read2)));



end architecture;
