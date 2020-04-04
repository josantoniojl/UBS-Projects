library IEEE;
use IEEE.std_logic_1164.ALL;

entity tb_xversy is
	generic (n:integer:=7);
end tb_xversy;

architecture archi_tb_xversy of tb_xversy is


component xversy is
	generic (n:integer);
	port(
		x : in std_logic_vector(0 to n);
		enable : in std_logic;
		y : out std_logic_vector(0 to n)
	);
end component;

signal Sx, Sy : std_logic_vector(0 to n);
signal Senable : std_logic := '0';

begin

liaison : xversy generic map (n=>n) port map (Sx, Senable, Sy);

process
begin
	Senable <= '1';
	Sx <= "00010010";
	wait for 20 ns;
end process;

end archi_tb_xversy;