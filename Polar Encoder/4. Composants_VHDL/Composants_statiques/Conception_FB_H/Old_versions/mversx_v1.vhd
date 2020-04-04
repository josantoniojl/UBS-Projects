LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity mversx is
end entity;

architecture test of mversx  is
signal clk : std_logic:='0';
signal M : std_logic_vector (0 to 3);
signal x : std_logic_vector (0 to 7):= (others => '1');
signal N : integer:=7;
type pq is array (0 to 7) of integer;
signal Q:pq;
	type etat is(S0,S1,S2);
	signal setat:etat;
	signal i,j,k:integer:=0;
begin
clk<= not clk after 5 ns;
process 
begin
Q<=(0,1,2,4,3,5,6,7);
M<="1001";

if (clk'event and clk='1') then
	case setat is
	 when S0=>
		if(i<4) then 
		 x(Q(i))<='0';
		 i<=i+1;
		 setat<=S0;
		 else 
		  setat<=S1;
 		end if;
	 when S1=>
		if(j<N) then 
		 	if(x(j)/='0') then
		  		x(j)<=M(k);
				k<=k+1;
			 end if;
		  j<=j+1;
		  setat<=S1;
		 else 
		  setat<=S2;
 		end if;  
	when S2=>
	end case;
	end if;

wait for 1 ns;
end process;
end test;
