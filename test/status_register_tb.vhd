library ieee;
library vunit_lib;
library osvvm;

use ieee.std_logic_1164.all;
use osvvm.TbUtilPkg.all;
context vunit_lib.vunit_context;


entity status_register_tb is
  generic(runner_cfg : string := runner_cfg_default);
end entity;


architecture tb of status_register_tb is
    constant period : time := 2 ps;
    signal clk : std_logic := '0';
    signal branch_condition : std_logic_vector(3 downto 0);
    signal io_result : std_logic_vector(7 downto 0);
    signal write_io_result : std_logic;
    signal alu_result : std_logic_vector(7 downto 0);
    signal write_alu_result : std_logic;
    signal current_value : std_logic_vector(7 downto 0);
    signal branch_valid : std_logic;
begin
    dut: entity work.status_register
    port map(
        clk => clk,
        branch_condition => branch_condition,
        io_result => io_result,
        write_io_result => write_io_result,
        alu_result => alu_result,
        write_alu_result => write_alu_result,
        current_value => current_value,
        branch_valid => branch_valid
    );

    CreateClock(clk, period);

    test_runner : process
        variable expected_current_value : std_logic_vector(7 downto 0);
    begin
        test_runner_setup(runner, runner_cfg);
        while test_suite loop
            if run("initialized_out_values") then
                -- TODO: Add reset for dut so these values are set to 0?
                expected_current_value := (others => 'U');

                check_equal(current_value, expected_current_value);
                check_equal(branch_valid, 'U');
            elsif run("write_io_result_and_read") then
                io_result <= x"12";
                write_io_result <= '1';
                wait until rising_edge(clk); -- value written on this edge
                wait until falling_edge(clk);

                check_equal(current_value, io_result);
            elsif run("write_alu_result_and_read") then
                alu_result <= x"12";
                write_alu_result <= '1';
                wait until rising_edge(clk);
                wait until falling_edge(clk);

                check_equal(current_value, alu_result);
            elsif run("branch_carry_flag_set") then
                io_result <= "10000001";
                write_io_result <= '1';
                wait until rising_edge(clk);
                branch_condition(2 downto 0) <= "000";
                branch_condition(3) <= '1';
                wait for 1 ps;

                -- TODO: Not working yet.
                check_equal(branch_valid, '1');
            end if;
        end loop;
        test_runner_cleanup(runner);
    end process;
end architecture;
