library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity Encodage is
	generic( size_message:integer);
	port(
		clk,rst,start : in std_logic;
		logM: in integer;
		fbits: in std_logic_vector(0 to size_message-1);
		enable : out std_logic;
		Sortie : out std_logic_vector(0 to size_message-1));
	end Encodage;

architecture Test of Encodage is
	type etat is(St,S0,S1,S2,Fin);
	signal setat:etat;
	signal Ssortie: std_logic_vector(0 to size_message-1):=(others=> '0');
begin
	process(clk,rst)
		variable k,j,i,ki,kd:integer:=0;
		variable n:integer:=1;
	begin
		if(rst='1') then
			Ssortie<=(others=>'0');
			i:=0;
			n:=1;
			ki:=0;
			kd:=size_message-1;
			j:=0;
			enable<='0';
			Sortie<=Ssortie;
		elsif(clk'event and clk='1') then
			case setat is
				when St=>
				        i:=0;
						n:=1;
						ki:=0;
						kd:=size_message-1;
						j:=0;
						enable<='0';
					if(start='1') then
						SSortie<=(others=>'0');
						setat<=S0;
					else
						setat<=St;
					end if;
					
				when S0=>
					if(kd>=0) then 
						Ssortie(ki)<=fbits(kd) xor fbits(kd-1);
						Ssortie(ki+1)<=fbits(kd-1);
						ki:=ki+2;
						kd:=kd-2;
						setat<=S0;
					else
						setat<=S1;
					end if;
					
				when S1=>
					if (n<logM) then
						if (i<size_message) then 	
							j:=0;
							setat<=S2;
						else
							i:=0;
							n:=n+1;
							setat<=S1;
						end if;
					else
						setat<=Fin; 
					end if;
					
				when S2=>
					if(j<(2**n)) then
						Ssortie(j+i)<=Ssortie(j+i) xor Ssortie(j+i+(2**n));
						j:=j+1;
						setat<= S2;
					else
						i:=i+2**(n+1);
						setat<=S1;
					end if;
					
				when Fin=>
					Sortie<=Ssortie;
					enable<='1';
					setat<=St;
			end case;
		end if;
	end process;
end Test;
