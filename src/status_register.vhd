library ieee;
use ieee.std_logic_1164.all;

/*
Status register containing following bits:
0 (C): Carry Flag
1 (Z): Zero Flag
2 (N): Negative Flag
3 (V): Two’s complement overflow indicator
4 (S): N xor V, for signed tests
5 (H): Half Carry Flag
6 (T): Transfer bit used by BLD and BST instructions
7 (I): Global Interrupt Enable/Disable Flag
*/
entity status_register is
    port(
        clk : in std_logic;
        branch_condition : in std_logic_vector(3 downto 0);
        io_result : in std_logic_vector(7 downto 0);
        write_io_result : in std_logic;
        alu_result : in std_logic_vector(7 downto 0);
        write_alu_result : in std_logic;
        current_value : out std_logic_vector(7 downto 0);
        branch_valid : out std_logic
    );
end entity;


architecture behavioral of status_register is
    constant CARRY_FLAG : std_logic_vector(2 downto 0) := "000";
    constant ZERO_FLAG : std_logic_vector(2 downto 0) := "001";
    constant NEGATIVE_FLAG : std_logic_vector(2 downto 0) := "010";
    constant OVERFLOW_FLAG : std_logic_vector(2 downto 0) := "011";
    constant N_V_SIGNED_FLAG : std_logic_vector(2 downto 0) := "100";
    constant HALF_CARRY_FLAG : std_logic_vector(2 downto 0) := "101";
    constant TRANSFER_FLAG : std_logic_vector(2 downto 0) := "110";
    signal reg : std_logic_vector(7 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write_alu_result = '1' then
                reg <= alu_result;
            elsif write_io_result = '1' then
                reg <= io_result;
            end if;
        end if;
    end process;

    -- Branch logic for BRBS and BRBC opcodes.
    -- Branch if Bit in SREG is Set (BRSB).
    -- Branch if Bit in SREG is Cleared (BRSC).
    branching: process(branch_condition, reg)
    begin
        case branch_condition(2 downto 0) is
            when CARRY_FLAG => branch_valid <= reg(0) xor branch_condition(3);
            when ZERO_FLAG => branch_valid <= reg(1) xor branch_condition(3);
            when NEGATIVE_FLAG => branch_valid <= reg(2) xor branch_condition(3);
            when OVERFLOW_FLAG => branch_valid <= reg(3) xor branch_condition(3);
            when N_V_SIGNED_FLAG => branch_valid <= reg(4) xor branch_condition(3);
            when HALF_CARRY_FLAG => branch_valid <= reg(5) xor branch_condition(3);
            when TRANSFER_FLAG => branch_valid <= reg(6) xor branch_condition(3);
            when others => branch_valid <= reg(7) xor branch_condition(3);
        end case;
    end process;

    current_value <= reg;
end architecture;
