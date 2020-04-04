library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	port(
		sw: in std_logic_vector(7 downto 0);
		btn0,btn1,clk: in std_logic;
		TxD,TxD_debug,transmit_debug,button_debug,clk_debug: out std_logic);
end entity ;


architecture test of toplevel is


component transmit_debouncing is 
	port(
		clock, btn1 : in std_logic;
		transmit : out std_logic);
end component;

component transmitter is
	port(
		clock, reset, transmit : in std_logic;
		data : in std_logic_vector(7 downto 0);
		TxD : out std_logic
	);
end component;
signal Stransmit,STxD: std_logic;

begin
TxD<=STxD;
TxD_debug <= STxD;
transmit_debug <= btn1;
button_debug <= btn1;
clk_debug <= clk;

transmit: transmitter port map(clk,btn0,btn1,sw,STxd);
--transmit_deb: transmit_debouncing port map(clk,btn1,Stransmit);

end test;
