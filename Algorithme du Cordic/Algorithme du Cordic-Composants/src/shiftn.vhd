LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all; 

entity shiftin is
	generic (width_sup,width_inf: integer);
	port (cnt_s : in integer;
	      E_Shiftn : in  sfixed (width_sup-1 downto -width_inf);
	      S_Shiftn  : out sfixed(width_sup-1 downto -width_inf));
end shiftin;

architecture test of shiftin  is
begin
	process(E_Shiftn,cnt_s)
	begin
	S_Shiftn<=shift_right(sfixed(E_Shiftn), cnt_s);--Déplacer notre signal vers la droit
	end process;
end test;