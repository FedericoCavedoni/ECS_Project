library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Phase_Adder is
    generic (
        N : integer := 16  -- Bit-width of signal_in and phase_in
    );
    Port (
        clk        : in  std_logic;               -- Clock input
        a_rst_h    : in  std_logic;               -- Asynchronous reset (active high)
        signal_in  : in  std_logic_vector(N-1 downto 0); -- Input signal of N bits (std_logic_vector)
        phase_in   : in  std_logic_vector(N-1 downto 0); -- Input phase of N bits (std_logic_vector)
        signal_out : out std_logic_vector(N-1 downto 0) -- Output modulated signal (std_logic_vector)
    );
end Phase_Adder;

architecture Behavioral of Phase_Adder is
    signal adder_out : std_logic_vector(N-1 downto 0);  -- Output of the adder component
    signal output_reg : std_logic_vector(N-1 downto 0); -- Output register for synchronized output

    -- Component declaration for ripple carry adder
    component ripple_carry_adder is
        generic (Nbit : integer := N);
        port (
            a    : in  std_logic_vector(Nbit - 1 downto 0);
            b    : in  std_logic_vector(Nbit - 1 downto 0);
            cin  : in  std_logic;
            s    : out std_logic_vector(Nbit - 1 downto 0);
            cout : out std_logic
        );
    end component;
begin

    -- Instantiate the ripple carry adder component
    FULL_ADDER_N_MAP : ripple_carry_adder
    generic map (Nbit => N)
    port map (
        a    => signal_in,
        b    => phase_in,
        cin  => '0',        -- Carry-in set to '0'
        s    => adder_out,  -- Sum output of the adder
        cout => open        -- Carry-out not used in this architecture
    );

    -- Process for output register synchronization
    PHASE_OUTPUT_REG: process(clk, a_rst_h, adder_out, output_reg)
    begin
        if (a_rst_h = '1') then       -- Asynchronous reset asserted
            output_reg <= (others => '0');  -- Reset output register to '0'
        elsif (rising_edge(clk)) then  -- On rising clock edge
            output_reg <= adder_out;   -- Update output register with adder output
        end if;
    end process;

    -- Connect the synchronized output to the output port
    signal_out <= output_reg;

end Behavioral;
