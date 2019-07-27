library ieee;
library vunit_lib;
library osvvm;

use ieee.std_logic_1164.all;
use osvvm.TbUtilPkg.all;
context vunit_lib.vunit_context;


entity register_pair_tb is
  generic(runner_cfg : string := runner_cfg_default);
end entity;


architecture tb of register_pair_tb is
    constant period : time := 2 ps;
    signal clk : std_logic := '0';
    signal new_value : std_logic_vector(15 downto 0);
    signal write_enable : std_logic_vector(1 downto 0);
    signal current_value : std_logic_vector(15 downto 0);
begin
    dut: entity work.register_pair
    port map(
        clk => clk,
        new_value => new_value,
        write_enable => write_enable,
        current_value => current_value
    );

    CreateClock(clk, period);

    test_runner : process
        variable expected_current_value : std_logic_vector(15 downto 0);
    begin
        test_runner_setup(runner, runner_cfg);
        while test_suite loop
            if run("initializing_register_pair") then
                expected_current_value := x"7777";

                check_equal(current_value, expected_current_value);
            elsif run("write_both_registers_and_read") then
                new_value <= x"1234";
                write_enable <= "11";
                wait until rising_edge(clk); -- write values on this edge
                wait until falling_edge(clk);

                check_equal(current_value, new_value);
            elsif run("write_even_register_and_read") then
                new_value <= x"7712";
                write_enable <= "01";
                wait until rising_edge(clk);
                wait until falling_edge(clk);

                check_equal(current_value, new_value);
            elsif run("write_odd_register_and_read") then
                new_value <= x"1277";
                write_enable <= "10";
                wait until rising_edge(clk);
                wait until falling_edge(clk);

                check_equal(current_value, new_value);
            end if;
        end loop;
        test_runner_cleanup(runner);
    end process;
end architecture;
