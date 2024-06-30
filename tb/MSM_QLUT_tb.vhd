library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MSM_qlut_tb is
end entity;

architecture testbench of MSM_qlut_tb is

  constant N : integer := 16;   -- Width of fw and phase
  constant P : integer := 7;    -- Width of lut_out (assuming, not explicitly used here)
  constant A : integer := 4;    -- Width of amplitude
  constant O : integer := 16;   -- Width of yq

  -- Component declarations
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

  component MSM_QLUT is
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      fw        : in std_logic_vector(N-1 downto 0);
      phase     : in std_logic_vector(N-1 downto 0);
      amplitude : in std_logic_vector(A-1 downto 0);
      yq        : out std_logic_vector(O-1 downto 0)
    );
  end component;

  constant T_clk : time := 8 ns;                   -- Clock period
  constant MSM_cycles : integer := 8192;           -- Number of cycles for MSM processing
  constant T_max_period : time := MSM_cycles * T_clk;  -- Maximum simulation time

  signal clk_tb : std_logic := '0';                -- Testbench clock signal
  signal reset_tb : std_logic := '1';             -- Reset signal for MSM
  signal run_simulation : std_logic := '1';        -- Signal to control simulation running
  signal fw_tb : std_logic_vector(N-1 downto 0) := (others => '0');  -- Frequency word signal
  signal phase_tb : std_logic_vector(N-1 downto 0) := (others => '0');  -- Phase input signal
  signal amplitude_tb : std_logic_vector(A-1 downto 0) := (others => '0');  -- Amplitude input signal

  signal msm_out_tb : std_logic_vector(O-1 downto 0);       -- Output from MSM component
  signal msm_qlut_out_tb : std_logic_vector(O-1 downto 0);  -- Output from MSM_QLUT component

  signal diff : std_logic := '0';  -- Signal to indicate difference between msm_out_tb and msm_qlut_out_tb

begin

  -- Clock generation process
  clk_tb <= (not clk_tb and run_simulation) after T_clk / 2;

  -- Instantiate MSM component
  DUT: MSM
  port map (
    clk       => clk_tb,
    reset     => reset_tb,
    fw        => fw_tb,
    phase     => phase_tb,
    amplitude => amplitude_tb,
    yq        => msm_out_tb
  );

  -- Instantiate MSM_QLUT component
  DUT_QLUT: MSM_QLUT
  port map (
    clk       => clk_tb,
    reset     => reset_tb,
    fw        => fw_tb,
    phase     => phase_tb,
    amplitude => amplitude_tb,
    yq        => msm_qlut_out_tb
  );

  -- Stimulus generation process
  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;  -- Counter for clock cycles
  begin
    if (rising_edge(clk_tb)) then
      case clock_cycle is
        when 1 =>
          -- First test case
          reset_tb <= '0';               -- Assert reset for MSM and MSM_QLUT
          fw_tb    <= (N-1 downto 1 => '0') & '1';  -- Set frequency word
          phase_tb <= (N-1 downto 1 => '0') & '0';  -- Set phase
          amplitude_tb <= "1000";        -- Set amplitude

        when MSM_cycles * 2 =>
          -- Second test case
          fw_tb <= (N-1 downto 2 => '0') & "10";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 3 =>
          -- Third test case
          fw_tb <= (N-1 downto 3 => '0') & "100";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 4 =>
          -- Fourth test case
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 5 =>
          -- Fifth test case
          fw_tb <= (N-1 downto 5 => '0') & "10000";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 6 =>
          -- Sixth test case
          fw_tb <= (N-1 downto 6 => '0') & "100000";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 7 =>
          -- Reset for next phase of testing
          reset_tb <= '1';

        when MSM_cycles * 8 =>
          -- Eighth test case
          reset_tb <= '0';
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "0000000100000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 9 =>
          -- Ninth test case
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "1000000000000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 10 =>
          -- Tenth test case
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "0000000100000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 11 =>
          -- Eleventh test case
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "0000000000000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 12 =>
          -- Twelfth test case
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "1000000000000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 13 =>
          -- Reset for next phase of testing
          reset_tb <= '1';

        when MSM_cycles * 14 =>
          -- Fourteenth test case
          reset_tb <= '0';
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "0001";

        when MSM_cycles * 15 =>
          -- Fifteenth test case
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "0010";

        when MSM_cycles * 16 =>
          -- Sixteenth test case
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "0100";

        when MSM_cycles * 17 =>
          -- Seventeenth test case
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "1000";

        when MSM_cycles * 18 =>
          -- Reset for next phase of testing
          reset_tb <= '1';

        when MSM_cycles * 19 =>
          -- Nineteenth test case
          reset_tb <= '0';
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "1000";

        when MSM_cycles * 24 =>
          -- End simulation
          run_simulation <= '0';

        when others =>
          null;

      end case;

      clock_cycle := clock_cycle + 1;  -- Increment clock cycle counter
    end if;
  end process stimuli;

  -- Compare outputs of MSM and MSM_QLUT
  diff <= '1' when msm_out_tb /= msm_qlut_out_tb else '0';

end architecture;
