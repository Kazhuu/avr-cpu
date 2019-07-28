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

    -- Addressing modes. An address mode consists of two sub-fields,
    -- which are the source of the address and an offset from the source.
    -- Bit 3 indicates if the address will be modified.
    -- address source
    constant AS_SP : std_logic_vector(2 downto 0) := "000";  -- SP
    constant AS_Z : std_logic_vector(2 downto 0) := "001";   -- Z
    constant AS_Y : std_logic_vector(2 downto 0) := "010";   -- Y
    constant AS_X : std_logic_vector(2 downto 0) := "011";   -- X
    constant AS_IMM : std_logic_vector(2 downto 0) := "100"; -- IMM

    -- address offset
    constant AO_0 : std_logic_vector(5 downto 3) := "000";  -- as is
    constant AO_Q : std_logic_vector(5 downto 3) := "010";  -- +q
    constant AO_i : std_logic_vector(5 downto 3) := "001";  -- +1
    constant AO_ii : std_logic_vector(5 downto 3) := "011"; -- +2
    constant AO_d : std_logic_vector(5 downto 3) := "101";  -- -1
    constant AO_dd : std_logic_vector(5 downto 3) := "111"; -- -2

    constant AM_WX : std_logic_vector(3 downto 0) := '1' & AS_X;  -- X ++ or --
    constant AM_WY : std_logic_vector(3 downto 0) := '1' & AS_Y;  -- Y ++ or --
    constant AM_WZ : std_logic_vector(3 downto 0) := '1' & AS_Z;  -- Z ++ or --
    constant AM_WS : std_logic_vector(3 downto 0) := '1' & AS_SP; -- SP ++/--

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
