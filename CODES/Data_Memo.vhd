library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Data_Memo is
    port (  wr_en: in  std_logic ;
            rd_en: in  std_logic ;
            addr : in  std_logic_vector (4 downto 0) ;
            data_in  : in  std_logic_vector (7 downto 0) ; 
            CLK  : in  std_logic ;
            RST  : in  std_logic ;
            data_out : out  std_logic_vector (7 downto 0) );
end entity;



architecture behavioral of Data_Memo is
    

type memo_type is array (0 to 31) of std_logic_vector (7 downto 0);
signal memo : memo_type := (others => (others => '0'));
    
    
    begin

        process (CLK , RST)
        begin
            if (RST = '1') then
                memo <= (others => (others =>'0'));
                data_out <= (others => '0');

            elsif (rising_edge (CLK)) then
                if (wr_en = '1' and rd_en = '0') then
                    memo (to_integer (unsigned (addr))) <= data_in;

                elsif (rd_en ='1' and wr_en = '0') then
                    data_out <= memo (to_integer (unsigned (addr)));
                
                end if;
            
            end if;

        end process;


end architecture;