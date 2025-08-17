library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        A           : in  std_logic_vector(7 downto 0);
        B           : in  std_logic_vector(7 downto 0);
        ALU_SEL     : in  std_logic_vector(2 downto 0); -- 000=ADD, 001=SUB, 010=MUL, 011=AND, 100=OR
        
        ALU_OUT     : out std_logic_vector(7 downto 0);
        CarryOut    : out std_logic;
        Parity_Out  : out std_logic; -- renamed from Parity_Flag to avoid conflict
        Overflow    : out std_logic
    );
end entity ALU;

architecture Structural of ALU is

    -------------------------------------------------------------------
    -- Component Declarations
    -------------------------------------------------------------------
    component Eight_Bit_Full_Adder
        port (
            a, b          : in  std_logic_vector(7 downto 0);
            sum           : out std_logic_vector(7 downto 0);
            cout          : out std_logic;
            Overflow_Flag : out std_logic
        );
    end component;

    component Eight_Bit_Subtractor
        port (
            a, b          : in  std_logic_vector(7 downto 0);
            sub           : out std_logic_vector(7 downto 0);
            cout          : out std_logic;
            Overflow_Flag : out std_logic
        );
    end component;

    component Eight_Bit_Multiplier
        port (
            a, b          : in  std_logic_vector(7 downto 0);
            product       : out std_logic_vector(15 downto 0);
            Overflow_Flag : out std_logic
        );
    end component;

    component Eight_Bit_AND
        port (
            A, B : in  std_logic_vector(7 downto 0);
            C    : out std_logic_vector(7 downto 0)
        );
    end component;

    component Eight_Bit_OR
        port (
            A, B : in  std_logic_vector(7 downto 0);
            C    : out std_logic_vector(7 downto 0)
        );
    end component;

    component Eight_Bit_XOR is
        port (
             A, B : in  std_logic_vector(7 downto 0); -- Inputs
             C    : out std_logic_vector(7 downto 0)  -- Output
              );
      end component ;

    component Parity_Flag_Comp
        port (
            Data       : in  std_logic_vector(7 downto 0);
            Parity_out : out std_logic
        );
    end component;

    -------------------------------------------------------------------
    -- Internal Signals
    -------------------------------------------------------------------
    signal add_res, sub_res, and_res, or_res, xor_res : std_logic_vector(7 downto 0);
    signal mul_res : std_logic_vector(15 downto 0);

    signal add_cout, sub_cout : std_logic;
    signal add_overflow, sub_overflow, mul_overflow : std_logic;

    signal result : std_logic_vector(7 downto 0);
    signal parity_sig : std_logic; -- intermediate for parity output

begin
    -------------------------------------------------------------------
    -- Module Instantiations
    -------------------------------------------------------------------
    U_ADD: Eight_Bit_Full_Adder
        port map (
            a => A, b => B,
            sum => add_res,
            cout => add_cout,
            Overflow_Flag => add_overflow
        );

    U_SUB: Eight_Bit_Subtractor
        port map (
            a => A, b => B,
            sub => sub_res,
            cout => sub_cout,
            Overflow_Flag => sub_overflow
        );

    U_MUL: Eight_Bit_Multiplier
        port map (
            a => A, b => B,
            product => mul_res,
            Overflow_Flag => mul_overflow
        );

    U_AND: Eight_Bit_AND
        port map (
            A => A, B => B,
            C => and_res
        );

    U_OR: Eight_Bit_OR
        port map (
            A => A, B => B,
            C => or_res
        );


    U_XOR: Eight_Bit_XOR
        port map (
            A => A, B => B,
            C => xor_res
        );


    -- Parity Calculation
    U_PARITY: Parity_Flag_Comp
        port map (
            Data => result,
            Parity_out => parity_sig
        );

    -------------------------------------------------------------------
    -- ALU Operation Selection
    -------------------------------------------------------------------
    process(ALU_SEL, add_res, sub_res, mul_res, and_res, or_res, xor_res,
            add_cout, sub_cout, add_overflow, sub_overflow, mul_overflow)
    begin
        -- Default outputs
        result   <= (others => '0');
        CarryOut <= '0';
        Overflow <= '0';

        case ALU_SEL is
            when "001" => -- ADD
                result   <= add_res;
                CarryOut <= add_cout;
                Overflow <= add_overflow;

            when "010" => -- SUB
                result   <= sub_res;
                CarryOut <= sub_cout;
                Overflow <= sub_overflow;

            when "011" => -- MUL
                result   <= mul_res(7 downto 0); -- lower 8 bits
                Overflow <= mul_overflow;

            when "100" => -- AND
                result   <= and_res;

            when "101" => -- OR
                result   <= or_res;

            when "110" => -- XOR
                result   <= xor_res;
            when others =>
                result   <= (others => '0');
        end case;
    end process;

    -- Output assignments
    ALU_OUT    <= result;
    Parity_Out <= parity_sig;

end architecture Structural;
--000  add
--001  sub  
--010  mul
--011  and
--100  or
--101  xor
