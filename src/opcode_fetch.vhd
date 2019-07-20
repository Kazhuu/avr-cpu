library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity opcode_fetch is
  port (
    clk        : in  std_logic;
    rst_n      : in  std_logic;
    interrupt_vector : in  std_logic_vector(5 downto 0);
    load_pc : in  std_logic;
    new_pc  : in  std_logic_vector(15 downto 0);
    program_mem_adr     : in  std_logic_vector(11 downto 0);
    skip_in    : in  std_logic;
    opc_out    : out std_logic_vector(31 downto 0);
    pc_out     : out std_logic_vector(15 downto 0);
    pm_d_out   : out std_logic_vector(7 downto 0);
    t0_out     : out std_logic
  );
end entity;

architecture behavioral of opcode_fetch is

  -- Signals coming from program memory.
  signal wait_progmem : std_logic;

  signal next_pc_r : integer;
  signal pc_r : integer;
  signal t0_r : std_logic;
  signal long_op_r : std_logic;

begin

  -- Advance the program counter from next_pc_r.
  advance_pc : process(clk, rst_n)
  begin
    if rst_n = '1' then
      pc_r <= 0;
    elsif rising_edge(clk) then
      pc_r <= next_pc_r;
      t0_r <= not wait_progmem;
    end if;
  end process;

  next_pc_r <= 0 when rst_n = '1'
    else pc_r when wait_progmem = '1'
    else to_integer(signed(new_pc_in)) when load_pc_in = '1'
    else pc_r + 2 when long_op_r = '1'
    else pc_r + 1;

end architecture;
