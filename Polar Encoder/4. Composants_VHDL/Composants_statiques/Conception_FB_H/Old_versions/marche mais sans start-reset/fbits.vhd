LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity fbits is
	generic (k,n,fb:integer);
	port (    
		clk,rst :  in std_logic;
		M   :  in std_logic_vector (0 to k);
		enable : out std_logic;
		S   :  out std_logic_vector (0 to n)
	);
end entity;

architecture test of fbits  is

	signal x : std_logic_vector (0 to n):= (others => '1');
	type pq is array (0 to n) of integer;
	signal Q:pq;
	type etat is(S0,S1,S2);
	signal setat:etat;
	signal i,j,l:integer:=0;
	
begin 

	process (clk,M,rst) 	
	begin
	
		Q<=(0,1,2,4,3,5,6,7);

		if (clk'event and clk='1') then
			case setat is
				when S0=>
					if(i<fb) then 
						x(Q(i))<='0';
						i<=i+1;
						setat<=S0;
					else 
						setat<=S1;
					end if;
				when S1=>
					if(j<(n+1)) then 
						if(x(j)/='0') then
							x(j)<=M(l);
							l<=l+1;
						end if;
						j<=j+1;
						setat<=S1;
					else 
						setat<=S2;
					end if;  
				when S2=>
					enable<='1';
			end case;
		end if;
		S<=x;
		end process;
		
end test;
