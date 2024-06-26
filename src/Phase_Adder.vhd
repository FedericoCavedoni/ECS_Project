library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Phase_Adder is
  generic (N : integer := 16); -- Dimensione del segnale in bit
    Port (
        signal_in : in  STD_LOGIC_VECTOR (N-1 downto 0); -- Input segnale a N bit (STD_LOGIC_VECTOR)
        phase_in  : in  STD_LOGIC_VECTOR (N-1 downto 0); -- Input fase a N bit (STD_LOGIC_VECTOR)
        signal_out : out STD_LOGIC_VECTOR (N-1 downto 0) -- Output segnale modulato (STD_LOGIC_VECTOR)
    );
end Phase_Adder;

architecture Behavioral of Phase_Adder is
    signal signal_in_signed : signed(N-1 downto 0);
    signal phase_in_signed  : signed(N-1 downto 0);
begin

    -- Conversione da STD_LOGIC_VECTOR a signed
    signal_in_signed <= signed(signal_in);
    phase_in_signed  <= signed(phase_in);
    
    process(signal_in, phase_in)
    begin
        -- Aggiungi fase al segnale
        signal_out <= std_logic_vector(signal_in_signed + phase_in_signed);
    end process;

end Behavioral;
