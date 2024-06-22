library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_NxN is
    generic (
        N : integer := 7  -- Bit-width of A and B
    );
    Port (
        A : in  std_logic_vector (N-1 downto 0);  -- Input A
        B : in  std_logic_vector (N-1 downto 0);  -- Input B
        P : out std_logic_vector (2*N-1 downto 0) -- Output P
    );
end multiplier_NxN;

architecture behavior of multiplier_NxN is
    signal temp_result : unsigned(2*N-1 downto 0); -- Temporary result for multiplication
begin
    process (A, B)
    begin
        -- Perform the multiplication and assign it to temp_result
        temp_result <= unsigned(A) * unsigned(B);

        -- Assign the result to the output port P
        P <= std_logic_vector(temp_result);
    end process;
end behavior;
