library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	port(
		btn0,clk: in std_logic;	--supprimer btn1 aussi sur contraintes
		TxD: out std_logic
	);
end entity ;


architecture test of toplevel is

	component UART_TX is
		generic ( g_CLKS_PER_BIT : integer := 10416);
		port ( Sn		: in integer;
			i_Clk,start     : in  std_logic;
			i_TX_Byte   : in  std_logic_vector(7 downto 0);
			o_TX_Serial : out std_logic;
			transmite_enable   : out std_logic;
			add_transmit: out integer);
	end component;
	
	component ram_encodage is
		port(
			write_add_Fb, write_add_H , read_add_transmit, read_add_Fb, read_add_H1, read_add_H2 : in integer;
			w_enable_Fb, w_enable_H, data_in_Fb, data_in_H, transmit_enable, reset, clock : in std_logic;
			data_out_transmit : out std_logic_vector(7 downto 0);
			data_out_Fb, data_out_H1, data_out_H2 : out std_logic
		);
	end component ;

	--Signaux correspondant a tous les composants
	signal SStart,Sout_RAMe_Fb,Sout_RAMe_H1, Sout_RAMe_H2,Senable,Sin_RAMe_Fb, Sin_RAMe_H,SWEEncodage_Fb, SWEEncodage_H,Sereset,SWEReception,Sout_RAMr,SLETransmit:  std_logic:='0';
	signal SM,Sdata_out_transmit,Sdata_in : std_logic_vector (0 to 7);
	signal SaddERAM_Fb, SaddERAM_H,SaddERAM_T, SaddLRAM_Fb, SaddLRAM_H1, SaddLRAM_H2, SraddERAM,SraddLRAM : integer:=0;	
	signal Sk : integer:=8;	
	signal Sn : integer:=15; 
	signal SlogM : integer:=4;

begin

	L_Transmit: UART_TX generic map (10416) port map (Sn,clk,btn0,Sdata_out_transmit,TxD,SLETransmit,SaddERAM_T);
	L_RAM_encod: ram_encodage   port map (SaddERAM_Fb, SaddERAM_H,SaddERAM_T,SaddLRAM_Fb, SaddLRAM_H1, SaddLRAM_H2,SWEEncodage_Fb, SWEEncodage_H, Sin_RAMe_Fb, Sin_RAMe_H,SLETransmit, Sereset,clk, Sdata_out_transmit,Sout_RAMe_Fb,Sout_RAMe_H1,Sout_RAMe_H2);


end test;
