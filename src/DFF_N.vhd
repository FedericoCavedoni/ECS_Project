library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration for DFF_N
entity DFF_N is
  generic (
    N : natural := 8  -- Generic parameter defining the bit-width of the flip-flop
  );
  port (
    clk     : in std_logic;                        -- Clock signal
    a_rst_h : in std_logic;                        -- Asynchronous reset signal, active high
    en      : in std_logic;                        -- Enable signal
    d       : in std_logic_vector(N - 1 downto 0); -- Data input
    q       : out std_logic_vector(N - 1 downto 0) -- Data output
  );
end entity;

-- Architecture body for DFF_N
architecture struct of DFF_N is
begin

  -- Process to handle the D flip-flop functionality
  ddf_n_proc: process(clk, a_rst_h)
  begin
    if (a_rst_h = '1') then
      q <= (others => '0');  -- Asynchronous reset to zero
    elsif (rising_edge(clk)) then
      if (en = '1') then
        q <= d;  -- Update output q with input d if enabled
      end if;
    end if;
  end process;

end architecture;
