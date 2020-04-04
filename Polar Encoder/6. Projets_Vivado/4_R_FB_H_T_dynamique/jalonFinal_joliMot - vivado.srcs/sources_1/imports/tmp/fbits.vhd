LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

--Clock: Clock du systeme, Reset du systeme, Start de calcul, OutputRam:valeur binaire de la RAM
--k,n: k: Taille message, n:Taille message encodé (Frozen bits)= n-k
--end_fb: Frozen bits a fini donc XversY est pret a travailler, InputRam= valeur a ecrire sur la ram
-- w_addr_enc_fb: Adress ou on va garder inputRAM, r_addr_enc_fb: Adress ou on va garder output RAM

entity Fbits is
	port (    
		clock, reset, start,out_enc_fb,out_rec:  in std_logic;
		k,n,logM: in  integer;
		end_fb,in_enc_fb,w_enable_enc_fb,reset_enc: out std_logic;
		w_addr_enc_fb,r_addr_enc_fb,r_addr_rec: out integer);
end entity;

architecture arch_Fbits of Fbits  is

	-- Declaration du composant avec les valeurs Q
	component rom_Q is
	port( ligne,colonne: in integer;
	      Sortie: out integer);
	end component;

	signal SQ,Sligne,Scolonne: integer:=0;		-- Signal pour gerer la ROM
	type etat is(Attente,Zeros,Synchro,Uns,Fin);
	signal setat:etat:=Attente;					--4 etats du machine de etats
    signal enable_end,Sreset:std_logic:='0'; 	
	signal SaddERAM,SaddLRAM,SraddLRAM:integer:=0;--Adresses a la RAM
begin 	
 	t_rom_Q: rom_Q port map (Sligne,Scolonne,SQ);

	process (clock,reset)
	variable i,j,l,Sk,Sn,Sfb:integer:=0;
	variable message:std_logic_vector(0 to 10):=(others=>'0');	
	begin
		Sk:=k;
		Sn:=n;
		Sfb:=Sn-Sk;
		if (reset='1')then				--Si reset on mets tout a zero
			enable_end<='0';
			i:=0;	
			j:=0;
			l:=0;
			Sreset<='1';
			SaddERAM<=0;	
			SaddLRAM<=0;	
			SraddLRAM<=0;
			w_enable_enc_fb<='0';--Arret d'ecriture
			setat<=Attente;

		elsif (clock'event and clock='1') then						
			case setat is
				when Attente =>
				enable_end<='0';
 			        w_enable_enc_fb<='0';--Arret d'ecriture
				if(start='1') then		--Si button start appuye on fait le process du frozen bits
					Sreset<='1';-- Avant faire le calcul on mets tout a zero
					SaddERAM<=0;	
					SaddLRAM<=0;
					SraddLRAM<=0;
					Scolonne<=0;
					i:=0;
 		            j:=0;
 		            l:=0;				
					setat<=Zeros;
				else
					setat<=Attente;
				end if;
				when Zeros=>
					Sreset<='0';
					if(i<=Sfb) then 
						w_enable_enc_fb<='1';--Ecriture sur la RAM égale
						Sligne<=(logM-3);     --Accede ligne du ROM
						Scolonne<=i;   --Accede colonne ROM
						SaddERAM<=SQ;   --Positionement des zeros sur le vector X
						in_enc_fb<='0';  --Ecriture de Zeros sur la ROM
						i:=i+1;
						setat<=Zeros;
					else 
						setat<=Synchro;
					end if;
				when Synchro=>
							Scolonne<=0;
							setat<=Uns;
				when Uns=>
					if(j<=Sn+1) then 
						SaddLRAM<=j;
						if(out_enc_fb/='0') then	--Si X different 0 donc on garde la valeur de notre message		
							SaddERAM<=j-1;		--Possition a garder avec un decalage a gauche
							in_enc_fb<=out_rec;  -- Stocakge des donnes
							l:=l+1;
							SraddLRAM<=l;
						end if;
						j:=j+1;					
						setat<=Synchro;
					else 
					   	--Reinisialisation  des variables 
 			        	w_enable_enc_fb<='0';
						setat<=Fin;
						enable_end<='1';
					end if;  
				when Fin=>
					setat<=Attente;

				when others =>
					setat<=Attente;
			end case;
		end if;
		end_fb<=enable_end;
		w_addr_enc_fb<=SaddERAM;
		r_addr_enc_fb<=SaddLRAM;
		r_addr_rec<=SraddLRAM;
		reset_enc<=Sreset;
	end process;		
end arch_Fbits;