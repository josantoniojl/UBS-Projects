LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity rom_Q is
	port( ligne,colonne: in integer;
	      Sortie: out integer);
end entity;

architecture arch_rom_Q of rom_Q is
	type memory_t is array (0 to 5, 0 to 255) of integer;
	signal rom : memory_t:=( 
		(0,1,2,4,3,5,6,7,others=>0),
		(0,1,2,4,8,3,5,6,9,10,12,7,11,13,14,15,others=>0),
		(0,1,2,4,8,16,3,5,6,9,10,17,12,18,20,7,24,11,13,19,14,21,22,25,26,28,15,23,27,29,30,31,others=>0),
		(0,1,2,4,8,16,3,32,5,6,9,10,17,12,18,33,20,34,7,24,36,11,40,13,19,14,48,21,35,22,25,37,26,38,41,28,42,15,49,44,50,23,52,27,39,56,29,43,30,45,51,46,53,54,57,58,31,60,47,55,59,61,62,63,others=>0),
		(0,1,2,4,8,16,3,32,5,6,9,64,10,17,12,18,33,20,34,7,24,36,65,11,66,40,13,19,68,14,48,21,72,35,22,25,37,80,26,38,67,41,28,96,69,42,15,49,70,44,73,50,23,74,52,81,27,76,39,82,56,29,97,84,43,30,98,71,45,88,51,100,46,75,53,104,77,54,83,57,78,112,85,58,31,99,86,60,89,101,47,90,102,105,92,55,106,79,113,59,108,114,87,61,116,62,91,103,120,93,107,94,109,115,110,117,63,118,121,122,95,124,111,119,123,125,126,127,others=>0),
		(0,1,2,4,8,16,3,32,5,6,9,64,10,17,12,18,128,33,20,34,7,24,36,65,11,66,40,13,19,68,14,129,48,21,72,130,35,22,25,132,37,80,26,38,67,136,41,28,96,69,42,15,144,49,70,44,73,131,50,23,74,160,133,52,81,27,76,134,39,82,137,56,29,192,97,138,84,43,30,145,98,71,140,45,88,146,51,100,46,75,161,148,53,104,77,162,135,54,83,152,57,78,164,193,112,139,85,58,31,194,99,168,86,141,60,89,147,196,101,142,47,90,176,149,102,200,105,92,163,150,55,153,106,79,165,208,113,154,59,108,166,195,114,169,87,156,61,224,197,170,116,143,62,91,177,198,103,172,201,120,93,178,151,202,107,94,180,209,155,204,109,167,210,115,184,157,110,225,212,171,117,158,63,226,199,118,173,216,121,179,228,174,203,122,95,181,232,205,124,182,211,185,206,111,240,213,186,159,227,214,119,188,217,229,175,218,123,230,233,220,125,183,234,207,126,241,187,236,242,215,189,244,190,219,231,248,221,235,222,127,237,243,238,245,191,246,249,250,223,252,239,247,251,253,254,255)
		);

begin
	Sortie<=rom(ligne,colonne);
end arch_rom_Q ;
