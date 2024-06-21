library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DDFS_tb is
end entity;

architecture testbench of DDFS_tb is

  -----------------------------------------------------------------------------------------------------
  -- components declaration
  -----------------------------------------------------------------------------------------------------
  component DDFS is
    port (
      clk   : in std_logic;
      reset : in std_logic;

      fw : in std_logic_vector(11 downto 0);
      yq : out std_logic_vector(5 downto 0)
    );
  end component;

  -----------------------------------------------------------------------------------------------------
  -- constants declaration
  -----------------------------------------------------------------------------------------------------

  -- CLK period (f_CLK = 125 MHz)
  constant T_clk : time := 8 ns;

  -- Time before the reset release
  constant T_reset : time := 10 ns;

  -- Number of cycles in the maximum DDFS period
  constant DDFS_cycles : integer := 4096;

  -- Maximum sine period
  constant T_max_period : time := DDFS_cycles * T_clk;

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
  signal fw_tb : std_logic_vector(11 downto 0) := (others => '0');

  signal phase_tb : std_logic_vector(11 downto 0) := (others => '0');

  signal amplitude_tb : std_logic_vector(3 downto 0) := (others => '0');

  -- output signals (the declaration is useful to make it visible without observing the ddfs component)
  signal ddfs_out_tb : std_logic_vector(5 downto 0);

begin

  -- clk signal
  clk_tb <= (not(clk_tb) and run_simulation) after T_clk / 2;

  DUT: DDFS
  port map (
    clk   => clk_tb,
    reset => reset_tb,

    fw => fw_tb,
    phase => phase_tb,
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
          phase_tb <= (11 downto 1 => '0') & '1'; -- phase = 1
          amplitude_tb <= "0001"; -- amplitude = 1

        when DDFS_cycles *  4 => 
          fw_tb <= (11 downto 2 => '0') & "10"; -- frequency word = 2
          phase_tb <= (11 downto 2 => '0') & "10"; -- phase = 2
          amplitude_tb <= "0010"; -- amplitude = 2

        when DDFS_cycles *  6 => reset_tb <= '1';

        when DDFS_cycles *  7 => reset_tb <= '0';

        when DDFS_cycles *  8 => 
          fw_tb <= (11 downto 3 => '0') & "100"; -- frequency word = 4
          phase_tb <= (11 downto 3 => '0') & "100"; -- phase = 4
          amplitude_tb <= "0100"; -- amplitude = 4

        when DDFS_cycles *  9 => 
          fw_tb <= (11 downto 4 => '0') & "1000"; -- frequency word = 8
          phase_tb <= (11 downto 4 => '0') & "1000"; -- phase = 8
          amplitude_tb <= "1000"; -- amplitude = 8

        when DDFS_cycles * 10 => run_simulation <= '0';

        when others => null;  -- Specifying that nothing happens in the other cases

      end case;

      -- the variable is updated exactly here
      --   -> try to move this statement before "case (clock_cycle) is" and watch the difference in the simulation
      clock_cycle := clock_cycle + 1;
    end if;
  end process;

end architecture;
