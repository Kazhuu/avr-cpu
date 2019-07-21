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
    signal branch_condition : in std_logic_vector(3 downto 0);
    signal io_result : in std_logic_vector(7 downto 0);
    signal write_io_result : in std_logic;
    signal alu_result : in std_logic_vector(7 downto 0);
    signal write_alu_result : in std_logic;
    signal current_value : out std_logic_vector(7 downto 0);
    signal branch_valid : out std_logic
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
    begin
        test_runner_setup(runner, runner_cfg);
        while test_suite loop
            if run("initializing_status_register") then
                -- TODO: Write testbench stuff here.
            end if;
        end loop;
        test_runner_cleanup(runner);
    end process;
end architecture;
