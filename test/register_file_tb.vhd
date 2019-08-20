library ieee;
library vunit_lib;
library osvvm;

use ieee.std_logic_1164.all;
use osvvm.TbUtilPkg.all;
context vunit_lib.vunit_context;


entity register_file_tb is
  generic(runner_cfg : string := runner_cfg_default);
end entity;


architecture tb of register_file_tb is
    constant period : time := 2 ps;
    signal clk : std_logic := '0';
    signal addressing_mode : std_logic_vector(5 downto 0);
    signal branch_condition : std_logic_vector(3 downto 0);
    signal first_reg : std_logic_vector(4 downto 0);
    signal new_value : std_logic_vector(15 downto 0);
    signal alu_result : std_logic_vector(7 downto 0);
    signal immediate : std_logic_vector(15 downto 0);
    signal second_reg : std_logic_vector(4 downto 1);
    signal write_register01 : std_logic;
    signal write_new_value : std_logic_vector(1 downto 0);
    signal write_alu_result : std_logic;
    signal write_memory : std_logic;
    signal write_xyzs : std_logic;
    signal address : std_logic_vector(15 downto 0);
    signal branch_valid : std_logic;
    signal first_reg_value : std_logic_vector(15 downto 0);
    signal status_flags : std_logic_vector(7 downto 0);
    signal second_reg_value : std_logic_vector(15 downto 0);
    signal register_value: std_logic_vector(7 downto 0);
    signal z_reg_value : std_logic_vector(15 downto 0);
begin
    dut: entity work.register_file
    port map(
        clk => clk,
        addressing_mode => addressing_mode,
        branch_condition => branch_condition,
        first_reg => first_reg,
        new_value => new_value,
        alu_result => alu_result,
        immediate => immediate,
        second_reg => second_reg,
        write_register01 => write_register01,
        write_new_value => write_new_value,
        write_alu_result => write_alu_result,
        write_memory => write_memory,
        write_xyzs => write_xyzs,
        address => address,
        branch_valid => branch_valid,
        first_reg_value => first_reg_value,
        status_flags => status_flags,
        second_reg_value => second_reg_value,
        register_value => register_value,
        z_reg_value => z_reg_value
    );

    CreateClock(clk, period);

    test_runner : process
        variable expected_byte : std_logic_vector(7 downto 0) := (others => '0');
        variable expected_short : std_logic_vector(15 downto 0) := (others => '0');
    begin
        test_runner_setup(runner, runner_cfg);
        while test_suite loop
            if run("init_state") then
                wait for 1 ps;
                check_equal(address, expected_short);
                check_equal(branch_valid, 'U');
                check_equal(first_reg_value, std_logic_vector'(x"7777"));
                check_equal(second_reg_value, std_logic_vector'(x"7777"));
                expected_byte := (others => 'U');
                check_equal(status_flags, expected_byte);
                check_equal(register_value, std_logic_vector'(x"77"));
                check_equal(z_reg_value, std_logic_vector'(x"7777"));
            elsif run("write_and_read_register") then
                new_value <= x"1111";
                first_reg <= "00001";
                write_new_value(0) <= '1';
                wait until rising_edge(clk);
                wait until falling_edge(clk);

                check_equal(first_reg_value, std_logic_vector'(x"1177"));
            elsif run("write_and_read_register_pair") then
                new_value <= x"1111";
                first_reg <= "00001";
                write_new_value(1) <= '1';
                wait until rising_edge(clk);
                wait until falling_edge(clk);

                check_equal(first_reg_value, std_logic_vector'(x"1111"));
            elsif run("read_two_registers_simultaneously") then
                -- TODO: Finish up
                new_value <= x"1122";
                first_reg <= "00001";
                second_reg <= "0002";
                write_new_value(1) <= '1';
                wait until rising_edge(clk);
                wait until falling_edge(clk);

                check_equal(first_reg_value, std_logic_vector'(x"1111"));
                check_equal(second_reg_value, std_logic_vector'(x"1111"));
            end if;
        end loop;
        test_runner_cleanup(runner);
    end process;

end architecture;
