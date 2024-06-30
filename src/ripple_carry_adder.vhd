library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder is
  generic (
    Nbit : positive := 8  -- Bit-width of inputs
  );
  port (
    a    : in  std_logic_vector(Nbit - 1 downto 0);  -- Input A
    b    : in  std_logic_vector(Nbit - 1 downto 0);  -- Input B
    cin  : in  std_logic;                            -- Carry-in
    s    : out std_logic_vector(Nbit - 1 downto 0);  -- Sum output
    cout : out std_logic                             -- Carry-out
  );
end entity;

architecture beh of ripple_carry_adder is
begin

  comb_process: process(a, b, cin)
    variable c : std_logic;  -- Internal carry variable
  begin
    c := cin;  -- Initialize carry with the input carry (cin)
    
    -- Loop through each bit position
    for i in 0 to Nbit - 1 loop
      -- Calculate sum for each bit position using XOR and current carry
      s(i) <= a(i) xor b(i) xor c;
      
      -- Calculate new carry for the next bit position
      c := (a(i) and b(i)) or (a(i) and c) or (b(i) and c);
    end loop;
    
    cout <= c;  -- Assign final carry-out
  end process comb_process;

end beh;
