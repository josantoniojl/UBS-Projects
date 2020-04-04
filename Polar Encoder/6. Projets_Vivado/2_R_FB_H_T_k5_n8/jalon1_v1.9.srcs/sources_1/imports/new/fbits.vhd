LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity fbits is
	generic (k,n,fb:integer);
	port (    
		clock, reset, start :  in std_logic;
		M   :  in std_logic_vector (0 to k);
		enable : out std_logic;
		S   :  out std_logic_vector (0 to n)
	);
end entity;

architecture test of fbits  is

	signal x : std_logic_vector (0 to n):= (others => '1'); -- Initialisation vector X
	type pq is array (0 to n) of integer;
	signal Q:pq;						-- Vector avec les position des frozen bits
	type etat is(S0,S1,S2,S3);
	signal setat:etat;					--4 etats du machine de etats
    signal enabl:std_logic:='0'; 	
begin 

	process (clock,reset)
	variable i,j,l:integer:=0;	
	begin
		Q<=(0,1,2,4,3,5,6,7);				-- Positions du frozen bits

		if (reset='1')then				--Si reset on mets tout a zero
		 	x<=(others => '1');
			enabl<='0';
			i:=0;
			j:=0;
			l:=0;
		elsif (clock'event and clock='1') then
			case setat is
				when S0 =>
                    enabl<='0';
					if(start='1') then		--Si button start appuye on fait le process du frozen bits
                        x<=(others => '1');	-- Avant faire le calcul on mets tout a zero
                        i:=0;
                        j:=0;
                        l:=0;					
						setat<=S1;
					else
						setat<=S0;
					end if;
				when S1=>
					if(i<fb) then 
						x(Q(i))<='0';		--Positionement des zeros sur le vector X
						i:=i+1;
						setat<=S1;
					else 
						setat<=S2;
					end if;
				when S2=>
					if(j<=n) then 
						if(x(j)/='0') then	--Si X different 0 donc on garde la valeur de notre message
							x(j)<=M(l);
							l:=l+1;
						end if;
						j:=j+1;
						setat<=S2;
					else 
					   	enabl<='1';
						setat<=S3;
					end if;  
				when S3=>
					setat<=S0;
				when others =>
					setat<=S0;
			end case;
		end if;
		S<=x;
		enable<=enabl;
	end process;		
end test;