library ieee;
  use ieee.std_logic_1164.all;

entity Amplitude_Multiplier is
  generic (
    N : natural := 7
  );
  port (
    clk     : in  std_logic;
    a_rst_h : in  std_logic;

    a : in  std_logic_vector(N - 1 downto 0);
    b : in  std_logic_vector(N - 1 downto 0);
    mul_out  : out std_logic_vector(2*N - 1 downto 0)
  );

end entity;

architecture behavior of Amplitude_Multiplier is
  --------------------------------------------------------------
  -- Signals declaration
  --------------------------------------------------------------

  -- Output of the fullMultiplier_N
  signal mul_nxn_out : std_logic_vector(2*N - 1 downto 0);
  signal output_reg : std_logic_vector(2*N - 1 downto 0);


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

    AMPLITUDE_OUTPUT_REG: process(clk, a_rst_h, mul_nxn_out, output_reg)
    begin
      if (a_rst_h = '1') then
        output_reg <= (others => '0');+
      elsif (rising_edge(clk)) then
        output_reg <= mul_nxn_out;
      end if;
    end process;

  -- Connect the output
  mul_out <= output_reg;

end architecture;
