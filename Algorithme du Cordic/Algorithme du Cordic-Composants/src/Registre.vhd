LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.fixed_pkg.all; 

entity Registre is
	generic (width_sup,width_inf: integer);
	port(   E_Reg_0,E_Reg_I : in sfixed(width_sup-1 downto -width_inf);
		activeChargement,LoadReg_s,clk: in std_logic;
		S_Reg  : out sfixed(width_sup-1 downto -width_inf));
end Registre;

architecture test of Registre is
begin
	process(clk)
		begin
		if clk'event and clk = '1' then
			if LoadReg_s = '1' then --Activation de Registre
				if activeChargement='1' then  --Activation Registre precedant 
					S_Reg <= E_Reg_I; 
				else
					S_Reg <= E_Reg_0; 
				end if;
			elsif (activeChargement='0'and LoadReg_s='0') then --Réinitialisation des valeurs            
				S_Reg <=(others=>'0');	
			end if;
		end if;
	end process;
end test;
