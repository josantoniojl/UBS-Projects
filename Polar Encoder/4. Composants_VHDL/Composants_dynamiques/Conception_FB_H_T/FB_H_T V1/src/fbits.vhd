LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

--Clock: Clock du systeme, Reset du systeme, Start de calcul, OutputRam:valeur binaire de la RAM
--tk,tn: tk: Taille message, tn:Taille message encodé (Frozen bits)= tn-tk
--Enable: Frozen bits a fini donc XversY est pret a travailler, InputRam= valeur a ecrire sur la ram
-- addERAM: Adress ou on va garder inputRAM, addLRAM: Adress ou on va garder output RAM

entity Fbits is
	port (
		clock, reset, start,out_RAMe,out_RAMr:  in std_logic;
		tk,tn,logn: in  integer;
		enable,in_RAMe,WEEncodage,WEReceptione,rstram: out std_logic;
		addERAM,addLRAM,raddLRAM: out integer);	
end entity;

architecture arch_Fbits of Fbits  is

	-- Declaration du composant avec les valeurs Q
	component rom_Q is
	port( ligne,colonne: in integer;
	      Sortie: out integer);
	end component;

	signal SQ,Sligne,Scolonne: integer:=0;		-- Signal pour gerer la ROM
	type etat is(Attente,Zeros,Synchro,Uns,Fin);
	signal setat:etat;					--4 etats du machine de etats
    	signal enabl,Sw_enable,Sreset,Sdata_in,Sdata_out:std_logic:='0';
	signal SaddERAM,SaddLRAM,SraddLRAM:integer:=0;--Adresses a la RAM
begin
 	t_rom_Q: rom_Q port map (Sligne,Scolonne,SQ);

	process (clock,reset)
	variable i,j,l,Sk,Sn,Sfb:integer:=0;
	variable message:std_logic_vector(0 to 10):=(others=>'0');
	begin
		Sk:=tk;
		Sn:=tn;
		Sfb:=Sn-Sk;
		if (reset='1')then				--Si reset on mets tout a zero
		 	--x<=(others => '1');
			enabl<='0';
			i:=0;
			j:=0;
			l:=0;
			Sreset<='1';
			SaddERAM<=0;	
			SaddLRAM<=0;	
			SraddLRAM<=0;
			WEEncodage<='0';--Arret d'ecriture
		elsif (clock'event and clock='1') then
			case setat is
				when Attente =>
				enabl<='0';
 			        WEEncodage<='0';--Arret d'ecriture
				if(start='1') then		--Si button start appuye on fait le process du frozen bits
					Sreset<='1';-- Avant faire le calcul on mets tout a zero
				SaddERAM<=0;
				SaddLRAM<=0;
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
						WEEncodage<='1';--Ecriture sur la RAM égale
						Sligne<=(logn-3);     --Accede ligne du ROM
						Scolonne<=i;   --Accede colonne ROM
						SaddERAM<=SQ;   --Positionement des zeros sur le vector X
						in_RAMe<='0';  --Ecriture de Zeros sur la ROM
						i:=i+1;
						setat<=Zeros;
					else 
						setat<=Synchro;
					end if;
				when Synchro=>
							setat<=Uns;
				when Uns=>
					if(j<=Sn+1) then 
						SaddLRAM<=j;
						--SraddLRAM<=l;
						if(out_RAMe/='0') then	--Si X different 0 donc on garde la valeur de notre message
							SaddERAM<=j-1;		--Possition a garder avec un decalage a gauche
							in_RAMe<=out_RAMr;  -- Stocakge des donnes
							l:=l+1;
							SraddLRAM<=l;
						end if;
						j:=j+1;					
						setat<=Synchro;
					else
					   	--Reinisialisation  des variables
						enabl<='1';
 			        	WEEncodage<='0';
						SaddERAM<=0;
						SaddLRAM<=0;
						SraddLRAM<=0;
						setat<=Fin;
						
					end if;
				when Fin=>
					setat<=Attente;

				when others =>
					setat<=Attente;
			end case;
		end if;
		enable<=enabl;
		addERAM<=SaddERAM;
		addLRAM<=SaddLRAM;
		WEReceptione<='0';
		raddLRAM<=SraddLRAM;
		rstram<=Sreset;
	end process;
end arch_Fbits;