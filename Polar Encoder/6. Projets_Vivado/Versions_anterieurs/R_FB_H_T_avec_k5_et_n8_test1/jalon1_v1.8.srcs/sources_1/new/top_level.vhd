library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	generic (k :integer:= 4; n :integer:= 7; fb :integer:= 3);
	port(
		sw: in std_logic_vector(0 to k);
		btn0,btn1,clk,RxD: in std_logic;--supprimer btn1 aussi sur contraintes
		outputMsg : out std_logic_vector(0 to n);
		o_RX_DV,TxD,TxD_debug,transmit_debug,button_debug,clk_debug: out std_logic
	);
end entity ;


architecture test of toplevel is

	component controle is
		port(
			 endreception, clock, reset, endFbits, endXtoY, endTransmit : in std_logic;
		     startreception, startFbits, startXtoY, startTransmit: out std_logic; 
		     resetFbits, resetXtoY, resetTransmit : out std_logic
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
			clock,start, reset : in std_logic;
			enable : out std_logic;
			y : out std_logic_vector(0 to n)
		);
	end component;

component UART_RX is
  generic (
    g_CLKS_PER_BIT : integer := 10416     -- Needs to be set correctly
    );
  port (
    i_Clk, start       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV, enable     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end component;
	component transmitter is
		port(
			clock, reset, start : in std_logic;
			data : in std_logic_vector(7 downto 0);
			TxD, enable : out std_logic
		);
	end component;

	signal SMreception,SfbitsToXversY, SXversYtoTransmit : std_logic_vector(0 to n);
	signal SMfbits : std_logic_vector(0 to k);
	signal Sendreception,SendFbits, SendXtoY, SendTransmit : std_logic;
	signal Startreception,SstartFbits, SstartXtoY, SstartTransmit : std_logic;
	signal SresetFbits, SresetXtoY, SresetTransmit : std_logic:='0';

	signal STxD : std_logic; -- utile pr le debug
	
begin
    SMfbits <= SMreception(n-k to n);
	TxD <= STxD;
	TxD_debug <= STxD;
	transmit_debug <= SstartTransmit;
	button_debug <= Startreception;
	clk_debug <= clk;
	outputMsg<=SXversYtoTransmit;
	reception : UART_RX generic map (10416) port map (clk,Startreception,RxD,o_RX_DV,Sendreception, SMreception);
	Lcontrole : controle port map(Sendreception, clk, btn0, SendFbits, SendXtoY, SendTransmit, Startreception, SstartFbits, SstartXtoY, SstartTransmit, SresetFbits, SresetXtoY, SresetTransmit);
	Lfbits : fbits generic map (k=>k, n=>n, fb=>fb) port map (clk, SresetFbits, SstartFbits, SMfbits, SendFbits, SfbitsToXversY);
	Lxversy : xversy generic map (n=>n) port map (SfbitsToXversY,clk, SstartXtoY, SresetXtoY, SendXtoY, SXversYtoTransmit);
	transmit: transmitter port map(clk, SresetTransmit, SstartTransmit, SXversYtoTransmit, STxD, SendTransmit);
	
end test;
