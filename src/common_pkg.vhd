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
    constant ADDRESS_SOURCE_SP : std_logic_vector(2 downto 0) := "000";        -- SP
    constant ADDRESS_SOURCE_Z : std_logic_vector(2 downto 0) := "001";         -- Z
    constant ADDRESS_SOURCE_Y : std_logic_vector(2 downto 0) := "010";         -- Y
    constant ADDRESS_SOURCE_X : std_logic_vector(2 downto 0) := "011";         -- X
    constant ADDRESS_SOURCE_IMMEDIATE : std_logic_vector(2 downto 0) := "100"; -- IMM

    /*
    Addressing mode offset is used to modify the source value as a side effect.
    Possible side effects are as is, add value from opcode, add 1 or 2, minus 1
    or 2.
    */
    constant ADDRESS_OFFSET_AS_IS : std_logic_vector(5 downto 3) := "000";     -- as is
    constant ADDRESS_OFFSET_ADD_VALUE : std_logic_vector(5 downto 3) := "010"; -- +q
    constant ADDRESS_OFFSET_ADD_1 : std_logic_vector(5 downto 3) := "001";     -- +1
    constant ADDRESS_OFFSET_ADD_2 : std_logic_vector(5 downto 3) := "011";     -- +2
    constant ADDRESS_OFFSET_DEC_1 : std_logic_vector(5 downto 3) := "101";     -- -1
    constant ADDRESS_OFFSET_DEC_2 : std_logic_vector(5 downto 3) := "111";     -- -2

    /*
    Constant to indicate if addressing source will be updated as a side
    effect.
    */
    constant UPDATE_SOURCE_X : std_logic_vector(3 downto 0) :=
        '1' & ADDRESS_SOURCE_X;  -- X ++ or --
    constant UPDATE_SOURCE_Y : std_logic_vector(3 downto 0) :=
        '1' & ADDRESS_SOURCE_Y;  -- Y ++ or --
    constant UPDATE_SOURCE_Z : std_logic_vector(3 downto 0) :=
        '1' & ADDRESS_SOURCE_Z;  -- Z ++ or --
    constant UPDATE_SOURCE_SP : std_logic_vector(3 downto 0) :=
        '1' & ADDRESS_SOURCE_SP; -- SP ++/--

    /*
    Different addressing modes which can be used in the design.
    */
    constant ADDRESSING_MODE_ABSOLUTE : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.IMMEDIATE; -- immediate
    constant ADDRESSING_MODE_X : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.X;         -- X
    constant ADDRESSING_MODE_X_ADD_VAL : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.ADD_VALUE & ADDRESS_SOURCE.X;     -- X+q
    constant ADDRESSING_MODE_X_POST_INC : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.ADD_1 & ADDRESS_SOURCE.X;         -- X+
    constant ADDRESSING_MODE_X_PRE_DEC : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.DEC_1 & ADDRESS_SOURCE.X;         -- -X
    constant ADDRESSING_MODE_Y : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.Y;         -- Y
    constant ADDRESSING_MODE_Y_ADD_VAL : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.Y;         -- Y+q
    constant ADDRESSING_MODE_Y_POST_INC : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.ADD_1 & ADDRESS_SOURCE.Y;         -- Y+
    constant ADDRESSING_MODE_Y_PRE_DEC : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.DEC_1 & ADDRESS_SOURCE.Y;         -- -Y
    constant ADDRESSING_MODE_Z : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.Z;         -- Z
    constant ADDRESSING_MODE_Z_ADD_VAL : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.AS_IS & ADDRESS_SOURCE.Z;         -- Z+q
    constant ADDRESSING_MODE_Z_POST_INC : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.ADD_1 & ADDRESS_SOURCE.Z;         -- Z+
    constant ADDRESSING_MODE_Z_PRE_DEC : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.DEC_1 & ADDRESS_SOURCE.Z;         -- -Z
    constant ADDRESSING_MODE_SP_ADD_1 : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.ADD_1 & ADDRESS_SOURCE.SP;        -- +SP
    constant ADDRESSING_MODE_SP_ADD_2 : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.ADD_2 & ADDRESS_SOURCE.SP;        -- ++SP
    constant ADDRESSING_MODE_SP_DEC_1 : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.DEC_1 & ADDRESS_SOURCE.SP;        -- SP-
    constant ADDRESSING_MODE_SP_DEC_2 : std_logic_vector(5 downto 0) :=
        ADDRESS_OFFSET.DEC_2 & ADDRESS_SOURCE.S;         -- SP--
end package;
