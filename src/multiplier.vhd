library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier is
    generic (
        N1   : integer := 7;
        N2  : integer := 4;
        O   : integer := 16;
    );
    Port (
        clk : in std_logic;  
        rst : in std_logic;
                          
        A : in STD_LOGIC_VECTOR (N1-1 downto 0);  
        B : in STD_LOGIC_VECTOR (N2-1 downto 0); 
        P : out STD_LOGIC_VECTOR (O-1 downto 0) 
    );
end multiplier;

architecture struct of multiplier is
    signal A_reg : std_logic_vector(N1-1 downto 0);
    signal B_reg : std_logic_vector(N2-1 downto 0);
    signal B_ext : std_logic_vector(N1-1 downto 0);
    signal P_reg : std_logic_vector(O-1 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            A_reg <= A;
            B_reg <= B;
            B_ext <= "000" & B_reg; -- Estensione di B a 7 bit con zeri
            P_reg <= (others => '0'); -- Azzeramento del risultato
            P_reg(O-1 downto 0) <= std_logic_vector(unsigned(A_reg) * unsigned(B_ext));
        end if;
    end process;
    
    P <= P_reg;
end struct;
