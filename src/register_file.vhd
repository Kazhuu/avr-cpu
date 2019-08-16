library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;


entity register_file is
    port(
        clk : in std_logic;
        addressing_mode : in std_logic_vector(5 downto 0);
        branch_condition : in std_logic_vector(3 downto 0);
        first_reg : in std_logic_vector(4 downto 0);
        new_value : in std_logic_vector(15 downto 0);
        alu_result : in std_logic_vector(7 downto 0);
        immediate : in std_logic_vector(15 downto 0);
        second_reg : in std_logic_vector(4 downto 1);
        write_register01 : in std_logic;
        write_new_value : in std_logic_vector(1 downto 0);
        write_alu_result : in std_logic;
        write_memory : in std_logic;
        write_xyzs : in std_logic;
        address : out std_logic_vector(15 downto 0);
        branch_valid : out std_logic;
        first_reg_value : out std_logic_vector(15 downto 0);
        status_flags : out std_logic_vector(7 downto 0);
        second_reg_value : out std_logic_vector(15 downto 0);
        register_value : out std_logic_vector(7 downto 0);
        z_reg_value : out std_logic_vector(15 downto 0)
    );
end entity;


architecture behavioral of register_file is
    constant STACK_POINTER_HIGH_ADDR : std_logic_vector(15 downto 0) := x"005E";
    constant STACK_POINTER_LOW_ADDR : std_logic_vector(15 downto 0) := x"005D";
    constant STATUS_REGISTER_ADDR : std_logic_vector(15 downto 0) := x"005F";

    -- 30 general purpose registers as pairs.
    signal register00 : std_logic_vector(15 downto 0);
    signal register02 : std_logic_vector(15 downto 0);
    signal register04 : std_logic_vector(15 downto 0);
    signal register06 : std_logic_vector(15 downto 0);
    signal register08 : std_logic_vector(15 downto 0);
    signal register10 : std_logic_vector(15 downto 0);
    signal register12 : std_logic_vector(15 downto 0);
    signal register14 : std_logic_vector(15 downto 0);
    signal register16 : std_logic_vector(15 downto 0);
    signal register18 : std_logic_vector(15 downto 0);
    signal register20 : std_logic_vector(15 downto 0);
    signal register22 : std_logic_vector(15 downto 0);
    signal register24 : std_logic_vector(15 downto 0);
    signal register26 : std_logic_vector(15 downto 0);
    signal register28 : std_logic_vector(15 downto 0);
    signal register30 : std_logic_vector(15 downto 0);
    signal stack_pointer_register : std_logic_vector(15 downto 0);

    signal status_register : std_logic_vector(7 downto 0);

    signal register_address : std_logic_vector(15 downto 0);
    signal addressing_base_value : std_logic_vector(15 downto 0);
    alias even_address : std_logic_vector(4 downto 1) is first_reg(4 downto 1);
    signal new_stack_pointer_value : std_logic_vector(15 downto 0);
    signal x_new_value : std_logic_vector(15 downto 0);
    signal y_new_value : std_logic_vector(15 downto 0);
    signal z_new_value : std_logic_vector(15 downto 0);
    signal pre_value : std_logic_vector(15 downto 0);
    signal post_value : std_logic_vector(15 downto 0);
    signal current_register_pair_value : std_logic_vector(15 downto 0);
    signal l_we_sp_amod : std_logic;
    signal write_enable : std_logic_vector(31 downto 0);
    signal write_register_address : std_logic;
    signal write_registers : std_logic_vector(31 downto 0);
    signal write_register_pair : std_logic_vector(1 downto 0);
    signal write_register_pairs : std_logic_vector(31 downto 0);
    signal write_io_registers : std_logic_vector(31 downto 0);
    signal write_misc : std_logic_vector(31 downto 0);
    signal write_x : std_logic;
    signal write_y : std_logic;
    signal write_z : std_logic;
    signal write_stack_pointer : std_logic_vector(1 downto 0);
    signal write_status_register : std_logic;
    signal xyzsp_new_value : std_logic_vector(15 downto 0);
