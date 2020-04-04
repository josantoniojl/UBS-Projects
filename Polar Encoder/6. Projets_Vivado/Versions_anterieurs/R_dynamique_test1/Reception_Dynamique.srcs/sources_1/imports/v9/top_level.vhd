library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	port(
		btn0,RxD,clk: in std_logic;	
		outputMsg : out std_logic_vector(7 downto 0);
		outputMsg2 : out std_logic_vector(7 downto 0));
end entity ;


architecture test of toplevel is

	component UART_RX is
		generic (g_CLKS_PER_BIT : integer := 10416 );
		port (	i_Clk, start: in std_logic;
				i_RX_Serial : in std_logic;
				enable, enable_reception : out std_logic;
				o_RX_Byte,in_ram : out std_logic_vector(7 downto 0);
				add_reception,Sk,Sn,SlogM: out integer);
	end component;

	component ram_reception is
		port(
			write_add, read_add : in integer;
			w_enable, reset, clock : in std_logic;
			data_in : in std_logic_vector(7 downto 0);
			data_out : out std_logic);
	end component;
    
component test_reception is
	port(
		clk,data_out,start: in std_logic;
		Sk: in integer;
		add_lec: out integer;
		sortie: out std_logic_vector(7 downto 0));	
end component;

	--Signaux correspondant a tous les composants
	signal SWEReception,Sout_RAMr :  std_logic:='0';
	signal Sin_ram,Sdata_in : std_logic_vector (0 to 7);
	signal Stest : std_logic_vector (7 downto 0):=(others=>'0');
	signal SraddERAM,SraddLRAM : integer:=0;	
	signal Sn,SlogM : integer:=0;
	signal Sk : integer:=0;	
	signal SstartFbits: std_logic:='0';
	
begin

	L_RAM_recep: ram_reception  port map (SraddERAM,SraddLRAM,SWEReception,btn0,clk,Sdata_in,Sout_RAMr);
	L_Reception : UART_RX generic map (10416) port map (clk,'1',RxD,SstartFbits, SWEReception,Sdata_in,Sin_ram,SraddERAM,Sk,Sn,SlogM);
	L_test :  test_reception port map (clk,Sout_RAMr,SstartFbits,Sk,SraddLRAM,Stest);
	outputMsg<=Sdata_in;
	outputMsg2<=Stest;
end test;