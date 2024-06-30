library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity declaration for NxN bit signed multiplier
entity multiplier_NxN is
    generic (
        N : integer := 7  -- Bit-width of A and B
    );
    port (
        A : in  std_logic_vector (N-1 downto 0);  -- Input A
        B : in  std_logic_vector (N-1 downto 0);  -- Input B
        P : out std_logic_vector (2*N-1 downto 0) -- Output P
    );
end entity;

-- Architecture body for multiplier_NxN
architecture behavior of multiplier_NxN is
    -- Internal signals for signed versions of inputs
    signal signed_A, signed_B : signed(N-1 downto 0);
    -- Internal signal for multiplication result
    signal temp_result : signed(2*N-1 downto 0);
begin
    -- Process to handle multiplication
    process (A, B)
    begin
        -- Convert std_logic_vector inputs to signed for multiplication
        signed_A <= signed(A);
        signed_B <= signed(B);

        -- Perform signed multiplication and store in temp_result
        temp_result <= signed_A * signed_B;

        -- Convert the signed result back to std_logic_vector for output
        P <= std_logic_vector(temp_result);
    end process;
end architecture;
