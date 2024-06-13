library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multi_Standard_Modulator is
    generic (
        PHASE_BITS : integer := 16;
        FREQUENCY_BITS : integer := 16;
        AMPLITUDE_BITS   : integer := 4;
        OUTPUT_BITS: integer := 16;
        LUT_SIZE   : integer := 128 --2^7
    );
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        frequency      : in  unsigned(PHASE_BITS-1 downto 0);
        phase          : in  unsigned(PHASE_BITS-1 downto 0);
        amplitude      : in  unsigned(AMP_BITS-1 downto 0);
        mod_out        : out unsigned(OUTPUT_BITS-1 downto 0) 
    );
end Multi_Standard_Modulator;

architecture struct of Multi_Standard_Modulator is
    -------------------------------------------------------------------------------------
-- Internal signals
-------------------------------------------------------------------------------------

  -- Output of of the phase accumulator counter
  signal phase_out : std_logic_vector(11 downto 0);

  -- Output of the LUT table
  signal lut_output : std_logic_vector(5 downto 0);

  -- Output register for the output synchronization
  signal output_reg : std_logic_vector(5 downto 0);


-------------------------------------------------------------------------------------
-- Internal Component
-------------------------------------------------------------------------------------
  component Counter is
    generic ( N : natural := 8 );
    port (
      clk     : in  std_logic;
      a_rst_h : in  std_logic;

      en        : in  std_logic;
      increment : in  std_logic_vector(N - 1 downto 0);
      cntr_out  : out std_logic_vector(N - 1 downto 0)
    );
  end component;

--------------------------------------------------------------------------------------
-- ADDER
-- MULTIPLIER
-- LUT TABLE
--------------------------------------------------------------------------------------

begin

  PHASE_ACCUMULATOR: Counter
    generic map (N => 12)
    port map (
      clk     => clk,
      a_rst_h => reset,

      increment => fw,
      en        => '1',
      cntr_out  => phase_out
    );


-------------------------------------------------------------------------------------
-- ADDER
-- MULTIPLIER
-- LUT TABLE
-------------------------------------------------------------------------------------

  DDFS_OUTPUT_REG: process(clk, reset)
  begin
    if (reset = '1') then
      output_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      output_reg <= lut_output;
    end if;
  end process;

  yq <= output_reg;

end architecture;

end Behavioral;
