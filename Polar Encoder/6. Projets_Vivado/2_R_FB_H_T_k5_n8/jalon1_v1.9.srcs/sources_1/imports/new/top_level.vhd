library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	generic (k :integer:= 4; n :integer:= 7; fb :integer:= 3);
	port(
		btn0,clk,RxD: in std_logic;--supprimer btn1 aussi sur contraintes
		outputMsg, outputMsg2 : out std_logic_vector(0 to n);
		TxD: out std_logic
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

	component Encodage is
        generic( size_message:integer);
        port(
            clk,rst,start : in std_logic;
            logM: in integer;
            fbits: in std_logic_vector(0 to size_message-1);
            enable : out std_logic;
            Sortie : out std_logic_vector(0 to size_message-1));
	end component;

    component UART_RX is
      generic (
        g_CLKS_PER_BIT : integer := 10416     -- Needs to be set correctly
        );
      port (
        i_Clk, start       : in  std_logic;
        i_RX_Serial : in  std_logic;
        enable     : out std_logic;
        o_RX_Byte   : out std_logic_vector(7 downto 0)
        );
    end component;
    
	component UART_TX is
      generic (
        g_CLKS_PER_BIT : integer := 10416     -- Needs to be set correctly
        );
      port (
        i_Clk       : in  std_logic;
        start    : in  std_logic;
        i_TX_Byte   : in  std_logic_vector(7 downto 0);
        o_TX_Serial : out std_logic;
        enable   : out std_logic
        );
    end component;

	signal SMreception,SfbitsToXversY, SXversYtoTransmit : std_logic_vector(0 to n);
	signal SMfbits : std_logic_vector(0 to k);
	signal Sendreception,SendFbits, SendXtoY, SendTransmit : std_logic;
	signal Startreception,SstartFbits, SstartXtoY, SstartTransmit : std_logic;
	signal SresetFbits, SresetXtoY, SresetTransmit : std_logic:='0';
	signal SlogM : integer := 3;
begin
    SMfbits <= SMreception(n-k to n);
	outputMsg<=SXversYtoTransmit;
	outputMsg2 <= SfbitsToXversY;
	reception : UART_RX generic map (10416) port map (clk,Startreception,RxD,Sendreception, SMreception);
	Lcontrole : controle port map(Sendreception, clk, btn0, SendFbits, SendXtoY, SendTransmit, Startreception, SstartFbits, SstartXtoY, SstartTransmit, SresetFbits, SresetXtoY, SresetTransmit);
	Lfbits : fbits generic map (k=>k, n=>n, fb=>fb) port map (clk, SresetFbits, SstartFbits, SMfbits, SendFbits, SfbitsToXversY);
	Lencodage : Encodage generic map (size_message=>(n+1)) port map (clk, SresetXtoY, SstartXtoY, SlogM,SfbitsToXversY,SendXtoY, SXversYtoTransmit);
	transmit: UART_TX generic map (10416) port map(clk, SstartTransmit, SXversYtoTransmit, TxD, SendTransmit);
 
end test;
