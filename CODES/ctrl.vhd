library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ctrl is
    port (
        Instruction : in  std_logic_vector (7 downto 0);
        CLK         : in  std_logic;
        RST         : in  std_logic;
        -- Control signals
        wr_addr     : out std_logic_vector (1 downto 0);
        pc_en       : out std_logic;
        ALU_src     : out std_logic_vector (2 downto 0);
        rd_addr1    : out std_logic_vector (1 downto 0);
        rd_addr2    : out std_logic_vector (1 downto 0);
        memo_addr   : out std_logic_vector (4 downto 0);
        reg_write_en: out std_logic;
        mem_wr_en   : out std_logic;
        mem_rd_en   : out std_logic
    );
end entity;

architecture behavioral of ctrl is

    type state_type is (IDLE, start, READ1, hold1, READ2, latch, OPERATION, WRITE1, load);
    signal state, next_state : state_type;

begin

    -- State register
    process(CLK, RST)
    begin
        if RST = '1' then
            state <= IDLE;

        elsif rising_edge(CLK) then
            state <= next_state;

        end if;
    end process;



    -- Next state logic
    process(state, Instruction)
    begin
        
        case state is
            when IDLE =>
                if unsigned(Instruction) /= 0 then
                    next_state <= start;
                else
                    next_state <= IDLE;
                end if;


            when start =>
                next_state <= READ1;

                
            when READ1 =>
                next_state <= hold1;
            
            when hold1 =>
                next_state <= READ2; 

            when READ2 =>
                next_state <= latch;

            when latch =>
                next_state <= OPERATION;

            when OPERATION =>
                next_state <= WRITE1;

            when WRITE1 =>
                next_state <= load;


            when load =>
                next_state <= IDLE;


            when others =>
                next_state <= IDLE;
        end case;
    end process;



    -- Output logic
    process(state, Instruction)
    begin

        -- Default
        pc_en        <= '0';
        reg_write_en <= '0';
        mem_wr_en    <= '0';
        mem_rd_en    <= '0';
        ALU_src      <= "000";
        wr_addr      <= "00";
        rd_addr1     <= "00";
        rd_addr2     <= "00";
        memo_addr    <= "00000";

        case state is
            when IDLE =>
                pc_en        <= '0';
                reg_write_en <= '0';
                mem_wr_en    <= '0';
                mem_rd_en    <= '0';
                ALU_src      <= "000";
                wr_addr      <= "00";
                rd_addr1     <= "00";
                rd_addr2     <= "00";
                memo_addr    <= "00000";


            when start =>
                pc_en        <= '1';
                reg_write_en <= '0';
                mem_wr_en    <= '0';
                mem_rd_en    <= '0';
                ALU_src      <= "000";
                wr_addr      <= "00";
                rd_addr1     <= "00";
                rd_addr2     <= "00";
                memo_addr    <= "00000";


                
                when READ1 =>
                pc_en        <= '0';
                reg_write_en <= '1';
                mem_wr_en    <= '0';
                mem_rd_en    <= '1';
                ALU_src      <= "000";
                wr_addr      <= Instruction(4 downto 3);
                rd_addr1     <= "00";
                rd_addr2     <= "00";
                memo_addr    <= Instruction(4 downto 0);
                
            
            when hold1 =>
                pc_en        <= '0';
                reg_write_en <= '1';
                mem_wr_en    <= '0';
                mem_rd_en    <= '1';
                ALU_src      <= "000";
                wr_addr      <= Instruction(4 downto 3);
                rd_addr1     <= "00";
                rd_addr2     <= "00";
                memo_addr    <= Instruction(4 downto 0);
            
            
            when READ2 =>
                pc_en        <= '0';
                reg_write_en <= '1';
                mem_wr_en    <= '0';
                mem_rd_en    <= '1';
                ALU_src      <= "000";
                wr_addr      <= Instruction(2 downto 1);
                rd_addr1     <= "00";
                rd_addr2     <= "00";
                memo_addr    <= std_logic_vector(unsigned(Instruction(4 downto 0)) + 1);


            when latch =>
                pc_en        <= '0';
                reg_write_en <= '1';
                mem_wr_en    <= '0';
                mem_rd_en    <= '1';
                ALU_src      <= "000";
                wr_addr      <= Instruction(2 downto 1);
                rd_addr1     <= "00";
                rd_addr2     <= "00";
                memo_addr    <= std_logic_vector(unsigned(Instruction(4 downto 0)) + 1);


            when OPERATION =>
                pc_en        <= '0';
                reg_write_en <= '0';
                mem_wr_en    <= '0';
                mem_rd_en    <= '1';
                ALU_src      <= Instruction(7 downto 5);
                wr_addr      <= "00";
                rd_addr1     <= Instruction(4 downto 3);
                rd_addr2     <= Instruction(2 downto 1);
                memo_addr    <= "00000";

            when WRITE1 =>
                pc_en        <= '0';
                reg_write_en <= '0';
                mem_wr_en    <= '1';
                mem_rd_en    <= '0';
                ALU_src      <= Instruction(7 downto 5);
                wr_addr      <= "00";
                rd_addr1     <= Instruction(4 downto 3);
                rd_addr2     <= Instruction(2 downto 1);
                memo_addr    <= Instruction(7 downto 3);

            
            when load =>
                pc_en        <= '0';
                reg_write_en <= '0';
                mem_wr_en    <= '1';
                mem_rd_en    <= '0';
                ALU_src      <= Instruction(7 downto 5);
                wr_addr      <= "00";
                rd_addr1     <= Instruction(4 downto 3);
                rd_addr2     <= Instruction(2 downto 1);
                memo_addr    <= Instruction(7 downto 3);

            when others =>
                pc_en        <= '0';
                reg_write_en <= '0';
                mem_wr_en    <= '0';
                mem_rd_en    <= '0';
                ALU_src      <= "000";
                wr_addr      <= "00";
                rd_addr1     <= "00";
                rd_addr2     <= "00";
                memo_addr    <= "00000";
        end case;
    end process;

end architecture;
