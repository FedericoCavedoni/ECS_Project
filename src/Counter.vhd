library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration for Counter
entity Counter is
  generic (
    N : natural := 16  -- Generic parameter defining the bit-width of the counter
  );
  port (
    clk       : in  std_logic;                        -- Clock signal
    a_rst_h   : in  std_logic;                        -- Asynchronous reset signal, active high
    increment : in  std_logic_vector(N - 1 downto 0); -- Increment value input
    en        : in  std_logic;                        -- Enable signal
    cntr_out  : out std_logic_vector(N - 1 downto 0)  -- Counter output
  );
end entity;

-- Architecture body for Counter
architecture struct of Counter is
  --------------------------------------------------------------
  -- Signals declaration
  --------------------------------------------------------------

  -- Signal to hold the output of the ripple carry adder
  signal fullAdder_out : std_logic_vector(N - 1 downto 0);
  -- Signal to hold the output of the D flip-flop
  signal q_h : std_logic_vector(N - 1 downto 0);

  --------------------------------------------------------------
  -- Components declaration
  --------------------------------------------------------------

  -- Component declaration for the ripple carry adder
  component ripple_carry_adder is
    generic (Nbit : integer := N);  -- Generic parameter for the bit-width

    port (
      a    : in std_logic_vector(Nbit - 1 downto 0);  -- Input A for the adder
      b    : in std_logic_vector(Nbit - 1 downto 0);  -- Input B for the adder
      cin  : in std_logic;                            -- Carry-in input for the adder
      s    : out std_logic_vector (Nbit - 1 downto 0);-- Sum output of the adder
      cout : out std_logic                            -- Carry-out output of the adder
    );
  end component;

  -- Component declaration for the N-bit D flip-flop
  component DFF_N is
    generic( N : natural := N);  -- Generic parameter for the bit-width

    port(
      clk     : in std_logic;                        -- Clock signal
      a_rst_h : in std_logic;                        -- Asynchronous reset signal, active high
      en      : in std_logic;                        -- Enable signal for the flip-flop
      d       : in std_logic_vector(N - 1 downto 0); -- Data input for the flip-flop
      q       : out std_logic_vector(N - 1 downto 0) -- Data output of the flip-flop
    );
  end component;

begin

  -- Instantiation of the ripple_carry_adder component
  FULL_ADDER_N_MAP : ripple_carry_adder
    generic map (Nbit => N)  -- Mapping the generic parameter
    port map (
      a    => increment,      -- Connecting input A to increment
      b    => q_h,            -- Connecting input B to the output of the flip-flop
      cin  => '0',            -- Connecting carry-in to '0' (no initial carry)
      s    => fullAdder_out,  -- Connecting the sum output to fullAdder_out signal
      cout => open            -- Leaving the carry-out open (unused)
    );

  -- Instantiation of the DFF_N component
  DFF_N_MAP : DFF_N
    generic map (N => N)  -- Mapping the generic parameter
    port map (
      clk     => clk,          -- Connecting the clock signal
      a_rst_h => a_rst_h,      -- Connecting the asynchronous reset signal
      d       => fullAdder_out,-- Connecting data input to fullAdder_out
      en      => en,           -- Connecting the enable signal
      q       => q_h           -- Connecting the data output to q_h signal
    );

  -- Connect the registered output to the output port
  cntr_out <= q_h;

end architecture;
