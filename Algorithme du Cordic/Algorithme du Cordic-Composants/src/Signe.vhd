LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.fixed_pkg.all; 

entity Signe_Sigma is
	generic (width_sup,width_inf: integer);
	port(   E_Y:in sfixed(width_sup-1 downto -width_inf);
		E_Z:in sfixed(width_sup downto -width_inf+1);
		mode_s : in std_logic;
		S_res  : out std_logic);
end  Signe_Sigma;

architecture test of Signe_Sigma is
	signal valor:std_logic;
begin

	process(mode_s,E_Y,E_Z)
	begin
		if mode_s='0' then--Vecteur mode
			S_res<= E_Y(width_sup-1); --Vecteur
		else 
			S_res<= not E_Z(width_sup); -- Rotation
		end if;
	end process;
end test;