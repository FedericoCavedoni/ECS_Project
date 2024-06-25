library ieee;
  use ieee.std_logic_1164.all;

entity Adder is
  generic (
    N : natural := 16
  );
  port (
    a : in  std_logic_vector(N - 1 downto 0);
    b : in  std_logic_vector(N - 1 downto 0);
    adder_out  : out std_logic_vector(N-1 downto 0)
  );

end entity;

architecture struct of Adder is
  --------------------------------------------------------------
  -- Signals declaration
  --------------------------------------------------------------

  -- Output of the fullAdder_N
  signal fullAdder_out : std_logic_vector(N-1 downto 0);


  --------------------------------------------------------------
  -- Components declaration
  --------------------------------------------------------------

  component ripple_carry_adder is
    generic (Nbit : integer := 16);

    port (
      a    : in std_logic_vector(Nbit - 1 downto 0);
      b    : in std_logic_vector(Nbit - 1 downto 0);
      cin  : in std_logic;
      s    : out std_logic_vector (Nbit - 1 downto 0);
      cout : out std_logic
    );
  end component;

begin

  FULL_ADDER : ripple_carry_adder
    generic map (Nbit => N)
    port map (
      a    => a,
      b    => b,
      cin  => '0',
      s    => fullAdder_out,
      cout => open
    );

  -- Connect the output
  adder_out <= fullAdder_out;

end architecture;
