library IEEE;
use IEEE.std_logic_1164.ALL;


entity xversy is
	port(
		x : in std_logic_vector(0 to 7);
		y : out std_logic_vector(0 to 7)
	);
end xversy;

architecture Arch_xversy of xversy is

begin

process (x)
begin
	y(0) <= x(0) xor x(1) xor x(2) xor x(3) xor x(4) xor x(5) xor x(6) xor x(7);
	y(1) <= x(1) xor x(3) xor x(5) xor x(7);
	y(2) <= x(2) xor x(3) xor x(6) xor x(7);
	y(3) <= x(3) xor x(7);
	y(4) <= x(4) xor x(5) xor x(6) xor x(7);
	y(5) <= x(5) xor x(7);
	y(6) <= x(6) xor x(7);
	y(7) <= x(7);
end process;

end Arch_xversy;
