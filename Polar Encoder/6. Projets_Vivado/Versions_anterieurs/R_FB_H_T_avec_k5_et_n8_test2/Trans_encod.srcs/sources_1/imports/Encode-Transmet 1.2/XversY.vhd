library IEEE;
use IEEE.std_logic_1164.ALL;


entity xversy is
	generic (n:integer);
	port(
		x : in std_logic_vector(0 to n);
		clock,start, reset : in std_logic;
		enable : out std_logic;
		y : out std_logic_vector(0 to n)
	);
end xversy;

architecture Arch_xversy of xversy is

begin

	process (clock,reset)
	begin
		  if(reset='1') then
		   y<=(others => '0');
		   enable <= '0';
		  elsif (clock'event and clock='1') then
		  if(start='1') then
			y(0) <= x(0) xor x(1) xor x(2) xor x(3) xor x(4) xor x(5) xor x(6) xor x(7);
			y(1) <= x(1) xor x(3) xor x(5) xor x(7);
			y(2) <= x(2) xor x(3) xor x(6) xor x(7);
			y(3) <= x(3) xor x(7);
			y(4) <= x(4) xor x(5) xor x(6) xor x(7);
			y(5) <= x(5) xor x(7);
			y(6) <= x(6) xor x(7);
			y(7) <= x(7);
			enable <= '1';
		   end if;
		end if;
	end process;

end Arch_xversy;