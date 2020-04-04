library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	generic ( g_CLKS_PER_BIT : integer);
	port(
		btn1,btn0,clk: in std_logic;	--supprimer btn1 aussi sur contraintes
		outputMsg : out std_logic_vector(0 to 15)
	);
end entity ;


architecture test of toplevel is

	component controle is
		port(
		 	boutton, clock, reset, endFbits, endHadamard, endTransmit : in std_logic;
			startFbits, startHadamard, startTransmission : out std_logic; 
			resetFbits, resetHadamard: out std_logic
		);
	end component;

	component Fbits is
	port (    
			clock, reset, start, out_RAMe, out_RAMr:  in std_logic;
			tk,tn,logn: in  integer;
			enable,in_RAMe,WEEncodage,WEReceptione,rstram: out std_logic;
			addERAM,addLRAM,raddLRAM: out integer);
	end component;

	component Hadamard is 
		port(
			clk,rst,start : in std_logic;
			logM: in integer;
			sortieRamA, sortieRamB : in std_logic;
			read_add_A, read_add_B, write_add : out integer;
			w_enable, enableTraitement : out std_logic;
			sortie : out std_logic;
			sortie_debug: out std_logic_vector(0 to 15));
	end component; 
		
	component ram_encodage is
		port(
			write_add_Fb, write_add_H , read_add_transmit, read_add_Fb, read_add_H1, read_add_H2 : in integer;
			w_enable_Fb, w_enable_H, data_in_Fb, data_in_H, transmit_enable, reset, clock : in std_logic;
			data_out_transmit : out std_logic_vector(0 to 7);
			data_out_Fb, data_out_H1, data_out_H2 : out std_logic
		);
	end component ;

	component ram_reception is
		port(
			write_add, read_add : in integer;
			w_enable, reset, clock : in std_logic;
			data_in : in std_logic_vector(7 downto 0);
			data_out : out std_logic);
	end component;
	
	component UART_TX is
		generic ( g_CLKS_PER_BIT : integer);
		port(
			start, i_Clk : in  std_logic;
			i_TX_Byte : in  std_logic_vector(7 downto 0);
			Sn : in integer;
			r_TX_Done, transmite_enable : out std_logic;
			add_transmit: out integer;
			o_TX_Serial : out std_logic
		);
	end component;
	


	--Signaux correspondant au composant Controle
	signal SendFbits, SendHadamard, SendTransmit, Sread_transmit_enable : std_logic;
	signal SstartFbits, SstartHadamard: std_logic;
	signal SresetFbits, SresetHadamard: std_logic:='0';
	signal SstartTransmission : std_logic;
	
	--Signaux correspondant a tous les composants
	----RAM Encodage
	signal Sout_RAMe_Fb,Sout_RAMe_H1, Sout_RAMe_H2 :  std_logic:='0'; -- Sortie RAM Encodage
	signal Sout_RAMe_T : std_logic_vector(7 downto 0);--Sortie RAM Encodage Transmission
	signal Sin_RAMe_Fb, Sin_RAMe_H :  std_logic:='0'; -- Entrée RAM encodage
	signal Sereset :  std_logic:='0'; -- Reset de la RAM controlé par frozen bits
	signal SWEEncodage_Fb, SWEEncodage_H, SLEEncodage_T:='0'; -- Enable Ecriture et lecture de la RAM (MODIFIER CA !!! SRamToTransmit)
	signal SaddERAM_Fb, SaddERAM_H, SaddLRAM_T, SaddLRAM_Fb, SaddLRAM_H1, SaddLRAM_H2 : integer:=0; -- Les adresses RAM Encodage
	-- RAM Reception
	signal SWEReception :  std_logic:='0'; -- Enable RAM reception
	signal Sout_RAMr,   :  std_logic:='0'; -- Sortie RAM reception (Frozen bits)
	signal SraddERAM,SraddLRAM : integer:=0; -- Les adresses RAM reception
	signal Sdata_in : std_logic_vector (0 to 7);-- Entree RAM  reception
	
	--Caracterstiques message entrée et message de sortie
	signal Sk : integer:=8;
	signal Sn : integer:=15;
	signal SlogM : integer:=4;

begin

	Lcontrole : controle port map(btn1, clk, btn0, SendFbits, SendHadamard, SendTransmit, SstartFbits, SstartHadamard, SstartTransmission, SresetFbits, SresetHadamard);
	L_Fbits	  : fbits port map (clk,SresetFbits,SstartFbits,Sout_RAMe_Fb,Sout_RAMr,Sk,Sn,SlogM,SendFbits,Sin_RAMe_Fb,SWEEncodage_Fb,SWEReception,Sereset,SaddERAM_Fb,SaddLRAM_Fb,SraddLRAM);
	L_Hadamard: Hadamard port map(clk, SresetHadamard, SstartHadamard, SlogM, Sout_RAMe_H1,Sout_RAMe_H2, SaddLRAM_H1,SaddLRAM_H2, SaddERAM_H, SWEEncodage_H, SendHadamard,Sin_RAMe_H,SXversYtoTransmit);
	L_RAM_recep: ram_reception  port map (SraddERAM,SraddLRAM,SWEReception,btn0,clk,Sdata_in,Sout_RAMr);	
	L_RAM_encod: ram_encodage   port map (SaddERAM_Fb, SaddERAM_H,SaddLRAM_T,SaddLRAM_Fb, SaddLRAM_H1, SaddLRAM_H2,SWEEncodage_Fb, SWEEncodage_H, Sin_RAMe_Fb, Sin_RAMe_H,
	L_UART_TX : UART_TX generic map (g_CLKS_PER_BIT => g_CLKS_PER_BIT) port map (SstartTransmission, clk, Sout_RAMe_T, Sn, SendTransmit, SLEEncodage_T, SaddLRAM_T,TxD); 


end test;




