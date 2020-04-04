library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity Test_Encodage is
	generic( Ssize_message:integer:=7);
end Test_Encodage;

architecture Test of Test_Encodage is
	component Encodage is
	generic( size_message:integer);
	port(
		clk,rst,enable : in std_logic;
		logM: in integer;
		fbits: in std_logic_vector(0 to size_message);
		Sortie : out std_logic_vector(0 to size_message));
	end component;

	signal Sclk,Srst,Senable : std_logic:='0';
	signal SlogM: integer;
	signal Sfbits,SSortie: std_logic_vector(0 to Ssize_message);
begin
	test: Encodage generic map(Ssize_message) port map(Sclk,Srst,Senable,SlogM,Sfbits,SSortie);
	Sclk<= not Sclk after 5 ns;
	process
	begin
		Srst<='0';
		wait for 20 ns;
		Senable<='1';
		SlogM<=3;
		Sfbits<="00010111";
		wait for 500 ns;
		Senable<='0';
		wait for 300 ns;
	end process;
end Test;
