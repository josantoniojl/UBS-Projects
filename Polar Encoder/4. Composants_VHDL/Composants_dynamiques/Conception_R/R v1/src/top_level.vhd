library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	port(
		btn1,btn0,RxD,clk: in std_logic;	
		outputMsg : out std_logic_vector(0 to 7));
end entity ;


architecture test of toplevel is

	component UART_RX is
		generic (g_CLKS_PER_BIT : integer := 10416 );
		port (	i_Clk, start: in std_logic;
				i_RX_Serial : in std_logic;
				enable, enable_reception : out std_logic;
				o_RX_Byte : out std_logic_vector(7 downto 0);
				add_reception,Sk,Sn,SlogM: out integer);
	end component;

	

	component ram_reception is
		port(
			write_add, read_add : in integer;
			w_enable, reset, clock : in std_logic;
			data_in : in std_logic_vector(7 downto 0);
			data_out : out std_logic);
	end component;
    

	--Sigaux qui nous permet de verifier la sortie
	signal SfbitsToXversY, SXversYtoTransmit : std_logic_vector(0 to 15);
	
	--Signaux correspondant a tous les composants
	signal SWEReception,Sout_RAMr :  std_logic:='0';
	signal Sdata_in : std_logic_vector (0 to 7);
	signal SraddERAM,SraddLRAM : integer:=0;	
	signal Sk,Sn,SlogM : integer:=0;	
	signal SstartFbits: std_logic;
	
begin

	L_RAM_recep: ram_reception  port map (SraddERAM,SraddLRAM,SWEReception,btn0,clk,Sdata_in,Sout_RAMr);
	L_Reception : UART_RX generic map (10416) port map (clk,'1',RxD,SstartFbits, SWEReception,Sdata_in,SraddERAM,Sk,Sn,SlogM);
	outputMsg<=Sdata_in;
end test;