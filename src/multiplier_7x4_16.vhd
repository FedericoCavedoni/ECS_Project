library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_7x4_16 is
    generic (
        N1 : integer := 7;  -- Bit-width of A
        N2 : integer := 4;  -- Bit-width of B
        O  : integer := 16  -- Bit-width of output P
    );
    Port (
        A : in  std_logic_vector (N1-1 downto 0);  
        B : in  std_logic_vector (N2-1 downto 0); 
        P : out std_logic_vector (O-1 downto 0)
    );
end multiplier_7x4_16;

architecture behavior of multiplier_7x4_16 is
    signal B_ext : unsigned(N1-1 downto 0);
    signal P_reg : unsigned(O-1 downto 0);
    
begin
    process (A, B)
    begin
        -- Extend B to match the width of A for multiplication
        B_ext <= unsigned('0' & B);

        -- Perform the multiplication and assign it to P_reg
        P_reg <= unsigned(A) * B_ext;

        -- Assign the result to the output port P
        P <= std_logic_vector(P_reg);
    end process;
end behavior;
