library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MSM_tb is
end entity;

architecture testbench of MSM_tb is

  constant N : integer := 16;  -- Width of signal fw and phase
  constant P : integer := 7;   -- Not used in this testbench
  constant A : integer := 4;   -- Width of signal amplitude
  constant O : integer := 16;  -- Width of output signal yq

  component MSM is
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      fw        : in std_logic_vector(N-1 downto 0);
      phase     : in std_logic_vector(N-1 downto 0);
      amplitude : in std_logic_vector(A-1 downto 0);
      yq        : out std_logic_vector(O-1 downto 0)
    );
  end component;

  constant T_clk : time := 8 ns;  -- Clock period
  constant MSM_cycles : integer := 8192;  -- Number of clock cycles for simulation
  constant T_max_period : time := MSM_cycles * T_clk;  -- Total simulation time

  signal clk_tb : std_logic := '0';  -- Testbench clock signal
  signal reset_tb : std_logic := '1';  -- Testbench reset signal
  signal run_simulation : std_logic := '1';  -- Control signal to start/stop simulation
  signal fw_tb : std_logic_vector(N-1 downto 0) := (others => '0');  -- Input signal fw
  signal phase_tb : std_logic_vector(N-1 downto 0) := (others => '0');  -- Input signal phase
  signal amplitude_tb : std_logic_vector(A-1 downto 0) := (others => '0');  -- Input signal amplitude
  signal msm_out_tb : std_logic_vector(O-1 downto 0);  -- Output signal yq

begin

  -- Clock generation process
  clk_tb <= (not(clk_tb) and run_simulation) after T_clk / 2;

  -- Instantiate the MSM module
  DUT: MSM
  port map (
    clk       => clk_tb,
    reset     => reset_tb,
    fw        => fw_tb,
    phase     => phase_tb,
    amplitude => amplitude_tb,
    yq        => msm_out_tb
  );

  -- Stimulus generation process
  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;  -- Clock cycle counter
  begin
    if (rising_edge(clk_tb)) then
      case (clock_cycle) is
        when 1 =>
          reset_tb <= '0';  -- Deassert reset
          fw_tb    <= (N-1 downto 1 => '0') & '1';  -- Set fw to binary 1
          phase_tb <= (N-1 downto 1 => '0') & '0';  -- Set phase to binary 0
          amplitude_tb <= "1000";  -- Set amplitude to binary 1000 (decimal 8)

        when MSM_cycles * 2 =>
          fw_tb <= (N-1 downto 2 => '0') & "10";  -- Modify fw
          phase_tb <= (N-1 downto 1 => '0') & '0';  -- Maintain phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 3 =>
          fw_tb <= (N-1 downto 3 => '0') & "100";  -- Modify fw
          phase_tb <= (N-1 downto 1 => '0') & '0';  -- Maintain phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 4 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= (N-1 downto 1 => '0') & '0';  -- Maintain phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 5 =>
          fw_tb <= (N-1 downto 5 => '0') & "10000";  -- Modify fw
          phase_tb <= (N-1 downto 1 => '0') & '0';  -- Maintain phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 6 =>
          fw_tb <= (N-1 downto 6 => '0') & "100000";  -- Modify fw
          phase_tb <= (N-1 downto 1 => '0') & '0';  -- Maintain phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 7 =>
          reset_tb <= '1';  -- Assert reset

        when MSM_cycles * 8 =>
          reset_tb <= '0';  -- Deassert reset
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= "0000000100000000";  -- Set phase to specific value
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 9 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= "1000000000000000";  -- Modify phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 10 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= "0000000100000000";  -- Modify phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 11 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= "0000000000000000";  -- Modify phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 12 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= "1000000000000000";  -- Modify phase
          amplitude_tb <= "1000";  -- Maintain amplitude

        when MSM_cycles * 13 =>
          reset_tb <= '1';  -- Assert reset

        when MSM_cycles * 14 =>
          reset_tb <= '0';  -- Deassert reset
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= (N-1 downto 2 => '0') & "00";  -- Set phase to specific value
          amplitude_tb <= "0001";  -- Modify amplitude

        when MSM_cycles * 15 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= (N-1 downto 2 => '0') & "00";  -- Modify phase
          amplitude_tb <= "0010";  -- Modify amplitude

        when MSM_cycles * 16 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= (N-1 downto 2 => '0') & "00";  -- Modify phase
          amplitude_tb <= "0100";  -- Modify amplitude

        when MSM_cycles * 17 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= (N-1 downto 2 => '0') & "00";  -- Modify phase
          amplitude_tb <= "1000";  -- Modify amplitude

        when MSM_cycles * 18 =>
          reset_tb <= '1';  -- Assert reset

        when MSM_cycles * 19 =>
          reset_tb <= '0';  -- Deassert reset
          fw_tb <= (N-1 downto 4 => '0') & "1000";  -- Modify fw
          phase_tb <= (N-1 downto 2 => '0') & "00";  -- Set phase to specific value
          amplitude_tb <= "1000";  -- Modify amplitude

        when MSM_cycles * 24 =>
          run_simulation <= '0';  -- End simulation by setting run_simulation to '0'

        when others =>
          null;  -- Do nothing for other clock cycles

      end case;

      clock_cycle := clock_cycle + 1;  -- Increment clock cycle counter
    end if;
  end process;

end architecture;
