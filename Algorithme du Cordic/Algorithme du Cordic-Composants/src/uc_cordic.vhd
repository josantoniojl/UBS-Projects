LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;

entity uc_cordic is
	port( clk, rst,start: in std_logic;
	      cnt_s : in integer; 
	      activeChargement,LoadReg_s,finCalcul : out std_logic);
end entity;

architecture test of uc_cordic is
	Type Etats is (repos,chargeReg,iterations,fin);
	signal Setats: Etats:=repos;
begin
	process (clk,rst)
		begin
		if (rst='1') then		
		--Réinitialisation des variables 
			Setats <= repos;
			activeChargement<='0';
			LoadReg_s<='0';
			finCalcul<='0';
		elsif (clk'event and clk='1') then
			case Setats is
				when repos =>
				--Condition de départ					
					activeChargement<='0';     
					LoadReg_s<='0';
					finCalcul<='0';
				--On change d'état jusqu'à Start soit activé 
					if start='1' then          
						Setats<=chargeReg;
				-- Sinon, on est toujours dans le même état
					else	
						Setats<=repos;
					end if;
				when chargeReg =>
	 			--Etat de transition
					LoadReg_s<='1';
					--activeChargement<='1';  		 
					Setats<=iterations;
				when iterations =>
					activeChargement<='1';  
				--Si compteur=limite définie,on passe à l'état suivant     
					if(cnt_s=13) then           
						Setats<=fin;
						LoadReg_s<='0';  
				-- Sinon, on est toujours dans le même état
					else
						Setats<=iterations; 
					end if;
				when fin =>
					finCalcul<='1';
				--Si Start=!0 on reste dans le même état.
					if start='0' then    
						Setats<=repos;
					else
						Setats<=fin;
					end if;	
				when others =>
					null;   
			end case;
		end if;
	end process;
end architecture;
