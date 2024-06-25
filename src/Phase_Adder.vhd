library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Phase_Adder is
  generic (
    N : integer := 16  -- Width of the frequency word
  );
  port (
    freq    : in std_logic_vector(N-1 downto 0);  -- Frequency input
    phase   : in std_logic_vector(N-1 downto 0);   -- Phase input (16-bit, only first two bits valid)
    freq_out: out std_logic_vector(N-1 downto 0)  -- Phase-shifted frequency output
  );
end entity;

architecture behavior of Phase_Adder is
begin

  process (freq, phase)
    variable temp_sum : integer;
    variable phase_shift : integer;
    variable phase_val : std_logic_vector(1 downto 0);
  begin

    phase_val := phase(1 downto 0);
    
    -- Determine the phase shift based on the input phase
    case phase_val is
      when "00" =>
        phase_shift := 0;    -- 0 degrees
      when "01" =>
        phase_shift := N/4;  -- 90 degrees
      when "10" =>
        phase_shift := N/2;  -- 180 degrees
      when "11" =>
        phase_shift := 3*N/4;-- 270 degrees
      when others =>
        phase_shift := 0;    -- Default to 0 degrees if unexpected input
    end case;

    temp_sum := to_integer(unsigned(freq)) + phase_shift;
    
    -- Modulo operation to wrap around if the sum exceeds the maximum value of freq
    if temp_sum >= 2**N then
      freq_out <= std_logic_vector(to_unsigned(temp_sum - 2**N, N));
    else
      freq_out <= std_logic_vector(to_unsigned(temp_sum, N));
    end if;
    
  end process;

end architecture;
