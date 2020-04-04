library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	generic ( g_CLKS_PER_BIT : integer:=10416);
	port(
		btn1,btn0,clk: in std_logic;	--supprimer btn1 aussi sur contraintes
		TxD: out std_logic
		--outputMsg : out std_logic_vector(0 to 15)
	);
end entity ;


architecture test of toplevel is

	component controle is
		port(
			boutton, clock, reset, end_fbits, end_hadamard, end_transmit : in std_logic;
			start_fbits, start_hadamard, start_transmit : out std_logic; 
			reset_fbits, reset_hadamard: out std_logic 
		);
	end component;

	component Fbits is
		port (    
			clock, reset, start,out_enc_fb,out_rec:  in std_logic;
			k,n,logM: in  integer;
			end_fb,in_enc_fb,w_enable_enc_fb,w_enable_rec,reset_enc: out std_logic;
			w_addr_enc_fb,r_addr_enc_fb,r_addr_rec: out integer);
	end component;

	component Hadamard is 
		port(
			clock,reset,start : in std_logic;
			logM: in integer;
			out_enc_H1, out_enc_H2 : in std_logic;
			r_addr_enc_H1, r_addr_enc_H2, w_addr_enc_H : out integer;
			w_enable_enc_H, end_hadamard : out std_logic;
			in_enc_H : out std_logic
		);
	end component;
		
	component ram_encodage is
		port(
			w_addr_enc_fb, w_addr_enc_H , r_addr_enc_T, r_addr_enc_fb, r_addr_enc_H1, r_addr_enc_H2 : in integer;
			w_enable_enc_fb, w_enable_enc_H, in_enc_fb, in_enc_H, r_enable_enc_T, reset, clock : in std_logic;
			out_enc_T : out std_logic_vector(0 to 7);
			out_enc_fb, out_enc_H1, out_enc_H2 : out std_logic
		);
	end component ;

	component ram_reception is
		port(
            w_addr_rec, r_addr_rec : in integer;
            w_enable_rec, reset, clock : in std_logic;
            in_rec : in std_logic_vector(7 downto 0);
            out_rec : out std_logic);
	end component;
	
	component UART_TX is
		generic ( g_CLKS_PER_BIT : integer);
		port (
			start, clock : in  std_logic;
			out_enc_T : in  std_logic_vector(7 downto 0);
			n : in integer;
			end_T, r_enable_enc_T : out std_logic;
			r_addr_enc_T: out integer;
			TxD : out std_logic
		);
	end component;
	

	--Signaux correspondant au composant Controle
	signal SendFbits, SendHadamard, SendTransmit, Sread_transmit_enable : std_logic:='0';
	signal SstartFbits, SstartHadamard: std_logic:='0';
	signal SresetFbits, SresetHadamard: std_logic:='0';
	signal SstartTransmission : std_logic:='0';
	
	--Signaux correspondant a tous les composants
	----RAM Encodage
	signal Sout_RAMe_Fb,Sout_RAMe_H1, Sout_RAMe_H2 :  std_logic:='0'; -- Sortie RAM Encodage
	signal Sout_RAMe_T : std_logic_vector(7 downto 0);--Sortie RAM Encodage Transmission
	signal Sin_RAMe_Fb, Sin_RAMe_H :  std_logic:='0'; -- Entrée RAM encodage
	signal Sereset :  std_logic:='0'; -- Reset de la RAM controlé par frozen bits
	signal SWEEncodage_Fb, SWEEncodage_H, SLEEncodage_T : std_logic :='0'; -- Enable Ecriture et lecture de la RAM (MODIFIER CA !!! SRamToTransmit)
	signal SaddERAM_Fb, SaddERAM_H, SaddLRAM_T, SaddLRAM_Fb, SaddLRAM_H1, SaddLRAM_H2 : integer:=0; -- Les adresses RAM Encodage
	-- RAM Reception
	signal SWEReception :  std_logic:='0'; -- Enable RAM reception
	signal Sout_RAMr :  std_logic:='0'; -- Sortie RAM reception (Frozen bits)
	signal SraddERAM,SraddLRAM : integer:=0; -- Les adresses RAM reception
	signal Sdata_in : std_logic_vector (0 to 7) := (others=>'0');-- Entree RAM  reception
	
	--Caracterstiques message entrée et message de sortie
	signal Sk : integer:=8;
	signal Sn : integer:=15;
	signal SlogM : integer:=4;

begin

	Lcontrole : controle port map(btn1, clk, btn0, SendFbits, SendHadamard, SendTransmit, SstartFbits, SstartHadamard, SstartTransmission, SresetFbits, SresetHadamard);
	L_Fbits	  : fbits port map (clk,SresetFbits,SstartFbits,Sout_RAMe_Fb,Sout_RAMr,Sk,Sn,SlogM,SendFbits,Sin_RAMe_Fb,SWEEncodage_Fb,SWEReception,Sereset,SaddERAM_Fb,SaddLRAM_Fb,SraddLRAM);
	L_Hadamard: Hadamard port map(clk, SresetHadamard, SstartHadamard, SlogM, Sout_RAMe_H1,Sout_RAMe_H2, SaddLRAM_H1,SaddLRAM_H2, SaddERAM_H, SWEEncodage_H, SendHadamard, Sin_RAMe_H);
	-- -- L_RAM_encod: ram_encodage port map (SaddERAM_Fb, SaddERAM_H,SaddLRAM_T,SaddLRAM_Fb, SaddLRAM_H1, SaddLRAM_H2,SWEEncodage_Fb, SWEEncodage_H, Sin_RAMe_Fb, Sin_RAMe_H, SLEEncodage_T, Sereset,clk, Sout_RAMe_T,Sout_RAMe_Fb,Sout_RAMe_H1,Sout_RAMe_H2);
	L_RAM_encod: ram_encodage port map (SaddERAM_Fb, SaddERAM_H, SaddLRAM_T, SaddLRAM_Fb, SaddLRAM_H1, SaddLRAM_H2,SWEEncodage_Fb, SWEEncodage_H, Sin_RAMe_Fb, Sin_RAMe_H, SLEEncodage_T, Sereset,clk, Sout_RAMe_T,Sout_RAMe_Fb,Sout_RAMe_H1,Sout_RAMe_H2);
	L_RAM_recep: ram_reception  port map (SraddERAM,SraddLRAM,SWEReception,btn0,clk,Sdata_in,Sout_RAMr);
	L_UART_TX : UART_TX generic map (10416) port map (SstartTransmission, clk, Sout_RAMe_T, Sn, SendTransmit, SLEEncodage_T, SaddLRAM_T, TxD); 

end test;
