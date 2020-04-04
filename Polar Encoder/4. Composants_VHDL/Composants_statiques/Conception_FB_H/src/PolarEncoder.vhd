library IEEE;
use IEEE.std_logic_1164.ALL;


entity polarEncoder is
	generic (k :integer:= 3; n :integer:= 7; fb :integer:= 4);
	port(
		clock, reset,start : in std_logic;
		inputMsg : in std_logic_vector (0 to k);
		outputMsg : out std_logic_vector(0 to n)
	);
end polarEncoder;


architecture Archi_polarEncoder of polarEncoder is

	component fbits is
		generic (k,n,fb:integer);
		port (
			clk, rst,start : in std_logic;
			M : in std_logic_vector (0 to k);
		 	enable : out std_logic;
			S : out std_logic_vector (0 to n)
		);
	end component;

	component xversy is
		generic (n:integer);
		port(
			x : in std_logic_vector(0 to n);
			enable : in std_logic;
			y : out std_logic_vector(0 to n)
		);
	end component;

	
	signal Sx : std_logic_vector(0 to n);
	signal Senable : std_logic;
	
begin

		Lfbits : fbits generic map (k=>k, n=>n, fb=>fb) port map (clock, reset,start, inputMsg, Senable, Sx);
		Lxversy : xversy generic map (n=>n) port map (Sx, Senable, outputMsg);
	
	
end Archi_polarEncoder;