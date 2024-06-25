library ieee;
  use ieee.std_logic_1164.all;

entity Multiplier is
  generic (
    N : natural := 7
  );
  port (
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


  --------------------------------------------------------------
  -- Components declaration
  --------------------------------------------------------------

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

  -- Connect the output
  mul_out <= mul_nxn_out;

end architecture;
