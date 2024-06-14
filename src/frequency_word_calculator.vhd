library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FrequencyWordCalculator is
    generic (
        N : integer := 16
    );
    Port (
        freq_in   : in  STD_LOGIC_VECTOR (N-1 downto 0);
        freq_word : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end FrequencyWordCalculator;

architecture Behavioral of FrequencyWordCalculator is
    constant clk_freq : std_logic_vector(N-1 downto 0) := "00000000000000000000000111100000"; -- Frequenza di clock 125 MHz

    signal temp_result : unsigned(63 downto 0); -- Variabile temporanea per i calcoli
begin
    process(freq_in)
    begin
        temp_result <= unsigned(freq_in) * to_unsigned(2**32, 64) / unsigned(clk_freq);
        freq_word <= std_logic_vector(temp_result(N-1 downto 0)); 
    end process;
end Behavioral;
