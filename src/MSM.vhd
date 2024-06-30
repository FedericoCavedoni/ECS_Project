library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity declaration for MSM
entity MSM is
  generic (
    N : natural := 16; -- Generic parameter for frequency word and phase bit-width
    A : natural := 4;  -- Generic parameter for amplitude bit-width
    P : natural := 7;  -- Generic parameter for LUT output bit-width
    O : natural := 16  -- Generic parameter for output waveform bit-width
  );
  port(
    clk   : in std_logic;  -- Clock signal
    reset : in std_logic;  -- Asynchronous reset, active high

    fw       : in std_logic_vector(N-1 downto 0);  -- Input frequency word
    phase    : in std_logic_vector(N-1 downto 0);  -- Input phase
    amplitude: in std_logic_vector(A-1 downto 0);  -- Input amplitude

    yq : out std_logic_vector(O-1 downto 0)   -- Output waveform
  );
end entity;

-- Architecture body for MSM
architecture behavior of MSM is
-------------------------------------------------------------------------------------
-- Internal signals
-------------------------------------------------------------------------------------

  -- Signal for phase accumulator counter output
  signal counter_out : std_logic_vector(N-1 downto 0);

  -- Signal for LUT output
  signal lut_output : std_logic_vector(P-1 downto 0);

  -- Signal for amplitude extension to match P bit-width
  signal amp_ext : std_logic_vector(P-1 downto 0);

  -- Signal for multiplier output
  signal multiplier_output : std_logic_vector(2*P-1 downto 0);

  -- Signal for extended multiplier output to match O bit-width
  signal mul_ext : std_logic_vector(O-1 downto 0);

  -- Register to synchronize output
  signal output_reg : std_logic_vector(O-1 downto 0);
  
  -- Signal for the phase adder output
  signal signal_out : std_logic_vector(N-1 downto 0);

-------------------------------------------------------------------------------------
-- Internal Components
-------------------------------------------------------------------------------------

-- Component declaration for Counter
component Counter is
  generic ( N : natural := N );
  port (
    clk       : in std_logic;
    a_rst_h   : in std_logic;
    en        : in std_logic;
    increment : in std_logic_vector(N-1 downto 0);
    cntr_out  : out std_logic_vector(N-1 downto 0)
  );
end component;

-- Component declaration for Phase_Adder
component Phase_Adder is
  generic ( N : natural := N );
  port (
    clk        : in std_logic;
    a_rst_h    : in std_logic;
    signal_in  : in std_logic_vector(N-1 downto 0);
    phase_in   : in std_logic_vector(N-1 downto 0);
    signal_out : out std_logic_vector(N-1 downto 0)
  );
end component;

-- Component declaration for lut_table_65536_7bit
component lut_table_65536_7bit is
  generic ( N : natural := N; P : natural := P );
  port (
    address : in std_logic_vector(N-1 downto 0);
    lut_out : out std_logic_vector(P-1 downto 0)
  );
end component;

-- Component declaration for Amplitude_Multiplier
component Amplitude_Multiplier is
  generic ( N : natural := P );
  port (
    clk     : in std_logic;
    a_rst_h : in std_logic;
    a       : in std_logic_vector(N-1 downto 0);
    b       : in std_logic_vector(N-1 downto 0);
    mul_out : out std_logic_vector(2*N-1 downto 0)
  );
end component;

begin

  -- Instantiate the Counter for phase accumulation
  PHASE_ACCUMULATOR: Counter
    generic map (N => N)
    port map (
      clk       => clk,
      a_rst_h   => reset,
      increment => fw,
      en        => '1',
      cntr_out  => counter_out
    );

  -- Instantiate the Phase_Adder to add phase
  PHASE_ADDER_N: Phase_Adder
    generic map (N => N)
    port map(
      clk        => clk,
      a_rst_h    => reset,
      signal_in  => counter_out,
      phase_in   => phase,
      signal_out => signal_out
    );

  -- Instantiate the LUT for lookup table operation
  LUT_65536 : lut_table_65536_7bit
    generic map (N => N, P => P)
    port map(
      address  => signal_out,
      lut_out  => lut_output
    );

  -- Extend amplitude to match LUT output bit-width
  amp_ext <= (P-1 downto A => '0') & amplitude;

  -- Instantiate the Amplitude_Multiplier to modulate the amplitude
  MULTIPLIER_N: Amplitude_Multiplier
    generic map (N => P)
    port map(
      clk       => clk,
      a_rst_h   => reset,
      a         => amp_ext,
      b         => lut_output,
      mul_out   => multiplier_output
    );

  -- Extend the multiplier output to match output bit-width
  mul_ext <= (O-1 downto 2*P => multiplier_output(2*P-1)) & multiplier_output;

  -- Register output for synchronization
  MSM_OUTPUT_REG: process(clk, reset, output_reg, mul_ext)
  begin
    if (reset = '1') then
      output_reg <= (others => '0');  -- Asynchronous reset to zero
    elsif (rising_edge(clk)) then
      output_reg <= mul_ext;  -- Update output register on clock edge
    end if;
  end process;

  -- Assign the registered output to the output port
  yq <= output_reg;

end architecture;
