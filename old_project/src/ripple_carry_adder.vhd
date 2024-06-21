library ieee;
  use ieee.std_logic_1164.all;

entity ripple_carry_adder is
  generic (
    N : positive := 16
  );
  port (
    a    : in  std_logic_vector(N - 1 downto 0);
    b    : in  std_logic_vector(N - 1 downto 0);
    cin  : in  std_logic;
    s    : out std_logic_vector(N - 1 downto 0);
    cout : out std_logic
  );
end ripple_carry_adder;

architecture behavior of ripple_carry_adder is
begin

  comb_process: process(a, b, cin)
    variable c : std_logic;
  begin
    c := cin;
    for i in 0 to N - 1 loop
      s(i) <= a(i) xor b(i) xor c;
      c    := (a(i) and b(i)) or (a(i) and c) or (b(i) and c);
    end loop;
	cout <= c;
  end process;

end behavior;
