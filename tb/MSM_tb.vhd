library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MSM_tb is
end entity;

architecture testbench of MSM_tb is

  constant N : integer := 16;
  constant P : integer := 7;
  constant A : integer := 4;
  constant O : integer := 16;

  -----------------------------------------------------------------------------------------------------
  -- components declaration
  -----------------------------------------------------------------------------------------------------
  component MSM is
    port (
      clk   : in std_logic;
      reset : in std_logic;
      fw    : in std_logic_vector(N-1 downto 0);  -- input frequency word
      phase : in std_logic_vector(N-1 downto 0);  -- input phase
      amplitude : in std_logic_vector(A-1 downto 0);  -- input amplitude
      yq    : out std_logic_vector(O-1 downto 0)
    );
  end component;

  -----------------------------------------------------------------------------------------------------
  -- constants declaration
  -----------------------------------------------------------------------------------------------------

  -- CLK period (f_CLK = 125 MHz)
  constant T_clk : time := 8 ns;

  -- Number of cycles in the maximum MSM period
  constant MSM_cycles : integer := 8192;

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

  signal phase_tb : std_logic_vector(N-1 downto 0) := (others => '0');

  signal amplitude_tb : std_logic_vector(A-1 downto 0) := (others => '0');

  -- output signals (the declaration is useful to make it visible without observing the MSM component)
  signal msm_out_tb : std_logic_vector(O-1 downto 0);

begin

  -- clk signal
  clk_tb <= (not(clk_tb) and run_simulation) after T_clk / 2;

  DUT: MSM
  port map (
    clk   => clk_tb,
    reset => reset_tb,
    fw    => fw_tb,
    phase => phase_tb,
    amplitude => amplitude_tb,
    yq    => msm_out_tb
  );

  -- process used to make the testbench signals change synchronously with the rising edge of the clock
  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;  -- variable used to count the clock cycle after the reset
  begin
    if (rising_edge(clk_tb)) then
      case (clock_cycle) is
        when 1 =>
          reset_tb <= '0';  -- Release reset
          fw_tb    <= (N-1 downto 1 => '0') & '1'; -- frequency word = 1
          phase_tb <= (N-1 downto 1 => '0') & '1'; -- phase = 1
          amplitude_tb <= "0001"; -- amplitude = 1

        -- Add more diverse test cases
        when MSM_cycles * 2 =>
          fw_tb <= (N-1 downto 2 => '0') & "10"; -- frequency word = 2
          phase_tb <= (N-1 downto 2 => '0') & "10"; -- phase = 2
          amplitude_tb <= "0010"; -- amplitude = 2

        when MSM_cycles * 3 =>
          fw_tb <= (N-1 downto 3 => '0') & "100"; -- frequency word = 4
          phase_tb <= (N-1 downto 3 => '0') & "100"; -- phase = 4
          amplitude_tb <= "0100"; -- amplitude = 4

        when MSM_cycles * 4 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000"; -- frequency word = 8
          phase_tb <= (N-1 downto 4 => '0') & "1000"; -- phase = 8
          amplitude_tb <= "1000"; -- amplitude = 8

        when MSM_cycles * 5 =>
          fw_tb <= (N-1 downto 5 => '0') & "10000"; -- frequency word = 16
          phase_tb <= (N-1 downto 5 => '0') & "10000"; -- phase = 16
          amplitude_tb <= "0001"; -- amplitude = 1

        when MSM_cycles * 6 =>
          fw_tb <= (N-1 downto 6 => '0') & "100000"; -- frequency word = 32
          phase_tb <= (N-1 downto 6 => '0') & "100000"; -- phase = 32
          amplitude_tb <= "0010"; -- amplitude = 2

        when MSM_cycles * 7 =>
          fw_tb <= (N-1 downto 7 => '0') & "1000000"; -- frequency word = 64
          phase_tb <= (N-1 downto 7 => '0') & "1000000"; -- phase = 64
          amplitude_tb <= "0100"; -- amplitude = 4

        when MSM_cycles * 8 =>
          fw_tb <= (N-1 downto 8 => '0') & "10000000"; -- frequency word = 128
          phase_tb <= (N-1 downto 8 => '0') & "10000000"; -- phase = 128
          amplitude_tb <= "1000"; -- amplitude = 8

        when MSM_cycles * 9 =>
          fw_tb <= (N-1 downto 9 => '0') & "100000000"; -- frequency word = 256
          phase_tb <= (N-1 downto 9 => '0') & "100000000"; -- phase = 256
          amplitude_tb <= "0001"; -- amplitude = 1

        when MSM_cycles * 10 =>
          fw_tb <= (N-1 downto 10 => '0') & "1000000000"; -- frequency word = 512
          phase_tb <= (N-1 downto 10 => '0') & "1000000000"; -- phase = 512
          amplitude_tb <= "0010"; -- amplitude = 2

        when MSM_cycles * 11 =>
          fw_tb <= (N-1 downto 11 => '0') & "10000000000"; -- frequency word = 1024
          phase_tb <= (N-1 downto 11 => '0') & "10000000000"; -- phase = 1024
          amplitude_tb <= "0100"; -- amplitude = 4

        when MSM_cycles * 12 =>
          fw_tb <= (N-1 downto 12 => '0') & "100000000000"; -- frequency word = 2048
          phase_tb <= (N-1 downto 12 => '0') & "100000000000"; -- phase = 2048
          amplitude_tb <= "1000"; -- amplitude = 8

        when MSM_cycles * 13 =>
          reset_tb <= '1';  -- Activate reset
          
        when MSM_cycles * 14 =>
          reset_tb <= '0';  -- Deactivate reset
          fw_tb <= (others => '0'); -- Reset inputs

        when MSM_cycles * 15 =>
          fw_tb <= (others => '1'); -- frequency word = all 1s
          phase_tb <= (others => '1'); -- phase = all 1s
          amplitude_tb <= (others => '1'); -- amplitude = all 1s

        when MSM_cycles * 16 =>
          run_simulation <= '0';  -- End simulation

        when others =>
          null;  -- No operation for other cycles
      end case;

      clock_cycle := clock_cycle + 1;
    end if;
  end process;

end architecture;
