library ieee;
use ieee.std_logic_1164.all;

/*
Status register containing following bits:
0 (C): Carry Flag
1 (Z): Zero Flag
2 (N): Negative Flag
3 (V): Two’s complement overflow indicator
4 (S): N ⊕ V, for signed tests
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

    branching: process(branch_condition, reg)
    begin
        case branch_condition(2 downto 0) is
            when "000"  => branch_valid <= reg(0) xor branch_condition(3);
            when "001"  => branch_valid <= reg(1) xor branch_condition(3);
            when "010"  => branch_valid <= reg(2) xor branch_condition(3);
            when "011"  => branch_valid <= reg(3) xor branch_condition(3);
            when "100"  => branch_valid <= reg(4) xor branch_condition(3);
            when "101"  => branch_valid <= reg(5) xor branch_condition(3);
            when "110"  => branch_valid <= reg(6) xor branch_condition(3);
            when others => branch_valid <= reg(7) xor branch_condition(3);
        end case;
    end process;

    current_value <= reg;
end architecture;

