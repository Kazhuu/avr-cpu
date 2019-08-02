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
        PLUS_VALUE : std_logic_vector(5 downto 3);
        PLUS1 : std_logic_vector(5 downto 3);
        PLUS2 : std_logic_vector(5 downto 3);
        MINUS1 : std_logic_vector(5 downto 3);
        MINUS2 : std_logic_vector(5 downto 3);
    end record;

    constant ADDRESS_OFFSET : address_offset_t := (
        AS_IS => "000",
        PLUS_VALUE => "010",
        PLUS1 => "001",
        PLUS2 => "011",
        MINUS1 => "101",
        MINUS2 => "111"
    );

    /*
    Constant to indicate if addressing source will be updated as a side
    effect.
    */
    type update_source_t is record
        X : std_logic_vector(3 downto 0); -- X++ or --
        Y : std_logic_vector(3 downto 0); -- Y++ or --
        Z : std_logic_vector(3 downto 0); -- Z++ or --
        SP : std_logic_vector(3 downto 0); -- SP++/--
    end record;

    constant UPDATE_SOURCE : update_source_t := (
        X => '1' & ADDRESS_SOURCE.X,
        Y => '1' & ADDRESS_SOURCE.Y,
        Z => '1' & ADDRESS_SOURCE.Z,
        SP => '1' & ADDRESS_SOURCE.SP
    );

    -- address modes used
    constant AMOD_ABS : std_logic_vector(5 downto 0) := AO_0 & AS_IMM;  -- IMM
    constant AMOD_X : std_logic_vector(5 downto 0) := AO_0 & AS_X;      -- X
    constant AMOD_Xq : std_logic_vector(5 downto 0) := AO_Q & AS_X;     -- X+q
    constant AMOD_Xi : std_logic_vector(5 downto 0) := AO_i & AS_X;     -- X+
    constant AMOD_dX : std_logic_vector(5 downto 0) := AO_d & AS_X;     -- -X
    constant AMOD_Y : std_logic_vector(5 downto 0) := AO_0 & AS_Y;      -- Y
    constant AMOD_Yq : std_logic_vector(5 downto 0) := AO_Q & AS_Y;     -- Y+q
    constant AMOD_Yi : std_logic_vector(5 downto 0) := AO_i & AS_Y;     -- Y+
    constant AMOD_dY : std_logic_vector(5 downto 0) := AO_d & AS_Y;     -- -Y
    constant AMOD_Z : std_logic_vector(5 downto 0) := AO_0 & AS_Z;      -- Z
    constant AMOD_Zq : std_logic_vector(5 downto 0) := AO_Q & AS_Z;     -- Z+q
    constant AMOD_Zi : std_logic_vector(5 downto 0) := AO_i & AS_Z;     -- Z+
    constant AMOD_dZ : std_logic_vector(5 downto 0) := AO_d & AS_Z;     -- -Z
    constant AMOD_iSP : std_logic_vector(5 downto 0) := AO_i & AS_SP;   -- +SP
    constant AMOD_iiSP : std_logic_vector(5 downto 0) := AO_ii & AS_SP; -- ++SP
    constant AMOD_SPd : std_logic_vector(5 downto 0) := AO_d & AS_SP;   -- SP-
    constant AMOD_SPdd : std_logic_vector(5 downto 0) := AO_dd & AS_SP; -- SP--
end package;
