library ieee;
library vunit_lib;

use ieee.std_logic_1164.all;
context vunit_lib.vunit_context;


entity register_pair_tb is
  generic (runner_cfg : string := runner_cfg_default);
end entity;


architecture tb of register_pair_tb is
    signal clk : std_logic := '0';
    signal new_value : std_logic_vector(15 downto 0);
    signal write_enable : std_logic_vector(1 downto 0);
    signal current_value : std_logic_vector(15 downto 0);
begin
    dut: entity work.register_pair
    port map(
        clk => clk;
        new_value => new_value;
        write_enable => write_enable;
        current_value => current_value
    );

    test_runner : process
    begin
        test_runner_setup(runner, runner_cfg);
        while test_suite loop
            if run("initializing register pair") then

              check_equal(to_string(true), "true");
            end if;
        end loop;
        test_runner_cleanup(runner);
    end process;
end architecture;nd entity;
