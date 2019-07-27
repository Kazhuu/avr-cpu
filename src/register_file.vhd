library ieee;
use ieee.std_logic_1164.all;


entity register_file is
    port(
        clk : in std_logic;
        addressing_mode : in std_logic_vector(5 downto 0);
        branch_condition : in std_logic_vector(3 downto 0);
        first_reg : in std_logic_vector(4 downto 0);
        new_value : in std_logic_vector(15 downto 0);
        alu_result : in std_logic_vector(7 downto 0);
        imm : in std_logic_vector(15 downto 0);
        second_reg : in std_logic_vector(4 downto 1);
        we_01 : in std_logic;
        we_d : in std_logic_vector(1 downto 0);
        write_alu_result : in std_logic;
        we_m : in std_logic;
        we_xyzs : in std_logic;
        adr : out std_logic_vector(15 downto 0);
        branch_valid : out std_logic;
        first_reg_value : out std_logic_vector(15 downto 0);
        flags : out std_logic_vector(7 downto 0);
        second_reg_value : out std_logic_vector(15 downto 0);
        s : out std_logic_vector(7 downto 0);
        z : out std_logic_vector(15 downto 0)
    );
end entity;


architecture behavioral of register_file is
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

    signal status_register : std_logic_vector( 7 downto 0);

    signal register_address : std_logic_vector(15 downto 0);
    signal l_base : std_logic_vector(15 downto 0);
    signal l_dddd : std_logic_vector(4 downto 1);
    signal new_stack_pointer_value : std_logic_vector(15 downto 0);
    signal l_dx : std_logic_vector(15 downto 0);
    signal l_dy : std_logic_vector(15 downto 0);
    signal l_dz : std_logic_vector(15 downto 0);
    signal l_pre : std_logic_vector(15 downto 0);
    signal l_post : std_logic_vector(15 downto 0);
    signal current_register_pair_value : std_logic_vector(15 downto 0);
    signal l_we_sp_amod : std_logic;
    signal write_enable : std_logic_vector(31 downto 0);
    signal l_we_a : std_logic;
    signal l_we_d : std_logic_vector(31 downto 0);
    signal l_we_d2 : std_logic_vector(1 downto 0);
    signal l_we_dd : std_logic_vector(31 downto 0);
    signal l_we_io : std_logic_vector(31 downto 0);
    signal l_we_misc : std_logic_vector(31 downto 0);
    signal l_we_x : std_logic;
    signal l_we_y : std_logic;
    signal l_we_z : std_logic;
    signal write_stack_pointer : std_logic_vector(1 downto 0);
    signal write_status_register : std_logic;
    signal l_xyzs : std_logic_vector(15 downto 0);
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
        new_value => new_value,
        write_enable => write_enable(27 downto 26),
        current_value => register26
    );
    r28: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
        write_enable => write_enable(29 downto 28),
        current_value => register28
    );
    r30: entity work.register_pair
    port map(clk => clk,
        new_value => new_value,
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

    -- the base value of the x/y/z/sp register as per i_amod.
    --
    process(i_amod(2 downto 0), i_imm, r_sp, r_r26, r_r28, r_r30)
    begin
        case i_amod(2 downto 0) is
            when as_sp  => l_base <= r_sp;
            when as_z   => l_base <= r_r30;
            when as_y   => l_base <= r_r28;
            when as_x   => l_base <= r_r26;
            when as_imm => l_base <= i_imm;
            when others => l_base <= x"0000";
        end case;
    end process;

    -- the value of the x/y/z/sp register after a potential pre-inc/decrement
    -- (by 1 or 2) and post-inc/decrement (by 1 or 2).
    --
    process(i_amod, i_imm)
    begin
        case i_amod is
            when amod_xq | amod_yq | amod_zq  =>
                l_pre <= i_imm;      l_post <= x"0000";

            when amod_xi | amod_yi | amod_zi  =>
                l_pre <= x"0000";    l_post <= x"0001";

            when amod_dx  | amod_dy  | amod_dz  =>
                l_pre <= x"ffff";    l_post <= x"ffff";

            when amod_isp =>
                l_pre <= x"0001";    l_post <= x"0001";

            when amod_iisp=>
                l_pre <= x"0001";    l_post <= x"0002";

            when amod_spd =>
                l_pre <= x"0000";    l_post <= x"ffff";

            when amod_spdd=>
                l_pre <= x"ffff";    l_post <= x"fffe";

            when others =>
                l_pre <= x"0000";    l_post <= x"0000";
        end case;
    end process;

    l_xyzs <= l_base + l_post;
    register_address  <= l_base + l_pre;

    l_we_a <= i_we_m when (register_address(15 downto 5) = "00000000000") else '0';
    write_status_register <= i_we_m when (register_address = x"005f") else '0';
    l_we_sp_amod <= i_we_xyzs when (i_amod(2 downto 0) = as_sp) else '0';
    l_we_sp(1) <= i_we_m when (register_address = x"005e") else l_we_sp_amod;
    l_we_sp(0) <= i_we_m when (register_address = x"005d") else l_we_sp_amod;

    l_dx  <= l_xyzs when (l_we_misc(26) = '1')        else i_din;
    l_dy  <= l_xyzs when (l_we_misc(28) = '1')        else i_din;
    l_dz  <= l_xyzs when (l_we_misc(30) = '1')        else i_din;
    l_dsp <= l_xyzs when (i_amod(3 downto 0) = am_ws) else i_din;

    -- the we signals for the differen registers.
    --
    -- case 1: write to an 8-bit register addressed by ddddd.
    --
    -- i_we_d(0) = '1' and i_ddddd matches,
    --
    l_we_d( 0) <= i_we_d(0) when (i_ddddd = "00000") else '0';
    l_we_d( 1) <= i_we_d(0) when (i_ddddd = "00001") else '0';
    l_we_d( 2) <= i_we_d(0) when (i_ddddd = "00010") else '0';
    l_we_d( 3) <= i_we_d(0) when (i_ddddd = "00011") else '0';
    l_we_d( 4) <= i_we_d(0) when (i_ddddd = "00100") else '0';
    l_we_d( 5) <= i_we_d(0) when (i_ddddd = "00101") else '0';
    l_we_d( 6) <= i_we_d(0) when (i_ddddd = "00110") else '0';
    l_we_d( 7) <= i_we_d(0) when (i_ddddd = "00111") else '0';
    l_we_d( 8) <= i_we_d(0) when (i_ddddd = "01000") else '0';
    l_we_d( 9) <= i_we_d(0) when (i_ddddd = "01001") else '0';
    l_we_d(10) <= i_we_d(0) when (i_ddddd = "01010") else '0';
    l_we_d(11) <= i_we_d(0) when (i_ddddd = "01011") else '0';
    l_we_d(12) <= i_we_d(0) when (i_ddddd = "01100") else '0';
    l_we_d(13) <= i_we_d(0) when (i_ddddd = "01101") else '0';
    l_we_d(14) <= i_we_d(0) when (i_ddddd = "01110") else '0';
    l_we_d(15) <= i_we_d(0) when (i_ddddd = "01111") else '0';
    l_we_d(16) <= i_we_d(0) when (i_ddddd = "10000") else '0';
    l_we_d(17) <= i_we_d(0) when (i_ddddd = "10001") else '0';
    l_we_d(18) <= i_we_d(0) when (i_ddddd = "10010") else '0';
    l_we_d(19) <= i_we_d(0) when (i_ddddd = "10011") else '0';
    l_we_d(20) <= i_we_d(0) when (i_ddddd = "10100") else '0';
    l_we_d(21) <= i_we_d(0) when (i_ddddd = "10101") else '0';
    l_we_d(22) <= i_we_d(0) when (i_ddddd = "10110") else '0';
    l_we_d(23) <= i_we_d(0) when (i_ddddd = "10111") else '0';
    l_we_d(24) <= i_we_d(0) when (i_ddddd = "11000") else '0';
    l_we_d(25) <= i_we_d(0) when (i_ddddd = "11001") else '0';
    l_we_d(26) <= i_we_d(0) when (i_ddddd = "11010") else '0';
    l_we_d(27) <= i_we_d(0) when (i_ddddd = "11011") else '0';
    l_we_d(28) <= i_we_d(0) when (i_ddddd = "11100") else '0';
    l_we_d(29) <= i_we_d(0) when (i_ddddd = "11101") else '0';
    l_we_d(30) <= i_we_d(0) when (i_ddddd = "11110") else '0';
    l_we_d(31) <= i_we_d(0) when (i_ddddd = "11111") else '0';

    --
    -- case 2: write to a 16-bit register pair addressed by dddd.
    --
    -- i_we_dd(1) = '1' and l_dddd matches,
    --
    l_dddd <= i_ddddd(4 downto 1);
    l_we_d2 <= i_we_d(1) & i_we_d(1);
    l_we_dd( 1 downto  0) <= l_we_d2 when (l_dddd = "0000") else "00";
    l_we_dd( 3 downto  2) <= l_we_d2 when (l_dddd = "0001") else "00";
    l_we_dd( 5 downto  4) <= l_we_d2 when (l_dddd = "0010") else "00";
    l_we_dd( 7 downto  6) <= l_we_d2 when (l_dddd = "0011") else "00";
    l_we_dd( 9 downto  8) <= l_we_d2 when (l_dddd = "0100") else "00";
    l_we_dd(11 downto 10) <= l_we_d2 when (l_dddd = "0101") else "00";
    l_we_dd(13 downto 12) <= l_we_d2 when (l_dddd = "0110") else "00";
    l_we_dd(15 downto 14) <= l_we_d2 when (l_dddd = "0111") else "00";
    l_we_dd(17 downto 16) <= l_we_d2 when (l_dddd = "1000") else "00";
    l_we_dd(19 downto 18) <= l_we_d2 when (l_dddd = "1001") else "00";
    l_we_dd(21 downto 20) <= l_we_d2 when (l_dddd = "1010") else "00";
    l_we_dd(23 downto 22) <= l_we_d2 when (l_dddd = "1011") else "00";
    l_we_dd(25 downto 24) <= l_we_d2 when (l_dddd = "1100") else "00";
    l_we_dd(27 downto 26) <= l_we_d2 when (l_dddd = "1101") else "00";
    l_we_dd(29 downto 28) <= l_we_d2 when (l_dddd = "1110") else "00";
    l_we_dd(31 downto 30) <= l_we_d2 when (l_dddd = "1111") else "00";

    --
    -- case 3: write to an 8-bit register pair addressed by an i/o address.
    --
    -- l_we_a = '1' and register_address(4 downto 0) matches
    --
    l_we_io( 0) <= l_we_a when (register_address(4 downto 0) = "00000") else '0';
    l_we_io( 1) <= l_we_a when (register_address(4 downto 0) = "00001") else '0';
    l_we_io( 2) <= l_we_a when (register_address(4 downto 0) = "00010") else '0';
    l_we_io( 3) <= l_we_a when (register_address(4 downto 0) = "00011") else '0';
    l_we_io( 4) <= l_we_a when (register_address(4 downto 0) = "00100") else '0';
    l_we_io( 5) <= l_we_a when (register_address(4 downto 0) = "00101") else '0';
    l_we_io( 6) <= l_we_a when (register_address(4 downto 0) = "00110") else '0';
    l_we_io( 7) <= l_we_a when (register_address(4 downto 0) = "00111") else '0';
    l_we_io( 8) <= l_we_a when (register_address(4 downto 0) = "01000") else '0';
    l_we_io( 9) <= l_we_a when (register_address(4 downto 0) = "01001") else '0';
    l_we_io(10) <= l_we_a when (register_address(4 downto 0) = "01010") else '0';
    l_we_io(11) <= l_we_a when (register_address(4 downto 0) = "01011") else '0';
    l_we_io(12) <= l_we_a when (register_address(4 downto 0) = "01100") else '0';
    l_we_io(13) <= l_we_a when (register_address(4 downto 0) = "01101") else '0';
    l_we_io(14) <= l_we_a when (register_address(4 downto 0) = "01110") else '0';
    l_we_io(15) <= l_we_a when (register_address(4 downto 0) = "01111") else '0';
    l_we_io(16) <= l_we_a when (register_address(4 downto 0) = "10000") else '0';
    l_we_io(17) <= l_we_a when (register_address(4 downto 0) = "10001") else '0';
    l_we_io(18) <= l_we_a when (register_address(4 downto 0) = "10010") else '0';
    l_we_io(19) <= l_we_a when (register_address(4 downto 0) = "10011") else '0';
    l_we_io(20) <= l_we_a when (register_address(4 downto 0) = "10100") else '0';
    l_we_io(21) <= l_we_a when (register_address(4 downto 0) = "10101") else '0';
    l_we_io(22) <= l_we_a when (register_address(4 downto 0) = "10110") else '0';
    l_we_io(23) <= l_we_a when (register_address(4 downto 0) = "10111") else '0';
    l_we_io(24) <= l_we_a when (register_address(4 downto 0) = "11000") else '0';
    l_we_io(25) <= l_we_a when (register_address(4 downto 0) = "11001") else '0';
    l_we_io(26) <= l_we_a when (register_address(4 downto 0) = "11010") else '0';
    l_we_io(27) <= l_we_a when (register_address(4 downto 0) = "11011") else '0';
    l_we_io(28) <= l_we_a when (register_address(4 downto 0) = "11100") else '0';
    l_we_io(29) <= l_we_a when (register_address(4 downto 0) = "11101") else '0';
    l_we_io(30) <= l_we_a when (register_address(4 downto 0) = "11110") else '0';
    l_we_io(31) <= l_we_a when (register_address(4 downto 0) = "11111") else '0';

    -- case 4 special cases.
    -- 4a. we_01 for register pair 0/1 (multiplication opcode).
    -- 4b. i_we_xyzs for x (register pairs 26/27) and i_amod matches
    -- 4c. i_we_xyzs for y (register pairs 28/29) and i_amod matches
    -- 4d. i_we_xyzs for z (register pairs 30/31) and i_amod matches
    --
    l_we_x <= i_we_xyzs when (i_amod(3 downto 0) = am_wx) else '0';
    l_we_y <= i_we_xyzs when (i_amod(3 downto 0) = am_wy) else '0';
    l_we_z <= i_we_xyzs when (i_amod(3 downto 0) = am_wz) else '0';
    l_we_misc <= l_we_z & l_we_z &      -- -z and z+ address modes  r30
                 l_we_y & l_we_y &      -- -y and y+ address modes  r28
                 l_we_x & l_we_x &      -- -x and x+ address modes  r26
                 x"000000" &            -- never                    r24 - r02
                 i_we_01 & i_we_01;     -- multiplication result    r00

    l_we <= l_we_d or l_we_dd or l_we_io or l_we_misc;

    q_s <= l_s( 7 downto 0) when (register_address(0) = '0') else l_s(15 downto 8);
    q_flags <= s_flags;
    q_z <= r_r30;
    q_adr <= register_address;

end architecture;
