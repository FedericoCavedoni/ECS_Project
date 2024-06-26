library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MSM_QLUT is
  generic (
    N : natural := 16;
    A : natural := 4;
    P : natural := 7;
    O : natural := 16
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

architecture behavior of MSM_QLUT is
-------------------------------------------------------------------------------------
-- Internal signals
-------------------------------------------------------------------------------------

  -- Output of of the phase accumulator counter
  signal counter_out : std_logic_vector(N-1 downto 0);

  -- Output of the LUT table
  signal lut_output : std_logic_vector(P-1 downto 0);

  signal amp_ext : std_logic_vector(P-1 downto 0);

  signal multiplier_output : std_logic_vector(2*P-1 downto 0);

  signal mul_ext : std_logic_vector(O-1 downto 0);

  -- Output register for the output synchronization
  signal output_reg : std_logic_vector(O-1 downto 0);
  
  signal signal_out : std_logic_vector(N-1 downto 0);

  signal lut_address : std_logic_vector(N-3 downto 0);

  signal lut_output_muxed : std_logic_vector(P-1 downto 0);


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

component Phase_Adder is
  generic ( N : natural := N );
  port (
    signal_in : in  STD_LOGIC_VECTOR (N-1 downto 0); 
    phase_in  : in  STD_LOGIC_VECTOR (N-1 downto 0); 
    signal_out : out STD_LOGIC_VECTOR (N-1 downto 0) 
  );
end component;

component lut_table_16384_7bit is
  generic ( N : natural := N-2; P : natural := P );
  port (
    address  : in std_logic_vector(N-1 downto 0);
    lut_out  : out std_logic_vector(P-1 downto 0)
    );
  end component;

component Multiplier is
  generic ( N : natural := P );
  port (
    a : in  std_logic_vector(N-1 downto 0);
    b : in  std_logic_vector(N-1 downto 0);
    mul_out  : out std_logic_vector(2*N-1 downto 0)
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
      cntr_out  => counter_out
    );

  PHASE_ADDER_N: Phase_Adder
    generic map (N => N)
    port map(
      signal_in     => counter_out,
      phase_in    => phase,
      signal_out => signal_out
    );

    lut_address <= signal_out(N-3 downto 0) when (signal_out(N-2) = '0') else not(signal_out(N-3 downto 0));

  LUT_16384 : lut_table_16384_7bit
    generic map (N => N-2, P => P)
    port map(
      address  => lut_address,
      lut_out => lut_output
    );

    lut_output_muxed <= lut_output when (signal_out(N-1) = '0') else not(lut_output);

    amp_ext <= (P-1 downto A => '0') & amplitude;

    MULTIPLIER_N: Multiplier
      generic map (N => P)
      port map(
        a         => amp_ext,
        b         => lut_output_muxed,
        mul_out   => multiplier_output
      );

  mul_ext <= (O-1 downto 2*P => multiplier_output(2*P-1)) & multiplier_output;

  MSM_QLUT_OUTPUT_REG: process(clk, reset)
  begin
    if (reset = '1') then
      output_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      output_reg <= mul_ext;
    end if;
  end process;

  yq <= output_reg;

end architecture;

  