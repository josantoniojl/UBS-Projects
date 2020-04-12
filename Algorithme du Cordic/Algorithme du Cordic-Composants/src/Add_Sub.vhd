LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.fixed_pkg.all; 

entity adder_subtractor is
	generic (width_sup,width_inf: integer);
	port (add_sub : in std_logic;
	      E_addsub_1, E_addsub_2 : in   sfixed(width_sup-1 downto -width_inf):=(others=>'0');
	      S_addsub  : out  sfixed (width_sup-1 downto -width_inf):=(others=>'0'));
end adder_subtractor;

architecture test of adder_subtractor is
begin
	process(E_addsub_1, E_addsub_2,add_sub)
	variable S_operation: sfixed(width_sup downto -width_inf):=(others=>'0');
	begin
		if(add_sub='0')then -- Selection entre adition et sutraction
			S_operation:=E_addsub_1+E_addsub_2;
		else
			S_operation:=E_addsub_1-E_addsub_2;
		end if;
--   Lorsqu'une op�ration arithm�tique est effectu�e sur des �l�ments sfixed
--   le r�sultat est un vecteur avec un bit suppl�mentaire. Par cons�quent,
--   pour continuer � utiliser les m�mes tailles de vecteur, le bit agr�g� est supprim�.
		S_addsub(width_sup-2 downto -width_inf)<=S_operation(width_sup-2 downto -width_inf);  
		S_addsub(width_sup-1)<=S_operation(width_sup);	
	end process;
end test;

