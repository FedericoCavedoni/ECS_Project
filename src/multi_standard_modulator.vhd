library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------------
-- TODO
-- Valutare casi sincroni e asincroni
-------------------------------------------------------------------------------------

entity Multi_Standard_Modulator is
    generic (
        N   : integer := 16;
        A   : integer := 4;
        O   : integer := 16;
        P   : integer := 16;
    );
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        frequency      : in  unsigned(N-1 downto 0);
        phase          : in  unsigned(N-1 downto 0);
        amplitude      : in  unsigned(A-1 downto 0);
        yq             : out unsigned(O-1 downto 0) 
    );
end Multi_Standard_Modulator;

architecture struct of Multi_Standard_Modulator is
    -------------------------------------------------------------------------------------
-- Internal signals
-------------------------------------------------------------------------------------

  -- Output of the frequency word calculator
  signal frequency_word : std_logic_vector(N-1 downto 0);

  -- Output of of the phase accumulator counter
  signal counter_out : std_logic_vector(N-1 downto 0);

  -- Output of the adder
  signal adder_output : std_logic_vector(N-1 downto 0);

  -- Output of the LUT table
  signal lut_output : std_logic_vector(O-1 downto 0);

  -- Output of the multiplier
  signal multiplier_output : std_logic_vector(N-1 downto 0);

  -- Output register for the output synchronization
  signal output_reg : std_logic_vector(O-1 downto 0);
  


-------------------------------------------------------------------------------------
-- Internal Component
-------------------------------------------------------------------------------------

component FrequencyWordCalculator is
  Port (
      freq_in : in  STD_LOGIC_VECTOR (N-1 downto 0); 
      freq_word : out STD_LOGIC_VECTOR ((N-1) downto 0) 
  );
end component;


component Counter is
    generic ( N : natural := N );
    port (
      clk     : in  std_logic;
      a_rst_h : in  std_logic;

      en        : in  std_logic;
      increment : in  std_logic_vector(N-1 downto 0);
      cntr_out  : out std_logic_vector(N-1 downto 0)
    );
  end component;


  component Ripple_Carry_Adder is
    generic (
      Nbit : integer := N
    );
    port (
      a    : in std_logic_vector(Nbit - 1 downto 0);
      b    : in std_logic_vector(Nbit - 1 downto 0);
      cin  : in std_logic;
      s    : out std_logic_vector (Nbit - 1 downto 0);
      cout : out std_logic
    );
  end component;


  component ddfs_lut_65536_16bit is
    port (
      address  : in std_logic_vector(N downto 0);
      ddfs_out : out std_logic_vector(P downto 0)
      );
  end component;

  
  component Multiplier is
    generic (
        N1   : integer := P;
        N2  : integer := A;
        O   : integer := O;
    );
    Port (
        clk : in std_logic;   
        rst : in std_logic;

        A : in STD_LOGIC_VECTOR (N1-1 downto 0);  
        B : in STD_LOGIC_VECTOR (N2-1 downto 0); 
        P : out STD_LOGIC_VECTOR (O-1 downto 0) 
    );
  end component;

begin
  FWCALCULATOR: FrequencyWordCalculator 
    generic map (N => N)
    port map(
      freq_in => frequency,
      freq_word => frequency_word
    );


  PHASE_ACCUMULATOR: Counter
    generic map (N => N)
    port map (
      clk     => clk,
      a_rst_h => reset,

      increment => frequency,
      en        => '1',
      cntr_out  => counter_out
    );


  ADDER: Ripple_Carry_Adder
    generic map (Nbit => N)
    port map (
      clk     => clk,
      a_rst_h => reset,

      a    => counter_out,
      b    => phase,
      cin  => '0',
      s    => adder_output,
      cout => open
    );


  LUT_65536 : ddfs_lut_65536_16bit
    port map(
      address  => adder_output,
      ddfs_out => lut_output
    );


  MULTIPLIER: Multiplier
    generic map (N => N)
    port map (
      clk => clk,
      rst => reset,

      a => lut_output,
      b => amplitude,
      result => multiplier_output
    );


  DDFS_OUTPUT_REG: process(clk, reset)
  begin
    if (reset = '1') then
      output_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      output_reg <= multiplier_output;
    end if;
  end process;

  yq <= output_reg;

end architecture;

end Behavioral;
