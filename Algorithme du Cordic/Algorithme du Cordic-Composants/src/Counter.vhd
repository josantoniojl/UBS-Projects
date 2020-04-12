LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity counter is
	port( activeChargement,LoadReg_s,clk: in std_logic;
	      cnt_s : out integer:=0);
end counter;

architecture test of counter is
begin
	process(clk,activeChargement,LoadReg_s)
		variable count:integer:=0;
		begin
		if (clk'event and clk='1') then
			if (activeChargement='1'and LoadReg_s='1') then 
				count:=count+1;	--Condition pour démarrer le compteur 
			elsif (activeChargement='0'and LoadReg_s='0') then 
				count:=0;	--Remise à zéro du compteur
			end if;
				cnt_s<=count;	
		end if;
	end process;
end architecture;
