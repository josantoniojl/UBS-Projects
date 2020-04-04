LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.fixed_pkg.all; 
use IEEE.numeric_std.all;

entity tb_rom_Q is
end entity;

architecture tb_test of tb_rom_Q is

-- declaration of component LutAtan
component rom_Q is
	port( ligne,colonne: in integer;
	      Sortie: out integer);
end component;

--Déclarations des signaux à utiliser dans le portmap
	Signal Sligne,Scolonne:integer:=0;
	Signal SSortierom: integer;
begin
 	tb_rom_Q: rom_Q port map (Sligne,Scolonne,SSortierom);
	process
	begin
		Sligne<=1;
		Scolonne<=5;
 		wait for 10 ns;
		Sligne<=0;
		Scolonne<=3;
 		wait for 10 ns;
	end process;
end tb_test;
