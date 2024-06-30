library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration for Amplitude_Multiplier
entity Amplitude_Multiplier is
  generic (
    N : natural := 7  -- Generic parameter defining the bit-width of the inputs
  );
  port (
    clk     : in  std_logic;                        -- Clock signal
    a_rst_h : in  std_logic;                        -- Asynchronous reset signal, active high
    a : in  std_logic_vector(N - 1 downto 0);       -- Input signal 'a'
    b : in  std_logic_vector(N - 1 downto 0);       -- Input signal 'b'
    mul_out  : out std_logic_vector(2*N - 1 downto 0)  -- Output signal for the product
  );
end entity;

-- Architecture body for Amplitude_Multiplier
architecture behavior of Amplitude_Multiplier is
  --------------------------------------------------------------
  -- Signals declaration
  --------------------------------------------------------------

  -- Signal to hold the output of the multiplier component
  signal mul_nxn_out : std_logic_vector(2*N - 1 downto 0);
  -- Register to hold the output for synchronous output
  signal output_reg : std_logic_vector(2*N - 1 downto 0);

  --------------------------------------------------------------
  -- Components declaration
  --------------------------------------------------------------

  -- Component declaration for the NxN multiplier
  component multiplier_NxN is
    generic (N : integer := N);  -- Generic parameter for the bit-width

    port (
      A    : in std_logic_vector(N- 1 downto 0);   -- Multiplier input A
      B    : in std_logic_vector(N- 1 downto 0);   -- Multiplier input B
      P    : out std_logic_vector (2*N- 1 downto 0)  -- Product output P
    );
  end component;

begin

  -- Instantiation of the multiplier_NxN component
  MULTIPLIER_N : multiplier_NxN
    generic map (N => N)  -- Mapping the generic parameter
    port map (
        A => a,          -- Connecting input A
        B => b,          -- Connecting input B
        P => mul_nxn_out -- Connecting the output to the signal mul_nxn_out
    );

  -- Process to handle the output register with synchronous reset
  AMPLITUDE_OUTPUT_REG: process(clk, a_rst_h, mul_nxn_out, output_reg)
  begin
    if (a_rst_h = '1') then
      output_reg <= (others => '0');  -- Asynchronous reset to zero
    elsif (rising_edge(clk)) then
      output_reg <= mul_nxn_out;      -- Latch the output of the multiplier on the rising edge of the clock
    end if;
  end process;

  -- Connect the registered output to the output port
  mul_out <= output_reg;

end architecture;
