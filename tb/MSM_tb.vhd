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
    end component Multi_Standard_Modulator;

  -----------------------------------------------------------------------------------------------------
  -- constants declaration
  -----------------------------------------------------------------------------------------------------

  -- CLK period (f_CLK = 125 MHz)
  constant T_clk : time := 8 ns;

  -- Time before the reset release
  constant T_reset : time := 10 ns;

  -- Number of cycles in the maximum MSM period
  constant MSM_cycles : integer := 4096;

  -- Maximum sine period
  constant T_max_period : time := DDFS_cycles * T_clk;

  -----------------------------------------------------------------------------------------------------
  -- signals declaration
  -----------------------------------------------------------------------------------------------------

  -- clk signal (initialized to '0')
  signal clk_tb : std_logic := '0';

  -- Active high asynchronous reset (Active at clock_cycle = 0)
  signal reset_tb : std_logic := '1';

  -- inputs frequency word
  signal fw_tb : std_logic_vector(N-1 downto 0) := (others => '0');

  -- input phase
  signal phase_tb : std_logic_vector(N-1 downto 0) := (others => '0');

  -- input amplitude
  signal amplitude_tb : std_logic_vector(A-1 downto 0) := (others => '0');

  -- output signals (the declaration is useful to make it visible without observing the ddfs component)
  signal msm_out_tb : std_logic_vector(O-1 downto 0);

  -- Set to '0' to stop the simulation
  signal run_simulation : std_logic := '1';

begin

  -- clk signal
  clk_tb <= (not(clk_tb) and run_simulation) after T_clk / 2;

  DUT: MSM
    generic map (
        N => 16,
        A => 4,
        P => 7,
        O => 16
    )
  port map (
    clk   => clk_tb,
    reset => reset_tb,
    frequency => fw_tb,
    phase     => phase_tb,
    amplitude => amplitude_tb,
    yq => ddfs_out_tb
  );

  -- process used to make the testbench signals change synchronously with the rising edge of the clock
  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;  -- variable used to count the clock cycle after the reset
  begin
    if (rising_edge(clk_tb)) then
      case (clock_cycle) is
        when 1 =>
          reset_tb <= '0';
          fw_tb    <= (11 downto 1 => '0') & '1'; -- frequency word = 1

        when DDFS_cycles *  4 => fw_tb <= (11 downto 2 => '0') & "10"; -- frequency word = 2
                                       -- (1 => '1', others => '0')

        when DDFS_cycles *  6 => reset_tb <= '1';

        when DDFS_cycles *  7 => reset_tb <= '0';

        when DDFS_cycles *  8 => fw_tb <= (11 downto 3 => '0') & "100"; -- frequency word = 4
                                       -- (2 => '1', others => '0')

        when DDFS_cycles *  9 => fw_tb <= (11 downto 4 => '0') & "1000"; -- frequency word = 8
                                       -- (3 => '1', others => '0')

        when DDFS_cycles * 10 => run_simulation <= '0';

        when others => null;  -- Specifying that nothing happens in the other cases

      end case;

      -- the variable is updated exactly here
      --   -> try to move this statement before "case (clock_cycle) is" and watch the difference in the simulation
      clock_cycle := clock_cycle + 1;
    end if;
  end process;

end architecture;
