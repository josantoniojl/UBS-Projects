LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity t_fbits is
	     generic (Sk:integer:=3;Sn:integer:=7);
end entity;
architecture test of t_fbits  is

	component fbits is
	     generic (k,n,fb:integer);
             port ( clk,rst :  in std_logic:='0';
		    M   :  in std_logic_vector (0 to k);
		    S   :  out std_logic_vector (0 to n));
	end component;

	signal Sclk,Srst :  std_logic:='0';
	signal SM   : std_logic_vector (0 to Sk);
	signal SS   : std_logic_vector (0 to Sn);

	begin 
	tes: fbits generic map (Sk,Sn,(Sn-Sk)) port map (Sclk, Srst, SM, SS);
	Sclk<= not Sclk after 5 ns;
	process 
		begin
		SM<="1010";
		Srst<='1';
		wait for 1 ns;
		end process;
end test;
