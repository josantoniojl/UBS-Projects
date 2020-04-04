library IEEE;
use IEEE.std_logic_1164.ALL;

entity tb_xversy is
end tb_xversy;

architecture archi_tb_xversy of tb_xversy is


component xversy is
	port(
		x : in std_logic_vector(0 to 7);
		y : out std_logic_vector(0 to 7)
	);
end component;

signal Sx, Sy : std_logic_vector(0 to 7);

begin

liaison : xversy port map (Sx,Sy);

process
begin
	Sx <= "01010111";
	wait for 20 ns;
	Sx <= "11111111";
	wait for 20 ns;
end process;

end archi_tb_xversy;