begin
    -- TODO: Use generate statement to dry up code here.
    r00: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(1 downto 0),
        current_value => register00
    );
    r02: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(3 downto 2),
        current_value => register02
    );
    r04: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(5 downto 4),
        current_value => register04
    );
    r06: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(7 downto 6),
        current_value => register06
    );
    r08: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(9 downto 8),
        current_value => register08
    );
    r10: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(11 downto 10),
        current_value => register10
    );
    r12: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(13 downto 12),
        current_value => register12
    );
    r14: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(15 downto 14),
        current_value => register14
    );
    r16: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(17 downto 16),
        current_value => register16
    );
    r18: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(19 downto 18),
        current_value => register18
    );
    r20: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(21 downto 20),
        current_value => register20
    );
    r22: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(23 downto 22),
        current_value => register22
    );
    r24: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(25 downto 24),
        current_value => register24
    );
    r26: entity work.register_pair
    port map(clk => clk,
        new_value => x_new_value,
        write_enable => write_enable(27 downto 26),
        current_value => register26
    );
    r28: entity work.register_pair
    port map(clk => clk,
        new_value => y_new_value,
        write_enable => write_enable(29 downto 28),
        current_value => register28
    );
    r30: entity work.register_pair
    port map(clk => clk,
        new_value => z_new_value,
        write_enable => write_enable(31 downto 30),
        current_value => register30
    );
    sp: entity work.register_pair
    port map(clk => clk,
        new_value => new_stack_pointer_value,
        write_enable => write_stack_pointer,
        current_value => stack_pointer_register
    );

    sreg: entity work.status_register
    port map(clk => clk,
        branch_condition => branch_condition,
        io_result => new_value(7 downto 0),
        write_io_result => write_status_register,
        alu_result => alu_result,
        write_alu_result => write_alu_result,
        current_value => status_register,
        branch_valid => branch_valid
    );

    -- Read register pair according to register_address signal.
    process(register00, register02, register04, register06, register08,
        register10, register12, register14, register16, register18, register20,
        register22, register24, register26, register28, register30,
        stack_pointer_register, status_register, register_address(6 downto 1))
    begin
        case register_address(6 downto 1) is
            when "000000" => current_register_pair_value <= register00;
            when "000001" => current_register_pair_value <= register02;
            when "000010" => current_register_pair_value <= register04;
            when "000011" => current_register_pair_value <= register06;
            when "000100" => current_register_pair_value <= register08;
            when "000101" => current_register_pair_value <= register10;
            when "000110" => current_register_pair_value <= register12;
            when "000111" => current_register_pair_value <= register14;
            when "001000" => current_register_pair_value <= register16;
            when "001001" => current_register_pair_value <= register18;
            when "001010" => current_register_pair_value <= register20;
            when "001011" => current_register_pair_value <= register22;
            when "001100" => current_register_pair_value <= register24;
            when "001101" => current_register_pair_value <= register26;
            when "001110" => current_register_pair_value <= register28;
            when "001111" => current_register_pair_value <= register30;
            -- stack pointer low
            when "101110" => current_register_pair_value
                <= stack_pointer_register(7 downto 0) & x"00";
            -- status register & stack pointer high
            when others => current_register_pair_value
                <= status_register & stack_pointer_register(15 downto 8);
        end case;
    end process;

    -- Read register pair according to first_reg input signal.
    process(register00, register02, register04, register06, register08,
        register10, register12, register14, register16, register18, register20,
        register22, register24, register26, register28, register30,
        first_reg(4 downto 1))
    begin
        case first_reg(4 downto 1) is
            when "0000" => first_reg_value <= register00;
            when "0001" => first_reg_value <= register02;
            when "0010" => first_reg_value <= register04;
            when "0011" => first_reg_value <= register06;
            when "0100" => first_reg_value <= register08;
            when "0101" => first_reg_value <= register10;
            when "0110" => first_reg_value <= register12;
            when "0111" => first_reg_value <= register14;
            when "1000" => first_reg_value <= register16;
            when "1001" => first_reg_value <= register18;
            when "1010" => first_reg_value <= register20;
            when "1011" => first_reg_value <= register22;
            when "1100" => first_reg_value <= register24;
            when "1101" => first_reg_value <= register26;
            when "1110" => first_reg_value <= register28;
            when others => first_reg_value <= register30;
        end case;
    end process;

    -- Read register pair according to first_reg input signal.
    process(register00, register02, register04, register06, register08,
        register10, register12, register14, register16, register18, register20,
        register22, register24, register26, register28, register30,
        second_reg)
    begin
        case second_reg is
            when "0000" => second_reg_value <= register00;
            when "0001" => second_reg_value <= register02;
            when "0010" => second_reg_value <= register04;
            when "0011" => second_reg_value <= register06;
            when "0100" => second_reg_value <= register08;
            when "0101" => second_reg_value <= register10;
            when "0110" => second_reg_value <= register12;
            when "0111" => second_reg_value <= register14;
            when "1000" => second_reg_value <= register16;
            when "1001" => second_reg_value <= register18;
            when "1010" => second_reg_value <= register20;
            when "1011" => second_reg_value <= register22;
            when "1100" => second_reg_value <= register24;
            when "1101" => second_reg_value <= register26;
            when "1110" => second_reg_value <= register28;
            when others => second_reg_value <= register30;
        end case;
    end process;

    /*
    Base value assignment for addressing mode. Base value can come from
    registers x, y, z, stack pointer or immediate value.
    */
    process(addressing_mode(2 downto 0), immediate, stack_pointer_register,
        register26, register28, register30)
    begin
        case addressing_mode(2 downto 0) is
            when ADDRESS_SOURCE_X => addressing_base_value <= register26;
            when ADDRESS_SOURCE_Y => addressing_base_value <= register28;
            when ADDRESS_SOURCE_Z => addressing_base_value <= register30;
            when ADDRESS_SOURCE_SP => addressing_base_value <= stack_pointer_register;
            when ADDRESS_SOURCE_IMMEDIATE => addressing_base_value <= immediate;
            when others => addressing_base_value <= x"0000";
        end case;
    end process;

    /*
    the value of the x/y/z/sp register after a potential pre-inc/decrement
    (by 1 or 2) and post-inc/decrement (by 1 or 2).
    */
    process(addressing_mode, immediate)
    begin
        case addressing_mode is
            when MODE_X_ADD_VAL | MODE_Y_ADD_VAL | MODE_Z_ADD_VAL =>
                pre_value <= immediate;
                post_value <= x"0000";
            when MODE_X_POST_INC | MODE_Y_POST_INC | MODE_Z_POST_INC =>
                pre_value <= x"0000";
                post_value <= x"0001";
            when MODE_X_PRE_DEC | MODE_Y_PRE_DEC | MODE_Z_PRE_DEC =>
                pre_value <= x"ffff";
                post_value <= x"ffff";
            when MODE_SP_ADD_1 =>
                pre_value <= x"0001";
                post_value <= x"0001";
            when MODE_SP_ADD_2 =>
                pre_value <= x"0001";
                post_value <= x"0002";
            when MODE_SP_DEC_1 =>
                pre_value <= x"0000";
                post_value <= x"ffff";
            when MODE_SP_DEC_2 =>
                pre_value <= x"ffff";
                post_value <= x"fffe";
            when others =>
                pre_value <= x"0000";
                post_value <= x"0000";
        end case;
    end process;

    xyzsp_new_value <= std_logic_vector(signed(addressing_base_value) + signed(post_value));
    register_address <= std_logic_vector(signed(addressing_base_value) + signed(pre_value));

    write_register_address <= write_memory when register_address(15 downto 5) = "00000000000" else '0';
    write_status_register <= write_memory when register_address = STATUS_REGISTER_ADDR else '0';
    l_we_sp_amod <= write_xyzs when addressing_mode(2 downto 0) = ADDRESS_SOURCE_SP else '0';
    write_stack_pointer(1) <= write_memory when register_address = STACK_POINTER_HIGH_ADDR else l_we_sp_amod;
    write_stack_pointer(0) <= write_memory when register_address = STACK_POINTER_LOW_ADDR else l_we_sp_amod;

    x_new_value <= xyzsp_new_value when write_misc(26) = '1' else new_value;
    y_new_value <= xyzsp_new_value when write_misc(28) = '1' else new_value;
    z_new_value <= xyzsp_new_value when write_misc(30) = '1' else new_value;
    new_stack_pointer_value <= xyzsp_new_value
        when addressing_mode(3 downto 0) = UPDATE_SOURCE_SP
        else new_value;

    /*
    Write enable signals for all 8 bit general purpose registers. If first_reg
    matches register address then it will be written.
    TODO: Add register address to constants instead of hard codes values.
    TODO: Possible to use generate statements to dry up this code?
    */
    write_registers(0) <= write_new_value(0) when (first_reg = "00000") else '0';
    write_registers(1) <= write_new_value(0) when (first_reg = "00001") else '0';
    write_registers(2) <= write_new_value(0) when (first_reg = "00010") else '0';
    write_registers(3) <= write_new_value(0) when (first_reg = "00011") else '0';
    write_registers(4) <= write_new_value(0) when (first_reg = "00100") else '0';
    write_registers(5) <= write_new_value(0) when (first_reg = "00101") else '0';
    write_registers(6) <= write_new_value(0) when (first_reg = "00110") else '0';
    write_registers(7) <= write_new_value(0) when (first_reg = "00111") else '0';
    write_registers(8) <= write_new_value(0) when (first_reg = "01000") else '0';
    write_registers(9) <= write_new_value(0) when (first_reg = "01001") else '0';
    write_registers(10) <= write_new_value(0) when (first_reg = "01010") else '0';
    write_registers(11) <= write_new_value(0) when (first_reg = "01011") else '0';
    write_registers(12) <= write_new_value(0) when (first_reg = "01100") else '0';
    write_registers(13) <= write_new_value(0) when (first_reg = "01101") else '0';
    write_registers(14) <= write_new_value(0) when (first_reg = "01110") else '0';
    write_registers(15) <= write_new_value(0) when (first_reg = "01111") else '0';
    write_registers(16) <= write_new_value(0) when (first_reg = "10000") else '0';
    write_registers(17) <= write_new_value(0) when (first_reg = "10001") else '0';
    write_registers(18) <= write_new_value(0) when (first_reg = "10010") else '0';
    write_registers(19) <= write_new_value(0) when (first_reg = "10011") else '0';
    write_registers(20) <= write_new_value(0) when (first_reg = "10100") else '0';
    write_registers(21) <= write_new_value(0) when (first_reg = "10101") else '0';
    write_registers(22) <= write_new_value(0) when (first_reg = "10110") else '0';
    write_registers(23) <= write_new_value(0) when (first_reg = "10111") else '0';
    write_registers(24) <= write_new_value(0) when (first_reg = "11000") else '0';
    write_registers(25) <= write_new_value(0) when (first_reg = "11001") else '0';
    write_registers(26) <= write_new_value(0) when (first_reg = "11010") else '0';
    write_registers(27) <= write_new_value(0) when (first_reg = "11011") else '0';
    write_registers(28) <= write_new_value(0) when (first_reg = "11100") else '0';
    write_registers(29) <= write_new_value(0) when (first_reg = "11101") else '0';
    write_registers(30) <= write_new_value(0) when (first_reg = "11110") else '0';
    write_registers(31) <= write_new_value(0) when (first_reg = "11111") else '0';

    /*
    Write enable signals for 16 bit register pairs. Even address is used for
    writing register pairs.
    TODO: Use constants instead of hard coded values.
    */
    write_register_pair <= write_new_value(1) & write_new_value(1);
    write_register_pairs(1 downto 0) <= write_register_pair when even_address = "0000" else "00";
    write_register_pairs(3 downto 2) <= write_register_pair when even_address = "0001" else "00";
    write_register_pairs(5 downto 4) <= write_register_pair when even_address = "0010" else "00";
    write_register_pairs(7 downto 6) <= write_register_pair when even_address = "0011" else "00";
    write_register_pairs(9 downto 8) <= write_register_pair when even_address = "0100" else "00";
    write_register_pairs(11 downto 10) <= write_register_pair when even_address = "0101" else "00";
    write_register_pairs(13 downto 12) <= write_register_pair when even_address = "0110" else "00";
    write_register_pairs(15 downto 14) <= write_register_pair when even_address = "0111" else "00";
    write_register_pairs(17 downto 16) <= write_register_pair when even_address = "1000" else "00";
    write_register_pairs(19 downto 18) <= write_register_pair when even_address = "1001" else "00";
    write_register_pairs(21 downto 20) <= write_register_pair when even_address = "1010" else "00";
    write_register_pairs(23 downto 22) <= write_register_pair when even_address = "1011" else "00";
    write_register_pairs(25 downto 24) <= write_register_pair when even_address = "1100" else "00";
    write_register_pairs(27 downto 26) <= write_register_pair when even_address = "1101" else "00";
    write_register_pairs(29 downto 28) <= write_register_pair when even_address = "1110" else "00";
    write_register_pairs(31 downto 30) <= write_register_pair when even_address = "1111" else "00";

    -- Write to memory mapped IO space pointed by register address.
    write_io_registers(0) <= write_register_address when register_address(4 downto 0) = "00000" else '0';
    write_io_registers(1) <= write_register_address when register_address(4 downto 0) = "00001" else '0';
    write_io_registers(2) <= write_register_address when register_address(4 downto 0) = "00010" else '0';
    write_io_registers(3) <= write_register_address when register_address(4 downto 0) = "00011" else '0';
    write_io_registers(4) <= write_register_address when register_address(4 downto 0) = "00100" else '0';
    write_io_registers(5) <= write_register_address when register_address(4 downto 0) = "00101" else '0';
    write_io_registers(6) <= write_register_address when register_address(4 downto 0) = "00110" else '0';
    write_io_registers(7) <= write_register_address when register_address(4 downto 0) = "00111" else '0';
    write_io_registers(8) <= write_register_address when register_address(4 downto 0) = "01000" else '0';
    write_io_registers(9) <= write_register_address when register_address(4 downto 0) = "01001" else '0';
    write_io_registers(10) <= write_register_address when register_address(4 downto 0) = "01010" else '0';
    write_io_registers(11) <= write_register_address when register_address(4 downto 0) = "01011" else '0';
    write_io_registers(12) <= write_register_address when register_address(4 downto 0) = "01100" else '0';
    write_io_registers(13) <= write_register_address when register_address(4 downto 0) = "01101" else '0';
    write_io_registers(14) <= write_register_address when register_address(4 downto 0) = "01110" else '0';
    write_io_registers(15) <= write_register_address when register_address(4 downto 0) = "01111" else '0';
    write_io_registers(16) <= write_register_address when register_address(4 downto 0) = "10000" else '0';
    write_io_registers(17) <= write_register_address when register_address(4 downto 0) = "10001" else '0';
    write_io_registers(18) <= write_register_address when register_address(4 downto 0) = "10010" else '0';
    write_io_registers(19) <= write_register_address when register_address(4 downto 0) = "10011" else '0';
    write_io_registers(20) <= write_register_address when register_address(4 downto 0) = "10100" else '0';
    write_io_registers(21) <= write_register_address when register_address(4 downto 0) = "10101" else '0';
    write_io_registers(22) <= write_register_address when register_address(4 downto 0) = "10110" else '0';
    write_io_registers(23) <= write_register_address when register_address(4 downto 0) = "10111" else '0';
    write_io_registers(24) <= write_register_address when register_address(4 downto 0) = "11000" else '0';
    write_io_registers(25) <= write_register_address when register_address(4 downto 0) = "11001" else '0';
    write_io_registers(26) <= write_register_address when register_address(4 downto 0) = "11010" else '0';
    write_io_registers(27) <= write_register_address when register_address(4 downto 0) = "11011" else '0';
    write_io_registers(28) <= write_register_address when register_address(4 downto 0) = "11100" else '0';
    write_io_registers(29) <= write_register_address when register_address(4 downto 0) = "11101" else '0';
    write_io_registers(30) <= write_register_address when register_address(4 downto 0) = "11110" else '0';
    write_io_registers(31) <= write_register_address when register_address(4 downto 0) = "11111" else '0';

    /*
    case 4 special cases.
    4a. write_register01 for register pair 0/1 (multiplication opcode).
    4b. write_xyzs for x (register pairs 26/27) and addressing_mode matches
    4c. write_xyzs for y (register pairs 28/29) and addressing_mode matches
    4d. write_xyzs for z (register pairs 30/31) and addressing_mode matches
    */
    write_x <= write_xyzs when addressing_mode(3 downto 0) = UPDATE_SOURCE_X else '0';
    write_y <= write_xyzs when addressing_mode(3 downto 0) = UPDATE_SOURCE_Y else '0';
    write_z <= write_xyzs when addressing_mode(3 downto 0) = UPDATE_SOURCE_Z else '0';
    write_misc <= write_z & write_z &                 -- -z and z+ address modes  r30
                 write_y & write_y &                  -- -y and y+ address modes  r28
                 write_x & write_x &                  -- -x and x+ address modes  r26
                 x"000000" &                          -- never                    r24 - r02
                 write_register01 & write_register01; -- multiplication result    r00

    write_enable <= write_registers or write_register_pairs or write_io_registers or write_misc;

    register_value <= current_register_pair_value(7 downto 0)
        when register_address(0) = '0'
        else current_register_pair_value(15 downto 8);
    status_flags <= status_register;
    z_reg_value <= register30;
    address <= register_address;

end architecture;
