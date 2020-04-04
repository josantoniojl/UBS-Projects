library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity Hadamard is 
	port(
		clock,reset,start : in std_logic;
		logM: in integer;
		out_enc_H1, out_enc_H2 : in std_logic;
		r_addr_enc_H1, r_addr_enc_H2, w_addr_enc_H : out integer;
		w_enable_enc_H, end_hadamard : out std_logic;
		in_enc_H : out std_logic
	);
	end Hadamard; 

architecture Hadamard_Archi of Hadamard is 
	type etat is(St, S0lecture, S0att, S0ecriture1, S0ecriture2, S1, S2lecture, S2att, S2ecriture, Fin);
	signal Setat : etat := St;
	
begin
	process(clock,reset)
		variable debutProcess : std_logic := '0';
		variable i,j,k:integer:=0;
		variable n:integer:=1;
	
	begin
	
		-- la ram a besoin d'adresse dès le premier coup d'horloge, d'où la nécessité de cette partie qui envoie des adresses valides pour la ram au tout départ
		if(debutProcess = '0') then
			r_addr_enc_H1 <= 0;
			r_addr_enc_H2 <= 0;
			debutProcess := '1';
		end if;
		
		if(reset = '1') then
			i:=0;
			n:=1;
			k:=(2**logM)+1;
			j:=0;
			end_hadamard<='0';
			w_enable_enc_H <= '0';
			Setat<=St;
		elsif(clock'event and clock='1') then 
			case Setat is
				when St =>
					r_addr_enc_H1 <= 0;
					r_addr_enc_H2 <= 0;
					i:=0;
					n:=1;
					k:=(2**logM)+1; -- taille du msg +1 car on fait k+=2 à la première lecture
					j:=0;
					end_hadamard <= '0';
					w_enable_enc_H <= '0';
					if(start='1') then
						Setat<=S0lecture;
					else
						Setat<=St;
					end if;
					
				when S0lecture =>
					k:=k-2;
					r_addr_enc_H1 <= k;
					r_addr_enc_H2 <= k-1;
					Setat <= S0att;
					
				when S0att =>
					Setat <= S0ecriture1;
					
				when S0ecriture1 =>
					w_enable_enc_H <= '1';
					w_addr_enc_H <= k;
					in_enc_H <= out_enc_H1 xor out_enc_H2;
					Setat <= S0ecriture2;
					
				when S0ecriture2 =>
					w_addr_enc_H <= k-1;
					in_enc_H <= out_enc_H2; 
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
						r_addr_enc_H1 <= j-i;
						r_addr_enc_H2 <= j-i-(2**n);
						Setat <= S2att;
					else
						i:=i+2**(n+1);
						Setat<=S1;
					end if;
				
				when S2att =>
					Setat <= S2ecriture;
					
				when S2ecriture =>
					w_addr_enc_H <= j-i;
					in_enc_H <= out_enc_H1 xor out_enc_H2;
					Setat <= S2lecture;
				
				when Fin =>
					end_hadamard<='1';
					Setat<=St;
				
			end case;
		end if;
		
		
	end process;
end Hadamard_Archi;
