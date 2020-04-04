LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity t_fbits is
end entity;
architecture test of t_fbits  is

	component fbits is
	port (    
		clock, reset, start,out_RAMe:  in std_logic;
		M: in std_logic_vector(0 to 7);
		tk,tn: in  integer;
		enable,in_RAMe,WEEncodage: out std_logic;
		addERAM,addLRAM: out integer);	
	end component;
	
component ram_encodage is
	port(
		write_add, read_add_transmit, read_add_A, read_add_B : in integer;
		w_enable, transmit_enable, reset, clock, data_in : in std_logic;
		data_out_transmit : out std_logic_vector(7 downto 0);
		data_out_A, data_out_B : out std_logic);
end component ;

	signal Sclk,Srst,SStart,Sout_RAMe,Senable,Sin_RAMe,SWEEncodage,Sdata_out_B:  std_logic:='0';
	signal SM,Sdata_out_transmit   : std_logic_vector (0 to 7);
	signal Sk,Sn,SaddERAM,SaddLRAM :integer:=0;	

	begin 
	tes: fbits port map (Sclk,Srst,Sstart,Sout_RAMe,SM,Stk,Stn,Senable,Sin_RAMe,SWEEncodage,SaddERAM,SaddLRAM);
	RAM: ram_encodage  port map (SaddERAM,0,SaddLRAM,0,SWEEncodage,'0',Srst,Sclk,in_RAMe,Sdata_out_transmit,out_RAMe,Sdata_out_B);

	Sclk<= not Sclk after 5 ns;
	process 
		begin
		Sstart<='1';
		Sk<=2;
		Sn<=7;
		
		SM<="10000000";
		Srst<='0';
		wait for 200 ns;
		Srst<='1';
		wait for 20 ns;
		Sk<=3;
		Sn<=7;
		Srst<='0';
		Sstart<='1';
		SM<="10110000";
		wait for 200 ns;
		end process;
end test;