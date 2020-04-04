LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity rom_Q is
	port( ligne,colonne: in integer;
	      Sortie: out integer);
end entity;

architecture arch_rom_Q of rom_Q is
	type memory_t is array (0 to 1, 0 to 15) of integer;
	signal rom : memory_t:=( (0,1,2,4,3,5,6,7,others=>0),(0,1,2,4,8,3,5,6,9,10,12,7,11,13,14,15));

begin
	Sortie<=rom(ligne,colonne);
end arch_rom_Q ;
