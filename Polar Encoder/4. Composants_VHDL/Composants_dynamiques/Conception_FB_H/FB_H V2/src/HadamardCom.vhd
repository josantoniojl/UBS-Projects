library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity Hadamard is 
	port(
		clk,rst,start : in std_logic;
		logM: in integer;
		sortieRamA, sortieRamB : in std_logic;
		read_add_A, read_add_B, write_add : out integer;
		w_enable, enableTraitement : out std_logic;
		sortie : out std_logic;
		sortie_debug : out std_logic_vector(0 to 15)
	);
	end Hadamard; 

architecture Hadamard_Archi of Hadamard is 
	type etat is(St, S0lecture, S0att, S0ecriture1, S0ecriture2, S1, S2lecture, S2att, S2ecriture, Fin);
	signal Setat : etat := St;
	
begin
	process(clk,rst)
		variable debutProcess : std_logic := '0';
		variable i,j,k:integer:=0;
		variable n:integer:=1;
	
	begin
	
		-- la ram a besoin d'adresse dès le premier coup d'horloge, d'où la nécessité de cette partie qui envoie des adresses valides pour la ram au tout départ
		if(debutProcess = '0') then
			read_add_A <= 0;
			read_add_B <= 0;
			debutProcess := '1';
		end if;
		
		if(rst = '1') then
			i:=0;
			n:=1;
			k:=(2**logM)+1;
			j:=0;
			enableTraitement<='0';
			w_enable <= '0';
			sortie_debug <= "0000000000000000";
			Setat<=St;
		elsif(clk'event and clk='1') then 
			case Setat is
				when St =>
					read_add_A <= 0;
					read_add_B <= 0;
					i:=0;
					n:=1;
					k:=(2**logM)+1; -- taille du msg +1 car on fait k+=2 à la première lecture
					j:=0;
					enableTraitement <= '0';
					w_enable <= '0';
					if(start='1') then
						sortie_debug <= "0000000000000000";
						Setat<=S0lecture;
					else
						Setat<=St;
					end if;
					
				when S0lecture =>
					k:=k-2;
					read_add_A <= k;
					read_add_B <= k-1;
					Setat <= S0att;
					
				when S0att =>
					Setat <= S0ecriture1;
					
				when S0ecriture1 =>
					w_enable <= '1';
					write_add <= k;
					sortie <= sortieRamA xor sortieRamB;
					sortie_debug(k) <= sortieRamA xor sortieRamB;
					Setat <= S0ecriture2;
					
				when S0ecriture2 =>
					write_add <= k-1;
					sortie <= sortieRamB; 
					sortie_debug(k-1) <= sortieRamB;
					if(k = 1)then
						Setat <= S1;
					else
						Setat <= S0lecture;
					end if;
					
				when S1 =>
					if (n<logM) then
						if (i<(2**logM)) then
							j:=2**logM; -- pas logM-1 puisque S2 commence par j--
							Setat<=S2lecture;
						else
							i:=0;
							n:=n+1;
							Setat<=S1;
						end if;
					else
						Setat<=Fin; 
					end if;
				
				when S2lecture =>
					j:=j-1;
					if(j > (2**logM)-1-(2**n)) then
						read_add_A <= j-i;
						read_add_B <= j-i-(2**n);
						Setat <= S2att;
					else
						i:=i+2**(n+1);
						Setat<=S1;
					end if;
				
				when S2att =>
					Setat <= S2ecriture;
					
				when S2ecriture =>
					write_add <= j-i;
					sortie <= sortieRamA xor sortieRamB;
					sortie_debug(j-i) <= sortieRamA xor sortieRamB;
					Setat <= S2lecture;
				
				when Fin =>
					enableTraitement<='1';
					Setat<=St;
				
			end case;
		end if;
		
		
	end process;
end Hadamard_Archi;
