library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	generic (k :integer:= 4; n :integer:= 7; fb :integer:= 3);
	port(
		sw: in std_logic_vector(7 downto 0);
		btn0,btn1,clk: in std_logic;
		outputMsg : out std_logic_vector(0 to n);
		TxD,TxD_debug,transmit_debug,button_debug,clk_debug: out std_logic);
end entity ;


architecture test of toplevel is

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
			serial : out std_logic;
			y : out std_logic_vector(0 to n)
		);
	end component;


component transmitter is
	port(
		clock, reset, transmit : in std_logic;
		data : in std_logic_vector(7 downto 0);
		TxD : out std_logic
	);
end component;
	signal Stransmit,STxD,Sserial: std_logic;
	signal Sx,Sencode : std_logic_vector(0 to n);
	signal Senable : std_logic;
begin
TxD<=STxD;
TxD_debug <= STxD;
transmit_debug <= btn1;
button_debug <= btn1;
clk_debug <= clk;
outputMsg<=Sencode;

	Lfbits : fbits generic map (k=>k, n=>n, fb=>fb) port map (clk,btn0,btn1,sw, Senable, Sx);
	Lxversy : xversy generic map (n=>n) port map (Sx, Senable, Sserial,Sencode);
	transmit: transmitter port map(clk,btn0,Sserial,Sencode,STxD);
end test;
