LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

--Clock: Clock du systeme, Reset du systeme, Start de calcul, OutputRam:valeur binaire de la RAM
--tk,tn: tk: Taille message, tn:Taille message encodé (Frozen bits)= tn-tk
--Enable: Frozen bits a fini donc XversY est pret a travailler, InputRam= valeur a ecrire sur la ram
-- addERAM: Adress ou on va garder inputRAM, addLRAM: Adress ou on va garder output RAM

entity fbits is
	port (    
		clock, reset, start,outputRAM_Encodage:  in std_logic;
		tk,tn: in  integer;
		enable,inputRAM_Encodage,WEEncodage: out std_logic;
		addERAM,addLRAM: out integer);
end entity;

architecture test of fbits  is

	-- Declaration du composant avec les valeurs Q
	component rom_Q is
	port( ligne,colonne: in integer;
	      Sortie: out integer);
	end component;
	-- Declaration du composant RAM 
	component ram1bit is
	port(	write_add, read_add : in integer;
			w_enable, clock,reset, data_in : in std_logic;
			data_out : out std_logic);
	end component;

	signal x : std_logic_vector (0 to 7):= (others => '1'); -- Initialisation vector X
	signal SQ,Sligne,Scolonne: integer:=0;		-- Signal pour gerer la ROM
	signal Swrite_add,Sread_add: integer:=0;	-- Signal pour gerer la RAM
	type etat is(S0,S1,S2,S3);
	signal setat:etat;					--4 etats du machine de etats
    signal enabl,Sw_enable,Sreset,Sdata_in,Sdata_out:std_logic:='0'; 	
	signal j,l:integer:=0;
begin 	
 	t_rom_Q: rom_Q port map (Sligne,Scolonne,SQ);
	t_ram_s: ram1bit port map (Swrite_add,Sread_add,Sw_enable,clock,Sreset,Sdata_in,Sdata_out);

	process (clock,reset)
	variable i,Sk,Sn,Sfb:integer:=0;	
	begin
		Sk:=tk;
		Sn:=tn;
		Sfb:=Sn-Sk;
		if (reset='1')then				--Si reset on mets tout a zero
		 	--x<=(others => '1');
			Sreset<='1';
			enabl<='0';
			i:=0;	
			j<=0;
			l<=0;
		elsif (clock'event and clock='1') then
			Sreset<='0';
			case setat is
				when S0 =>
				if(start='1') then		--Si button start appuye on fait le process du frozen bits
					Sreset<='0';--x<=(others => '1');	-- Avant faire le calcul on mets tout a zero
 			                Sw_enable<='0';
					i:=0;
 		                        j<=0;
 		                        l<=0;					
					setat<=S1;
				else
					setat<=S0;
				end if;
				when S1=>
					Sreset<='0';
					if(i<=Sfb) then 
						Sligne<=0;     --Accede ligne du ROM
						Scolonne<=i;   --Accede colonne ROM
						Swrite_add<=SQ;--Positionement des zeros sur le vector X
						Sdata_in<='0'; --Ecriture de Zeros sur la RAM
						i:=i+1;
						Sw_enable<='1';--Ecriture sur la RAM égale
						setat<=S1;
					else 
						setat<=S2;
					end if;
				when S2=>
					Sw_enable<='0';
					if(j<=Sn+2) then 
						Sread_add<=j;
						if(Sdata_out/='0') then	--Si X different 0 donc on garde la valeur de notre message
							Sw_enable<='1';		
							Swrite_add<=j-2;		
							Sdata_in<=M(l);
							l<=l+1;
						end if;
						j<=j+1;
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