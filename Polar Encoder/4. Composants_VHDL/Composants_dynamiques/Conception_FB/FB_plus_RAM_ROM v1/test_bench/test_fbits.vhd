LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity t_fbits is
end entity;
architecture test of t_fbits  is

	component fbits is
		port (    
		clock, reset, start :  in std_logic;
		tk,tn: in integer;
		M   :  in std_logic_vector (0 to 7);
		enable : out std_logic;
		S   :  out std_logic_vector (0 to 7)
			);
	end component;

	signal Sclk,Srst,SStart,Senable :  std_logic:='0';
	signal SM   : std_logic_vector (0 to 7);
	signal SS   : std_logic_vector (0 to 7);
	signal Sk,Sn :integer:=0;	

	begin 
	tes: fbits port map (Sclk, Srst,SStart, Sk,Sn, SM,Senable, SS);
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
