library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MIPS_Top is
    port (
        CLK   : in  std_logic;
        RST   : in  std_logic
    );
end entity;

architecture structural of MIPS_Top is

    -- Signals
    signal instruction      : std_logic_vector(7 downto 0);
    signal pc, pc_next      : std_logic_vector(2 downto 0);
    signal pc_en            : std_logic;

    -- Controller signals
    signal alu_sel          : std_logic_vector(2 downto 0);
    signal wr_addr          : std_logic_vector(1 downto 0);
    signal rd_addr1         : std_logic_vector(1 downto 0);
    signal rd_addr2         : std_logic_vector(1 downto 0);
    signal mem_addr         : std_logic_vector(4 downto 0);
    signal reg_write_en     : std_logic;
    signal mem_wr_en        : std_logic;
    signal mem_rd_en        : std_logic;

    -- Reg File <-> ALU
    signal reg_data1        : std_logic_vector(7 downto 0);
    signal reg_data2        : std_logic_vector(7 downto 0);
    signal alu_result       : std_logic_vector(7 downto 0);

    -- ALU flags
    signal CarryOut        : std_logic;
    signal parity_flag      : std_logic;
    signal overflow_flag    : std_logic;

    -- Memory <-> RegFile
    signal mem_data_out     : std_logic_vector(7 downto 0);

    -- Write-back data
    signal write_back_data  : std_logic_vector(7 downto 0);

    --------------------------------------------------------------------
    -- ALU component declaration 
    --------------------------------------------------------------------
component ALU is
    port (
        A           : in  std_logic_vector(7 downto 0);
        B           : in  std_logic_vector(7 downto 0);
        ALU_SEL     : in  std_logic_vector(2 downto 0); -- 000=ADD, 001=SUB, 010=MUL, 011=AND, 100=OR
        
        ALU_OUT     : out std_logic_vector(7 downto 0);
        CarryOut    : out std_logic;
        Parity_Out  : out std_logic; -- renamed from Parity_Flag to avoid conflict
        Overflow    : out std_logic
    );
end component ;

    --------------------------------------------------------------------
    -- Other VHDL module components
    --------------------------------------------------------------------
    component Program_counter
        port (
            CLK     : in  std_logic;
            RST     : in  std_logic;
            pc_en   : in  std_logic;
            PC_Next : in  std_logic_vector(2 downto 0);
            PC      : out std_logic_vector(2 downto 0)
        );
    end component;

    component Instruction_Register
        port (
            pc_addr : in  std_logic_vector(2 downto 0);
            IR_out  : out std_logic_vector(7 downto 0)
        );
    end component;

    component ctrl
        port (
            Instruction   : in  std_logic_vector(7 downto 0);
            CLK           : in  std_logic;
            RST           : in  std_logic;
            wr_addr     : out std_logic_vector (1 downto 0);
            pc_en       : out std_logic;
            ALU_src       : out std_logic_vector(2 downto 0);
            rd_addr1      : out std_logic_vector(1 downto 0);
            rd_addr2      : out std_logic_vector(1 downto 0);
            memo_addr     : out std_logic_vector(4 downto 0);
            reg_write_en  : out std_logic;
            mem_wr_en     : out std_logic;
            mem_rd_en     : out std_logic
        );
    end component;

    component Reg_File
        port (
            write_data : in  std_logic_vector(7 downto 0);
            reg_write  : in  std_logic_vector(1 downto 0);
            reg_read1  : in  std_logic_vector(1 downto 0);
            reg_read2  : in  std_logic_vector(1 downto 0);
            write_en   : in  std_logic;
            CLK        : in  std_logic;
            read_data1 : out std_logic_vector(7 downto 0);
            read_data2 : out std_logic_vector(7 downto 0)
        );
    end component;

    component Data_Memo
        port (
            wr_en    : in  std_logic;
            rd_en    : in  std_logic;
            addr     : in  std_logic_vector(4 downto 0);
            data_in  : in  std_logic_vector(7 downto 0);
            CLK      : in  std_logic;
            RST      : in  std_logic;
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    --------------------------------------------------------------------
    -- Program Counter
    --------------------------------------------------------------------
    U_PC: Program_counter
        port map (
            CLK     => CLK,
            RST     => RST,
            pc_en   => pc_en,
            PC_Next => pc_next,
            PC      => pc(2 downto 0)
        );

    -- For now, PC just increments each cycle
    pc_next <= std_logic_vector(unsigned(pc) + 1);

    --------------------------------------------------------------------
    -- Instruction Register
    --------------------------------------------------------------------
    U_IR: Instruction_Register
        port map (
            pc_addr => pc (2 downto 0),
            IR_out  => instruction
        );

    --------------------------------------------------------------------
    -- Controller
    --------------------------------------------------------------------
    U_CTRL: ctrl
        port map (
            Instruction   => instruction,
            CLK           => CLK,
            RST           => RST,
            wr_addr       => wr_addr,
            pc_en         => pc_en,
            ALU_src       => alu_sel,
            rd_addr1      => rd_addr1,
            rd_addr2      => rd_addr2,
            memo_addr     => mem_addr,
            reg_write_en  => reg_write_en,
            mem_wr_en     => mem_wr_en,
            mem_rd_en     => mem_rd_en
        );

    --------------------------------------------------------------------
    -- Register File
    --------------------------------------------------------------------
    U_REG: Reg_File
        port map (
            write_data => write_back_data,
            reg_write  => wr_addr, -- assuming destination is rd_addr1
            reg_read1  => rd_addr1,
            reg_read2  => rd_addr2,
            write_en   => reg_write_en,
            CLK        => CLK,
            read_data1 => reg_data1,
            read_data2 => reg_data2
        );

    --------------------------------------------------------------------
    -- ALU
    --------------------------------------------------------------------
    U_ALU: ALU
        
        port map (
            A             => reg_data1,
            B             => reg_data2,
            ALU_SEL       => alu_sel,
            ALU_OUT      => alu_result,
            CarryOut     => CarryOut,
            Parity_Out   => parity_flag,
            Overflow => overflow_flag
        );

    --------------------------------------------------------------------
    -- Data Memory
    --------------------------------------------------------------------
    U_MEM: Data_Memo
        port map (
            wr_en    => mem_wr_en,
            rd_en    => mem_rd_en,
            addr     => mem_addr,
            data_in  => alu_result,
            CLK      => CLK,
            RST      => RST,
            data_out => mem_data_out
        );

    --------------------------------------------------------------------
    -- Write Back Selection
    --------------------------------------------------------------------
    -- If memory read enabled, write back from memory; else from ALU
    write_back_data <= mem_data_out when mem_rd_en = '1' else alu_result;

end architecture;
