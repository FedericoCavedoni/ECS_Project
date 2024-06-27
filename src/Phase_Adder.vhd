library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Phase_Adder is
  generic (N : integer := 16); -- Dimensione del segnale in bit
    Port (
        signal_in : in  std_logic_vector (N-1 downto 0); -- Input segnale a N bit (std_logic_vector)
        phase_in  : in  std_logic_vector (N-1 downto 0); -- Input fase a N bit (std_logic_vector)
        signal_out : out std_logic_vector (N-1 downto 0) -- Output segnale modulato (std_logic_vector)
    );
end Phase_Adder;

architecture Behavioral of Phase_Adder is
    signal adder_out : std_logic_vector(N-1 downto 0);

    component ripple_carry_adder is
        generic (Nbit : integer := N);
    
        port (
          a    : in std_logic_vector(Nbit - 1 downto 0);
          b    : in std_logic_vector(Nbit - 1 downto 0);
          cin  : in std_logic;
          s    : out std_logic_vector (Nbit - 1 downto 0);
          cout : out std_logic
        );
      end component;
begin

    FULL_ADDER_N_MAP : ripple_carry_adder
    generic map (Nbit => N)
    port map (
      a    => signal_in,
      b    => phase_in,
      cin  => '0',
      s    => adder_out,
      cout => open
    );

    signal_out <= adder_out;

end Behavioral;
