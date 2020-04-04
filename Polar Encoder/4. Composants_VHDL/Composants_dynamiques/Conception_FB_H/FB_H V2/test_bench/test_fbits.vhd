LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity t_fbits is
end entity;
architecture test of t_fbits  is

	component fbits is
	port (    
		clock, reset, start,out_RAMe,out_RAMr:  in std_logic;
		tk,tn,logn: in  integer;
		enable,in_RAMe,WEEncodage,WEReceptione,rstram: out std_logic;
		addERAM,addLRAM,raddLRAM: out integer);
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


	signal Sclk,Srst,SStart,Sout_RAMe,Senable,Sin_RAMe,SWEEncodage,Sdata_out_B,Sereset,SWEReception,Sout_RAMr:  std_logic:='0';
	signal SM,Sdata_out_transmit,Sdata_in   : std_logic_vector (0 to 7);
	signal Sk,Sn,SaddERAM,SaddLRAM,Slogn,SraddERAM,SraddLRAM :integer:=0;	

	begin 
	tes: fbits port map (Sclk,Srst,Sstart,Sout_RAMe,Sout_RAMr,Sk,Sn,Slogn,Senable,Sin_RAMe,SWEEncodage,SWEReception,Sereset,SaddERAM,SaddLRAM,SraddLRAM);
	RAM_encod: ram_encodage  port map (SaddERAM,0,SaddLRAM,0,SWEEncodage,'0',Sereset,Sclk,Sin_RAMe,Sdata_out_transmit,Sout_RAMe,Sdata_out_B);
	RAM_recp: ram_reception port map (SraddERAM,SraddLRAM,SWEReception,Srst,Sclk,Sdata_in,Sout_RAMr);

	Sclk<= not Sclk after 5 ns;
	process 
		begin
		Sstart<='1';
		Slogn<=4;
		Sk<=6;
		Sn<=15;
		Srst<='0';
		wait for 500 ns;
		end process;
end test;
