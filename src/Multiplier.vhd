library ieee;
  use ieee.std_logic_1164.all;

entity Multiplier is
  generic (
    N : natural := 7
  );
  port (
    clk       : in  std_logic;
    a_rst_h   : in  std_logic;
    en        : in  std_logic;

    a : in  std_logic_vector(N - 1 downto 0);
    b : in  std_logic_vector(N - 1 downto 0);
    mul_out  : out std_logic_vector(2*N - 1 downto 0)
  );

end entity;

architecture behavior of Multiplier is
  --------------------------------------------------------------
  -- Signals declaration
  --------------------------------------------------------------

  -- Output of the fullMultiplier_N
  signal mul_nxn_out : std_logic_vector(2*N - 1 downto 0);

  -- Output of the DFF_N
  signal dff_out : std_logic_vector(2*N - 1 downto 0);


  --------------------------------------------------------------
  -- Components declaration
  --------------------------------------------------------------

  component DFF_N is
    generic( N : natural := 2*N);

    port(
      clk     : in std_logic;
      a_rst_h : in std_logic;
      en      : in std_logic;
      d       : in std_logic_vector(N - 1 downto 0);
      q       : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component multiplier_NxN is
    generic (N : integer := N);

    port (
      A    : in std_logic_vector(N- 1 downto 0);
      B    : in std_logic_vector(N- 1 downto 0);
      P    : out std_logic_vector (2*N- 1 downto 0)
    );
  end component;

begin

  MULTIPLIER_N : multiplier_NxN
    generic map (N=> N)
    port map (
        A => a,
        B => b,
        P => mul_nxn_out
    );

  DFF_N_MAP : DFF_N
    generic map (N => 2*N)
    port map (
      clk     => clk,
      a_rst_h => a_rst_h,

      d       => mul_nxn_out,
      en      => en,
      q       => dff_out
    );

  -- Connect the output
  mul_out <= dff_out;

end architecture;
