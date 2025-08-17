library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Program_counter is
  port (
    CLK     : in  std_logic;
    RST     : in  std_logic;
    pc_en   : in  std_logic;
    PC_Next : in  std_logic_vector(2 downto 0);
    PC      : out std_logic_vector(2 downto 0)
  );
end Program_counter;


architecture arch of Program_counter is

  --signal pc_reg : std_logic_vector(2 downto 0);

begin

  process (CLK, RST)
  begin

    if RST = '1' then
      PC <= (others => '0');

    elsif (rising_edge(CLK) and pc_en ='1') then
      PC <= PC_Next;

    end if;
  end process;
  --PC <= pc_reg;
end arch;
