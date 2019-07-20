library ieee;
use ieee.std_logic_1164.all;


entity register_pair is
    port(
        clk : in std_logic;
        new_value : in std_logic_vector(15 downto 0);
        write_enable : in std_logic_vector(1 downto 0);
        current_value : out std_logic_vector(15 downto 0)
    );
end entity;


architecture behavioral of register_pair is
    -- TODO: Add reset signal to init registers.
    signal reg : std_logic_vector(15 downto 0) := x"7777";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write_enable(0) = '1' then
                reg(7 downto 0) <= new_value(7 downto 0);
            end if;
            if write_enable(1) = '1' then
                reg(15 downto 8) <= new_value(15 downto 8);
            end if;
        end if;
    end process;

    current_value <= reg;
end architecture;
