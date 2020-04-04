library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	generic (k :integer:= 4; n :integer:= 7; fb :integer:= 3);
	port(
		sw: in std_logic_vector(0 to k);
		btn0,btn1,clk: in std_logic;
		outputMsg : out std_logic_vector(0 to n);
		TxD,TxD_debug,transmit_debug,button_debug,clk_debug: out std_logic
	);
end entity ;


architecture test of toplevel is

	component controle is
		port(
			start, clock, reset, endFbits, endXtoY, endTransmit : in std_logic;
			startFbits, startXtoY, startTransmit, resetFbits, resetXtoY, resetTransmit : out std_logic
		);
	end component;

	component fbits is
		generic (k,n,fb:integer);
		port (    
			clock, reset, start :  in std_logic;
			M   :  in std_logic_vector (0 to k);
			enable : out std_logic;
			S   :  out std_logic_vector (0 to n)
		);
	end component;

	component xversy is
		generic (n:integer);
		port(
			x : in std_logic_vector(0 to n);
			start, reset : in std_logic;
			enable : out std_logic;
			y : out std_logic_vector(0 to n)
		);
	end component;


	component transmitter is
		port(
			clock, reset, start : in std_logic;
			data : in std_logic_vector(7 downto 0);
			TxD, enable : out std_logic
		);
	end component;

	signal SfbitsToXversY, SXversYtoTransmit : std_logic_vector(0 to n);
	signal SendFbits, SendXtoY, SendTransmit : std_logic;
	signal SstartFbits, SstartXtoY, SstartTransmit : std_logic;
	signal SresetFbits, SresetXtoY, SresetTransmit : std_logic;

	signal STxD : std_logic; -- utile pr le debug
	
begin

	TxD <= STxD;
	TxD_debug <= STxD;
	transmit_debug <= SstartTransmit;
	button_debug <= btn1;
	clk_debug <= clk;
	outputMsg<=SXversYtoTransmit;
	
	Lcontrole : controle port map(btn1, clk, btn0, SendFbits, SendXtoY, SendTransmit, SstartFbits, SstartXtoY, SstartTransmit, SresetFbits, SresetXtoY, SresetTransmit);
	Lfbits : fbits generic map (k=>k, n=>n, fb=>fb) port map (clk, SresetFbits, SstartFbits, sw, SendFbits, SfbitsToXversY);
	Lxversy : xversy generic map (n=>n) port map (SfbitsToXversY, SstartXtoY, SresetXtoY, SendXtoY, SXversYtoTransmit);
	transmit: transmitter port map(clk, SresetTransmit, SstartTransmit, SXversYtoTransmit, STxD, SendTransmit);
	
end test;
