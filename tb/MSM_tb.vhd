library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MSM_tb is
end entity;

architecture testbench of MSM_tb is

  constant N : integer := 16;   -- Width of frequency word and phase
  constant P : integer := 7;    -- Width of the LUT output 
  constant A : integer := 4;    -- Width of amplitude 
  constant O : integer := 16;   -- Width of output signal

  component MSM is
    port (
      clk   : in std_logic;                          -- Clock input
      reset : in std_logic;                          -- Reset input
      fw    : in std_logic_vector(N-1 downto 0);     -- Frequency word input
      phase : in std_logic_vector(N-1 downto 0);     -- Phase input
      amplitude : in std_logic_vector(A-1 downto 0); -- Amplitude input
      yq    : out std_logic_vector(O-1 downto 0)     -- Output signal
    );
  end component;

  constant T_clk : time := 8 ns;                        -- Clock period
  constant MSM_cycles : integer := 8192;                -- Maximum number of cycles for MSM
  constant T_max_period : time := MSM_cycles * T_clk;   -- Maximum period for MSM

  signal clk_tb : std_logic := '0';             -- Testbench clock signal
  signal reset_tb : std_logic := '1';           -- Testbench reset signal
  signal run_simulation : std_logic := '1';     -- Signal to control simulation termination
  signal fw_tb : std_logic_vector(N-1 downto 0) := (others => '0');   -- Testbench frequency word
  signal phase_tb : std_logic_vector(N-1 downto 0) := (others => '0'); -- Testbench phase
  signal amplitude_tb : std_logic_vector(A-1 downto 0) := (others => '0'); -- Testbench amplitude
  signal msm_out_tb : std_logic_vector(O-1 downto 0);  -- Testbench output signal

begin

  -- Generate clock signal for simulation
  clk_tb <= (not(clk_tb) and run_simulation) after T_clk / 2;

  -- Instantiate the MSM component
  DUT: MSM
  port map (
    clk   => clk_tb,
    reset => reset_tb,
    fw    => fw_tb,
    phase => phase_tb,
    amplitude => amplitude_tb,
    yq    => msm_out_tb
  );

  -- Process to generate stimuli for MSM component
  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;  -- Clock cycle counter
  begin
    if (rising_edge(clk_tb)) then
      case (clock_cycle) is
        when 1 =>
          reset_tb <= '0';                                -- Release reset
          fw_tb    <= (N-1 downto 1 => '0') & '1';        -- Set frequency word = 1
          phase_tb <= (N-1 downto 1 => '0') & '1';        -- Set phase = 1
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 2 =>
          fw_tb <= (N-1 downto 2 => '0') & "10";          -- Set frequency word = 2
          phase_tb <= (N-1 downto 1 => '0') & '1';        -- Set phase = 2
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 3 =>
          fw_tb <= (N-1 downto 3 => '0') & "100";         -- Set frequency word = 4
          phase_tb <= (N-1 downto 1 => '0') & '1';        -- Set phase = 4
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 4 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 8
          phase_tb <= (N-1 downto 1 => '0') & '1';        -- Set phase = 8
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 5 =>
          fw_tb <= (N-1 downto 5 => '0') & "10000";       -- Set frequency word = 16
          phase_tb <= (N-1 downto 1 => '0') & '1';        -- Set phase = 16
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 6 =>
          fw_tb <= (N-1 downto 6 => '0') & "100000";      -- Set frequency word = 32
          phase_tb <= (N-1 downto 1 => '0') & '1';        -- Set phase = 32
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 7 =>
          reset_tb <= '1';                                -- Activate reset

        when MSM_cycles * 8 =>
          reset_tb <= '0';                                -- Deactivate reset
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 64
          phase_tb <= (N-1 downto 2 => '0') & "10";       -- Set phase = 64
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 9 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 128
          phase_tb <= (N-1 downto 3 => '0') & "100";      -- Set phase = 128
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 10 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 256
          phase_tb <= (N-1 downto 4 => '0') & "1000";     -- Set phase = 256
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 11 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 512
          phase_tb <= (N-1 downto 5 => '0') & "10000";    -- Set phase = 512
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 12 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 1024
          phase_tb <= (N-1 downto 6 => '0') & "100000";   -- Set phase = 1024
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 13 =>
          reset_tb <= '1';                                -- Activate reset

        when MSM_cycles * 14 =>
          reset_tb <= '0';                                -- Deactivate reset
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 2048
          phase_tb <= (N-1 downto 4 => '0') & "1000";     -- Set phase = 2048
          amplitude_tb <= "0001";                         -- Set amplitude = 1

        when MSM_cycles * 15 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 2048
          phase_tb <= (N-1 downto 4 => '0') & "1000";     -- Set phase = 2048
          amplitude_tb <= "0010";                         -- Set amplitude = 2

        when MSM_cycles * 16 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 2048
          phase_tb <= (N-1 downto 4 => '0') & "1000";     -- Set phase = 2048
          amplitude_tb <= "0100";                         -- Set amplitude = 4

        when MSM_cycles * 17 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";        -- Set frequency word = 2048
          phase_tb <= (N-1 downto 4 => '0') & "1000";     -- Set phase = 2048
          amplitude_tb <= "1000";                         -- Set amplitude = 8

        when MSM_cycles * 18 =>
          run_simulation <= '0';                          -- End simulation

        when others =>
          null;                                          -- No operation for other cycles
      end case;

      clock_cycle := clock_cycle + 1;                     -- Increment clock cycle counter
    end if;
  end process;

end architecture;
