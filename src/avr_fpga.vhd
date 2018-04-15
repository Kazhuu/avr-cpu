library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity avr_fpga is
  port (
    clk           : in  std_logic;
    rst_n         : in  std_logic;
    switch_in     : in  std_logic_vector(8 downto 0);
    rx_in         : in  std_logic;
    seven_seg_out : out std_logic_vector(6 downto 0);
    leds_out      : out std_logic_vector(3 downto 0);
    tx_out        : out std_logic
  );
end entity;


architecture behavioral of avr_fpga is

  component cpu_core
    port (
      clk        : in  std_logic;
      rst_n      : in  std_logic;
      int_vec_in : in  std_logic_vector(5 downto 0);
      d_in       : in  std_logic_vector(7 downto 0);
      opc_out    : out std_logic_vector(15 downto 0);
      pc_out     : out std_logic_vector(15 downto 0);
      d_out      : out std_logic_vector(7 downto 0);
      adr_io_out : out std_logic_vector(7 downto 0);
      rd_io_out  : out std_logic;
      we_io_out  : out std_logic
    );
  end component;

  component io
    port (
      clk           : in  std_logic;
      rst_n         : in  std_logic;
      adr_io_in     : in  std_logic_vector(7 downto 0);
      d_in          : in  std_logic_vector(7 downto 0);
      rd_io_in      : in  std_logic;
      we_io_in      : in  std_logic;
      switch_in     : in  std_logic_vector(7 downto 0);
      rx_in         : in  std_logic;
      seven_seg_out : out std_logic_vector(6 downto 0);
      d_out         : out std_logic_vector(7 downto 0);
      int_vec_out   : out std_logic_vector(5 downto 0);
      leds_out      : out std_logic_vector(1 downto 0);
      tx_out        : out std_logic
    );
  end component;

  component seven_segment
    port (
      clk           : in  std_logic;
      rst_n         : in  std_logic;
      opc_in        : in  std_logic_vector(15 downto 0);
      pc_in         : in  std_logic_vector(15 downto 0);
      seven_seg_out : out std_logic_vector(6 downto 0)
    );
  end component;

  -- Signals for connections between blocks.
  signal int_vec_io_cpu : std_logic_vector(5 downto 0);
  signal opc_cpu_7seg : std_logic_vector(15 downto 0);
  signal pc_cpu_7seg : std_logic_vector(15 downto 0);
  signal d_cpu_io : std_logic_vector(7 downto 0);
  signal d_io_cpu : std_logic_vector(7 downto 0);
  signal adr_cpu_io : std_logic_vector(7 downto 0);
  signal rd_cpu_io : std_logic;
  signal we_cpu_io : std_logic;
  signal tx_io : std_logic;

  -- Signals for inner logic connections.
  signal seven_seg_io : std_logic_vector(6 downto 0);
  signal seven_seg_7seg : std_logic_vector(6 downto 0);


begin

  cpu_1 : cpu_core
  port map (
    clk        => clk,
    rst_n      => rst_n,
    int_vec_in => int_vec_io_cpu,
    d_in       => d_io_cpu,
    opc_out    => opc_cpu_7seg,
    pc_out     => pc_cpu_7seg,
    d_out      => d_cpu_io,
    adr_io_out => adr_cpu_io,
    rd_io_out  => rd_cpu_io,
    we_io_out  => we_cpu_io
  );

  io_1 : io
  port map (
    clk           => clk,
    rst_n         => rst_n,
    adr_io_in     => adr_cpu_io,
    d_in          => d_cpu_io,
    rd_io_in      => rd_cpu_io,
    we_io_in      => we_cpu_io,
    switch_in     => switch_in(7 downto 0),
    rx_in         => rx_in,
    seven_seg_out => seven_seg_io,
    d_out         => d_io_cpu,
    int_vec_out   => int_vec_io_cpu,
    leds_out      => leds_out(1 downto 0),
    tx_out        => tx_io
  );

  segment_1 : seven_segment
  port map (
    clk           => clk,
    rst_n         => rst_n,
    opc_in        => opc_cpu_7seg,
    pc_in         => pc_cpu_7seg,
    seven_seg_out => seven_seg_7seg
  );

  leds_out(2) <= tx_io;
  leds_out(3) <= rx_in;
    seven_seg_out <= seven_seg_io when switch_in(8) = '1' else seven_seg_7seg;

end architecture;
