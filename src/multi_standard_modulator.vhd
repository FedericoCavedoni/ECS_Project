library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multi_Standard_Modulator is
    generic (
        N   : integer := 16;  -- Dimensione della frequenza e della fase in ingresso
        A   : integer := 4;   -- Dimensione dell'ampiezza in ingresso
        P   : integer := 7;   -- Dimensione dell'output della LUT
        O   : integer := 16   -- Dimensione dell'output del sistema
    );
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        frequency      : in  std_logic_vector(N-1 downto 0);
        phase          : in  std_logic_vector(N-1 downto 0);
        amplitude      : in  std_logic_vector(A-1 downto 0);
        yq             : out std_logic_vector(O-1 downto 0) 
    );
end Multi_Standard_Modulator;

architecture behavior of Multi_Standard_Modulator is

    -- Segnale interno per l'uscita del contatore
    signal counter_output : std_logic_vector(N-1 downto 0);
    
    -- Segnale interno per l'uscita dell'adder
    signal adder_output : std_logic_vector(N-1 downto 0);
    
    -- Segnale interno per l'uscita della LUT
    signal lut_output : std_logic_vector(P-1 downto 0);
    
    -- Segnale interno per l'uscita del moltiplicatore
    signal multiplier_output : std_logic_vector(O-1 downto 0);
    
    -- Registro di uscita per la sincronizzazione dell'output
    signal output_reg : std_logic_vector(O-1 downto 0);

    -- Dichiarazione delle componenti

    component Counter is
        generic (N : integer := N);
        Port (
            clk     : in  std_logic;
            a_rst_h : in  std_logic;

            en      : in  std_logic;
            increment : in  std_logic_vector(N-1 downto 0);
            cntr_out  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component Ripple_Carry_Adder is
        generic (N : integer := N);
        Port (
            a       : in  std_logic_vector(N - 1 downto 0);
            b       : in  std_logic_vector(N - 1 downto 0);
            cin     : in  std_logic;
            s       : out std_logic_vector(N - 1 downto 0);
            cout    : out std_logic
        );
    end component;

    component ddfs_lut_65536_16bit is
        Port (
            address  : in  std_logic_vector(N downto 0);
            ddfs_out : out std_logic_vector(P downto 0)
        );
    end component;

    component multiplier_7x4_16 is
            generic (
                N1   : integer := P;
                N2  : integer := A;
                O   : integer := O;
            );
            Port (
                A : in STD_LOGIC_VECTOR (N1-1 downto 0);  
                B : in STD_LOGIC_VECTOR (N2-1 downto 0); 
                P : out STD_LOGIC_VECTOR (O-1 downto 0) 
            );

    end component;


begin

    PHASE_ACCUMULATOR: Counter
        generic map (N => N)
        port map (
            clk       => clk,
            a_rst_h   => reset,
            en        => '1',
            increment => frequency,
            cntr_out  => counter_output
        );

    ADDER: Ripple_Carry_Adder
        generic map (N => N)
        port map (
            clk     => clk,
            a_rst_h => reset,
            a       => counter_output,
            b       => phase,
            cin     => '0',
            s       => adder_output,
            cout    => open
        );

    LUT_65536 : ddfs_lut_65536_16bit
        port map (
            address  => adder_output,
            ddfs_out => lut_output
        );


    MULTIPLIER: multiplier_7x4_16
        generic map (N1 => P, N2 => A, O => O)
        port map (
            A   => lut_output,
            B   => amplitude,
            P   => multiplier_output
        );

    MSM_OUTPUT_REG: process(clk, reset)
    begin
        if (reset = '1') then
            output_reg <= (others => '0');
        elsif (rising_edge(clk)) then
            output_reg <= multiplier_output;
        end if;
    end process;

    yq <= output_reg;

end behavior;
