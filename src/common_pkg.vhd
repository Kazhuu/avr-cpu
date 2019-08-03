library ieee;
use ieee.std_logic_1164.all;


package common_pkg is
    -- ALU operations
    constant ALU_ADC : std_logic_vector(4 downto 0) := "00000";
    constant ALU_ADD : std_logic_vector(4 downto 0) := "00001";
    constant ALU_ADIW : std_logic_vector(4 downto 0) := "00010";
    constant ALU_AND : std_logic_vector(4 downto 0) := "00011";
    constant ALU_ASR : std_logic_vector(4 downto 0) := "00100";
    constant ALU_BLD : std_logic_vector(4 downto 0) := "00101";
    constant ALU_BIT_CS : std_logic_vector(4 downto 0) := "00110";
    constant ALU_COM : std_logic_vector(4 downto 0) := "00111";
    constant ALU_DEC : std_logic_vector(4 downto 0) := "01000";
    constant ALU_EOR : std_logic_vector(4 downto 0) := "01001";
    constant ALU_MV_16 : std_logic_vector(4 downto 0) := "01010";
    constant ALU_INC : std_logic_vector(4 downto 0) := "01011";
    constant ALU_INTR : std_logic_vector(4 downto 0) := "01100";
    constant ALU_LSR : std_logic_vector(4 downto 0) := "01101";
    constant ALU_D_MV_Q : std_logic_vector(4 downto 0) := "01110";
    constant ALU_R_MV_Q : std_logic_vector(4 downto 0) := "01111";
    constant ALU_MULT : std_logic_vector(4 downto 0) := "10000";
    constant ALU_NEG : std_logic_vector(4 downto 0) := "10001";
    constant ALU_OR : std_logic_vector(4 downto 0) := "10010";
    constant ALU_PC_1 : std_logic_vector(4 downto 0) := "10011";
    constant ALU_PC_2 : std_logic_vector(4 downto 0) := "10100";
    constant ALU_ROR : std_logic_vector(4 downto 0) := "10101";
    constant ALU_SBC : std_logic_vector(4 downto 0) := "10110";
    constant ALU_SBIW : std_logic_vector(4 downto 0) := "10111";
    constant ALU_SREG : std_logic_vector(4 downto 0) := "11000";
    constant ALU_SUB : std_logic_vector(4 downto 0) := "11001";
    constant ALU_SWAP : std_logic_vector(4 downto 0) := "11010";

    -- PC manipulations
    constant PC_NEXT : std_logic_vector(2 downto 0) := "000";   -- PC += 1
    constant PC_BCC : std_logic_vector(2 downto 0) := "001";    -- PC ?= IMM
    constant PC_LD_I : std_logic_vector(2 downto 0) := "010";   -- PC = IMM
    constant PC_LD_Z : std_logic_vector(2 downto 0) := "011";   -- PC = Z
    constant PC_LD_S : std_logic_vector(2 downto 0) := "100";   -- PC = (SP)
    constant PC_SKIP_Z : std_logic_vector(2 downto 0) := "101"; -- SKIP if Z
    constant PC_SKIP_T : std_logic_vector(2 downto 0) := "110"; -- SKIP if T

    /*
    Addressing mode source which is used for the end address calculation.
    Possible sources are Z, Y, X, stack pointer or immediate value from the
    opcode.
    */
    type address_source_t is record
        Z : std_logic_vector(2 downto 0);
        Y : std_logic_vector(2 downto 0);
        X : std_logic_vector(2 downto 0);
        SP : std_logic_vector(2 downto 0);
        IMMEDIATE : std_logic_vector(2 downto 0);
    end record;

    constant ADDRESS_SOURCE : address_source_t := (
        Z => "001",
        Y => "010",
        X => "011",
        SP => "000",
        IMMEDIATE => "100"
    );

    /*
    Addressing mode offset is used to modify the source value as a side effect.
    Possible side effects are as is, add value from opcode, add 1 or 2, minus 1
    or 2.
    */
    type address_offset_t is record
        AS_IS : std_logic_vector(5 downto 3);
        ADD_VALUE : std_logic_vector(5 downto 3);
        ADD_1 : std_logic_vector(5 downto 3);
        ADD_2 : std_logic_vector(5 downto 3);
        DEC_1 : std_logic_vector(5 downto 3);
        DEC_2 : std_logic_vector(5 downto 3);
    end record;

    constant ADDRESS_OFFSET : address_offset_t := (
        AS_IS => "000",
        ADD_VALUE => "010",
        ADD_1 => "001",
        ADD_2 => "011",
        DEC_1 => "101",
        DEC_2 => "111"
    );

    /*
    Constant to indicate if addressing source will be updated as a side
    effect.
    */
    type update_source_t is record
        X : std_logic_vector(3 downto 0);  -- X++ or --
        Y : std_logic_vector(3 downto 0);  -- Y++ or --
        Z : std_logic_vector(3 downto 0);  -- Z++ or --
        SP : std_logic_vector(3 downto 0); -- SP++/--
    end record;

    constant UPDATE_SOURCE : update_source_t := (
        X => '1' & ADDRESS_SOURCE.X,
        Y => '1' & ADDRESS_SOURCE.Y,
        Z => '1' & ADDRESS_SOURCE.Z,
        SP => '1' & ADDRESS_SOURCE.SP
    );

    /*
    Different addressing modes which can be used in the design.
    */
    type addressing_mode_t is record
        ABSOLUTE : std_logic_vector(5 downto 0);   -- immediate
        X : std_logic_vector(5 downto 0);          -- X
        X_ADD_VAL : std_logic_vector(5 downto 0);  -- X+q
        X_POST_INC : std_logic_vector(5 downto 0); -- X+
        X_PRE_DEC : std_logic_vector(5 downto 0);  -- -X
        Y : std_logic_vector(5 downto 0);          -- Y
        Y_ADD_VAL : std_logic_vector(5 downto 0);  -- Y+q
        Y_POST_INC : std_logic_vector(5 downto 0); -- Y+
        Y_PRE_DEC : std_logic_vector(5 downto 0);  -- -Y
        Z : std_logic_vector(5 downto 0);          -- Z
        Z_ADD_VAL : std_logic_vector(5 downto 0);  -- Z+q
        Z_POST_INC : std_logic_vector(5 downto 0); -- Z+
        Z_PRE_DEC : std_logic_vector(5 downto 0);  -- -Z
        SP_ADD_1 : std_logic_vector(5 downto 0);   -- +SP
        SP_ADD_2 : std_logic_vector(5 downto 0);   -- ++SP
        SP_DEC_1 : std_logic_vector(5 downto 0);   -- SP-
        SP_DEC_2 : std_logic_vector(5 downto 0);   -- SP--
    end record;

    constant ADDRESSING_MODE : addressing_mode_t := (
        ABSOLUTE => ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.IMMEDIATE,
        X => ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.X,
        X_ADD_VAL => ADDRESS_OFFSET.ADD_VALUE & ADDRESS_SOURCE.X,
        X_POST_INC => ADDRESS_OFFSET.ADD_1 & ADDRESS_SOURCE.X,
        X_PRE_DEC => ADDRESS_OFFSET.DEC_1 & ADDRESS_SOURCE.X,
        Y => ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.Y,
        Y_ADD_VAL => ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.Y,
        Y_POST_INC => ADDRESS_OFFSET.ADD_1 & ADDRESS_SOURCE.Y,
        Y_PRE_DEC => ADDRESS_OFFSET.DEC_1 & ADDRESS_SOURCE.Y,
        Z => ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.Z,
        Z_ADD_VAL => ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.Z,
        Z_POST_INC => ADDRESS_OFFSET.ADD_1 & ADDRESS_SOURCE.Z,
        Z_PRE_DEC => ADDRESS_OFFSET.DEC_1 & ADDRESS_SOURCE.Z,
        SP_ADD_1 => ADDRESS_OFFSET.ADD_1 & ADDRESS_SOURCE.SP,
        SP_ADD_2 => ADDRESS_OFFSET.ADD_2 & ADDRESS_SOURCE.SP,
        SP_DEC_1 => ADDRESS_OFFSET.DEC_1 & ADDRESS_SOURCE.SP,
        SP_DEC_2 => ADDRESS_OFFSET.DEC_2 & ADDRESS_SOURCE.SP
    );
end package;
