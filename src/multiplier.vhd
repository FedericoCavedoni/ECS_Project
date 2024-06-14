library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier is
    generic (
        N1   : integer := 7;
        N2   : integer := 4;
        O    : integer := 16
    );
    Port (
        clk : in std_logic;  
        rst : in std_logic;
                          
        A : in  std_logic_vector (N1-1 downto 0);  
        B : in  std_logic_vector (N2-1 downto 0); 
        P : out std_logic_vector (O-1 downto 0) 
    );
end multiplier;

architecture struct of multiplier is
    signal A_reg : std_logic_vector(N1-1 downto 0);
    signal B_reg : std_logic_vector(N2-1 downto 0);
    signal B_ext : unsigned(N1-1 downto 0);
    signal P_reg : unsigned(O-1 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            A_reg <= A;
            B_reg <= B;
            B_ext <= unsigned('0' & B_reg); -- Estensione di B a N1 bit con zeri iniziali

            P_reg <= (others => '0'); -- Azzeramento del risultato
            P_reg <= unsigned(A_reg) * B_ext;
        end if;
    end process;
    
    P <= std_logic_vector(P_reg);
end struct;
