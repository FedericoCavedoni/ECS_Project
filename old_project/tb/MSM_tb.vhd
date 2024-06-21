library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MSM_tb is
end MSM_tb;

architecture testbench of MSM_tb is

  -----------------------------------------------------------------------------------------------------
  -- components declaration
  -----------------------------------------------------------------------------------------------------

  component Multi_Standard_Modulator is
    generic (
        N   : integer := 16;  -- Dimensione della frequenza e della fase in ingresso
        A   : integer := 4;   -- Dimensione dell'ampiezza in ingresso
        P   : integer := 7;   -- Dimensione dell'output della LUT
        O   : integer := 16   -- Dimensione dell'output del sistema
    );
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        frequency      : in  std_logic_vector(N-1 downto 0);
        phase          : in  std_logic_vector(N-1 downto 0);
        amplitude      : in  std_logic_vector(A-1 downto 0);
        yq             : out std_logic_vector(O-1 downto 0) 
    );
end component;

  -----------------------------------------------------------------------------------------------------
  -- constants declaration
  -----------------------------------------------------------------------------------------------------

  -- Generic constants for the DUT
  constant N : integer := 16; -- Dimensione della frequenza e della fase in ingresso
  constant A : integer := 4;  -- Dimensione dell'ampiezza in ingresso
  constant P : integer := 7;  -- Dimensione dell'output della LUT
  constant O : integer := 16; -- Dimensione dell'output del sistema

  -- CLK period (f_CLK = 125 MHz)
  constant T_clk : time := 8 ns;

  -- Time before the reset release
  constant T_reset : time := 10 ns;

  -- Number of cycles in the maximum MSM period
  constant MSM_cycles : integer := 4096;

  -- Maximum sine period
  constant T_max_period : time := MSM_cycles * T_clk;

  -----------------------------------------------------------------------------------------------------
  -- signals declaration
  -----------------------------------------------------------------------------------------------------

  -- clk signal (initialized to '0')
  signal clk_tb : std_logic := '0';

  -- Active high asynchronous reset (Active at clock_cycle = 0)
  signal reset_tb : std_logic := '1';

  -- Set to '0' to stop the simulation
  signal run_simulation : std_logic := '1';

  -- inputs frequency word
  signal fw_tb : std_logic_vector(N-1 downto 0) := (others => '0');

  -- input phase
  signal phase_tb : std_logic_vector(N-1 downto 0) := (others => '0');

  -- input amplitude
  signal amplitude_tb : std_logic_vector(A-1 downto 0) := (others => '0');

  -- output signals
  signal msm_out_tb : std_logic_vector(O-1 downto 0);


begin

  -----------------------------------------------------------------------------------------------------
  -- Clock signal generation
  -----------------------------------------------------------------------------------------------------

  clk_tb <= (not(clk_tb) and run_simulation) after T_clk / 2;


  -----------------------------------------------------------------------------------------------------
  -- Instantiate DUT (Device Under Test)
  -----------------------------------------------------------------------------------------------------

  DUT: Multi_Standard_Modulator
    generic map (
        N => N,
        A => A,
        P => P,
        O => O
    )
    port map (
        clk       => clk_tb,
        reset     => reset_tb,

        frequency => fw_tb,
        phase     => phase_tb,
        amplitude => amplitude_tb,
        yq        => msm_out_tb
    );

  -----------------------------------------------------------------------------------------------------
  -- Stimuli process
  -----------------------------------------------------------------------------------------------------

  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;  -- Variable used to count the clock cycle after the reset
  
  begin
    if (rising_edge(clk_tb)) then
      case (clock_cycle) is
        when 10 =>
          reset_tb <= '0';  -- Deactivate reset
          fw_tb    <= (N-1 downto 1 => '0') & '1';    -- frequency word = 1
          phase_tb <= (N-1 downto 1 => '0') & '1';    -- phase = 1
          amplitude_tb <= "0001";                     -- amplitude = 1

        when 30 => 
          fw_tb <= (N-1 downto 2 => '0') & "10";      -- frequency word = 2
          phase_tb <= (N-1 downto 2 => '0') & "10";   -- phase = 2
          amplitude_tb <= "0010";                     -- amplitude = 2

        when 50 =>
          reset_tb <= '1';                            -- Activate reset

        when 70 =>
          reset_tb <= '0';                            -- Deactivate reset

        when 80 => 
          fw_tb <= (N-1 downto 3 => '0') & "100";     -- frequency word = 4
          phase_tb <= (N-1 downto 3 => '0') & "100";  -- phase = 4
          amplitude_tb <= "0100";                     -- amplitude = 4

        when 90 => 
          fw_tb <= (N-1 downto 4 => '0') & "1000";    -- frequency word = 8
          phase_tb <= (N-1 downto 4 => '0') & "1000"; -- phase = 8
          amplitude_tb <= "1000";                     -- amplitude = 8

        when 100 =>
          run_simulation <= '0';                      -- Stop simulation

        when others => null;  -- No action for other cases
      end case;

      clock_cycle := clock_cycle + 1;

    end if;
  end process stimuli;

end architecture testbench;