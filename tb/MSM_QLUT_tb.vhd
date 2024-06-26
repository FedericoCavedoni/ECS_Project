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

  constant T_clk : time := 8 ns;
  constant MSM_cycles : integer := 8192;
  constant T_max_period : time := MSM_cycles * T_clk;

  signal clk_tb : std_logic := '0';
  signal reset_tb : std_logic := '1';
  signal run_simulation : std_logic := '1';
  signal fw_tb : std_logic_vector(N-1 downto 0) := (others => '0');
  signal phase_tb : std_logic_vector(N-1 downto 0) := (others => '0');
  signal amplitude_tb : std_logic_vector(A-1 downto 0) := (others => '0');

  signal msm_out_tb : std_logic_vector(O-1 downto 0);
  signal msm_qlut_out_tb : std_logic_vector(O-1 downto 0);

  signal diff : std_logic := '0';

begin

  clk_tb <= (not(clk_tb) and run_simulation) after T_clk / 2;

  DUT: MSM
  port map (
    clk       => clk_tb,
    reset     => reset_tb,
    fw        => fw_tb,
    phase     => phase_tb,
    amplitude => amplitude_tb,
    yq        => msm_out_tb
  );

  DUT_QLUT: MSM_QLUT
  port map (
    clk       => clk_tb,
    reset     => reset_tb,
    fw        => fw_tb,
    phase     => phase_tb,
    amplitude => amplitude_tb,
    yq        => msm_qlut_out_tb
  );

  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;
  begin
    if (rising_edge(clk_tb)) then
      case (clock_cycle) is
        when 1 =>
          reset_tb <= '0';
          fw_tb    <= (N-1 downto 1 => '0') & '1';
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 2 =>
          fw_tb <= (N-1 downto 2 => '0') & "10";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 3 =>
          fw_tb <= (N-1 downto 3 => '0') & "100";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 4 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 5 =>
          fw_tb <= (N-1 downto 5 => '0') & "10000";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 6 =>
          fw_tb <= (N-1 downto 6 => '0') & "100000";
          phase_tb <= (N-1 downto 1 => '0') & '0';
          amplitude_tb <= "1000";

        when MSM_cycles * 7 =>
          reset_tb <= '1';

        when MSM_cycles * 8 =>
          reset_tb <= '0';
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "0000000100000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 9 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "1000000000000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 10 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "0000000100000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 11 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "0000000000000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 12 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= "1000000000000000"; 
          amplitude_tb <= "1000";

        when MSM_cycles * 13 =>
          reset_tb <= '1';

        when MSM_cycles * 14 =>
          reset_tb <= '0';
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "0001";

        when MSM_cycles * 15 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "0010";

        when MSM_cycles * 16 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "0100";

        when MSM_cycles * 17 =>
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "1000";

        when MSM_cycles * 18 =>
          reset_tb <= '1';

        when MSM_cycles * 19 =>
          reset_tb <= '0';
          fw_tb <= (N-1 downto 4 => '0') & "1000";
          phase_tb <= (N-1 downto 2 => '0') & "00";
          amplitude_tb <= "1000";

        when MSM_cycles * 24 =>
          run_simulation <= '0';

        when others =>
          null;
      end case;

      clock_cycle := clock_cycle + 1;
    end if;
  end process;

  diff <= '1' when msm_out_tb /= msm_qlut_out_tb else '0';

end architecture;
