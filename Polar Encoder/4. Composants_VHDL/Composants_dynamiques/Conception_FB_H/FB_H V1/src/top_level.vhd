library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity toplevel is
	port(
		btn1,btn0,clk: in std_logic;	--supprimer btn1 aussi sur contraintes
		outputMsg : out std_logic_vector(0 to 15)
	);
end entity ;


architecture test of toplevel is

	component controle is
		port(
		 	boutton, clock, reset, endFbits, endHadamard : in std_logic;
			startFbits, startHadamard, startFin: out std_logic; 
			resetFbits, resetHadamard: out std_logic);
	end component;

	component Fbits is
	port (    
			clock, reset, start,out_RAMe,out_RAMr:  in std_logic;
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
			write_add, read_add_transmit, read_add_A, read_add_B : in integer;
			w_enable, transmit_enable, reset, clock, data_in : in std_logic;
			data_out_transmit : out std_logic_vector(7 downto 0);
			data_out_A, data_out_B : out std_logic);
	end component ;

	component ram_reception is
		port(
			write_add, read_add : in integer;
			w_enable, reset, clock : in std_logic;
			data_in : in std_logic_vector(7 downto 0);
			data_out : out std_logic);
	end component;
    


	--Singaux qui nosu permet de verifier la sortie
	signal SfbitsToXversY, SXversYtoTransmit : std_logic_vector(0 to 15);
	
	--Signaux correspondant au composant Control
	signal SendFbits, SendHadamard : std_logic;
	signal SstartFbits, SstartHadamard: std_logic;
	signal SresetFbits, SresetHadamard: std_logic:='0';
	
	--Signaux correspondant a tous les composants
	signal Sclk,Srst,SStart,Sout_RAMe_A,Sout_RAMe_B,Senable,Sin_RAMe,SWEEncodage,Sereset,SWEReception,Sout_RAMr:  std_logic:='0';
	signal SM,Sdata_out_transmit,Sdata_in   : std_logic_vector (0 to 7);
	signal SaddERAM,SaddLRAM_A,SaddLRAM_B,SraddERAM,SraddLRAM :integer:=0;	
	signal Sk  :integer:=5;	
	signal Sn  :integer:=16;	
	signal SlogM:integer:=3;

begin

	Lcontrole : controle port map(btn1, clk, btn0, SendFbits, SendHadamard, SstartFbits, SstartHadamard, SresetFbits, SresetHadamard);
	
	L_Fbits	  : fbits port map (Sclk,SresetFbits,SstartFbits,Sout_RAMe_A,Sout_RAMr,Sk,Sn,SlogM,SendFbits,Sin_RAMe,SWEEncodage,SWEReception,Sereset,SaddERAM,SaddLRAM_A,SraddLRAM);
	
	L_Hadamard: Hadamard port map(Sclk, SresetHadamard, SstartHadamard, SlogM, Sout_RAMe_A,Sout_RAMe_B, SaddLRAM_A,SaddLRAM_B, SaddERAM, SWEEncodage, SendHadamard, Sin_RAMe,SXversYtoTransmit);
	
	L_RAM_encod: ram_encodage   port map (SaddERAM,0,SaddLRAM_A,0,SWEEncodage,'0',Sereset,Sclk,Sin_RAMe,Sdata_out_transmit,Sout_RAMe_A,Sout_RAMe_B);
	L_RAM_recep: ram_reception  port map (SraddERAM,SraddLRAM,SWEReception,Srst,Sclk,Sdata_in,Sout_RAMr);


end test;
