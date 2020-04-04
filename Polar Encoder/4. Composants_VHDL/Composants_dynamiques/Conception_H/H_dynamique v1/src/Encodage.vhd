library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity Encodage is
	generic( size_message:integer);
	port(
		clk,rst,enable : in std_logic;
		logM: in integer;
		fbits: in std_logic_vector(0 to size_message);
		Sortie : out std_logic_vector(0 to size_message));
	end Encodage;

architecture Test of Encodage is
	type etat is(Start,S0,S1,S2,Fin);
	signal setat:etat;
	signal Ssortie: std_logic_vector(0 to size_message):=(others=> '0');
		begin
		process(clk,rst,enable)
		variable k,i,n:integer:=0;
		begin
			if(rst='1') then
			Ssortie<=(others=>'0');
			i:=0;
			n:=0;
			k:=0;
			Sortie<=Ssortie;
			elsif(clk'event and clk='1') then
				case setat is
				when Start=>
					if(enable='1') then	
						i:=0;
						n:=0;
						k:=0;
						SSortie<=(others=>'0');
						Sortie<= (others=>'0');
						setat<=S0;
					else
						setat<=Start;
					end if;
				when S0=>	
					for b1 in 0 to size_message-1 loop
							Ssortie(k)<=fbits(k) xor fbits(k+1);
							Ssortie(k+1)<=fbits(k+1);
						if(bi%2=0)
							k:=k+2;
						end if;
	
					end loop ;
						setat<=S1;
				when S1=>
					if (n<size_message) then
						if (i<size_message) then
						 	setat<=S2;
						else
							i:=0;
							n:=1+n;
							setat<=S1;
						end if;
					else
					setat<=Fin; 
					end if;
				when S2=>
					for j in 0 to 2**n loop
					Ssortie(j+i)<=Ssortie(j+i) xor Ssortie(j+i+(2**n));
					end loop ;
					i:=i+2**(n+1); 
					setat<=S1;
				when Fin=>
					Sortie<=Ssortie;
					setat<=Start;
				end case;
			end if;
	end process;
end Test;
