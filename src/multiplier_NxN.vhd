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
    signal signed_A, signed_B : signed(N-1 downto 0); -- Signed versions of A and B
    signal temp_result : signed(2*N-1 downto 0); -- Temporary result for multiplication
begin
    process (A, B)
    begin
        -- Convert inputs to signed
        signed_A <= signed(A);
        signed_B <= signed(B);

        -- Perform the multiplication as signed and assign it to temp_result
        temp_result <= signed_A * signed_B;

        -- Assign the signed result to the output port P, converting to std_logic_vector
        P <= std_logic_vector(temp_result);
    end process;
end behavior;
