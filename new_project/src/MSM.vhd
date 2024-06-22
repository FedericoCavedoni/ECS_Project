library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MSM is
  generic (
    N : natural := 12;
    A : natural := 4;
    P : natural := 6;
    O : natural := 12
  );
  port(
    clk   : in std_logic;  -- clock of the system
    reset : in std_logic;  -- Asynchronous reset - active high

    fw : in std_logic_vector(N-1 downto 0);  -- input frequency word
    phase: in std_logic_vector(N-1 downto 0);  -- input phase
    amplitude : in std_logic_vector(A-1 downto 0);  -- input amplitude

    yq : out std_logic_vector(O-1 downto 0)   -- output waveform
  );
end entity;

architecture struct of MSM is
-------------------------------------------------------------------------------------
-- Internal signals
-------------------------------------------------------------------------------------

  -- Output of of the phase accumulator counter
  signal phase_out : std_logic_vector(N-1 downto 0);

  signal adder_out : std_logic_vector(N-1 downto 0);

  -- Output of the LUT table
  signal lut_output : std_logic_vector(P-1 downto 0);

  signal amp_ext : std_logic_vector(P-1 downto 0);

  signal multiplier_output : std_logic_vector(O-1 downto 0);

  signal mul_ext : std_logic_vector(O-1 downto 0);

  -- Output register for the output synchronization
  signal output_reg : std_logic_vector(O-1 downto 0);


-------------------------------------------------------------------------------------
-- Internal Component
-------------------------------------------------------------------------------------
  component Counter is
    generic ( N : natural := N );
    port (
      clk     : in  std_logic;
      a_rst_h : in  std_logic;
      en        : in  std_logic;
      
      increment : in  std_logic_vector(N - 1 downto 0);
      cntr_out  : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component Adder is
    generic ( N : natural := N );
    port (
      clk       : in  std_logic;
      a_rst_h   : in  std_logic;
      en        : in  std_logic;
  
      a : in  std_logic_vector(N-1 downto 0);
      b : in  std_logic_vector(N-1 downto 0);
      adder_out  : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component ddfs_lut_4096_6bit is
    generic ( N : natural := N; P : natural := P );
    port (
      address  : in std_logic_vector(N-1 downto 0);
      ddfs_out : out std_logic_vector(O-1 downto 0)
      );
  end component;

  component Multiplier is
    generic ( N : natural := P );
    port (
      clk       : in  std_logic;
      a_rst_h   : in  std_logic;
      en        : in  std_logic;
  
      a : in  std_logic_vector(N-1 downto 0);
      b : in  std_logic_vector(N-1 downto 0);
      mul_out  : out std_logic_vector(O-1 downto 0)
    );
  end component;

begin

  PHASE_ACCUMULATOR: Counter
    generic map (N => N)
    port map (
      clk     => clk,
      a_rst_h => reset,

      increment => fw,
      en        => '1',
      cntr_out  => phase_out
    );

  PHASE_ADDER: adder
    generic map (N => N)
    port map(
      clk       => clk,
      a_rst_h   => reset,

      en        => '1',
      a         => phase_out,
      b         => phase,
      adder_out => adder_out
    );

  LUT_4096 : ddfs_lut_4096_6bit
    port map(
      address  => adder_out,
      ddfs_out => lut_output
    );

    amp_ext <= "00" & amplitude;

    MULTIPLIER_N: Multiplier
    port map(
      clk       => clk,
      a_rst_h   => reset,
      en        => '1',

      a         => amp_ext,
      b         => lut_output,
      mul_out   => multiplier_output
    );

  -- Necessario dopo
  -- mul_ext <= (others => '0');
  -- mul_ext(P-1 downto 0) <= multiplier_output;

  MSM_OUTPUT_REG: process(clk, reset)
  begin
    if (reset = '1') then
      output_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      --output_reg <= mul_ext;
      output_reg <= multiplier_output;
    end if;
  end process;

  yq <= output_reg;

end architecture;
