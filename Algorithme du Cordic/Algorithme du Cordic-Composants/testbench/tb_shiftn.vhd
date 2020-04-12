LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all; 

entity tb_shiftin is
	generic (tb_width_sup:integer:=2;tb_width_inf:integer:=14);
end tb_shiftin;

architecture tb_test of tb_shiftin is

-- declaration of component Shiftin
component shiftin is
	generic (width_sup,width_inf: integer);
	port (cnt_s : in integer;
	      E_Shiftn  : in  sfixed(width_sup-1 downto -width_inf);
	      S_Shiftn  : out sfixed(width_sup-1 downto -width_inf));
end component;
--Déclarations des signaux à utiliser dans le portmap	
	Signal Scnt_s:integer:=0;
	Signal SE_Shiftn,SS_Shiftn: sfixed(tb_width_sup-1 downto -tb_width_inf);

begin
	TB_Shif: shiftin generic map(tb_width_sup,tb_width_inf) 
			    port map(Scnt_s,SE_Shiftn,SS_Shiftn);

	process
	begin
		Scnt_s<= 4; --Decalage vers droit de quatre positions
		SE_Shiftn<="0100000000000000"; 
		wait for 20 ns;

		Scnt_s<= 2; --Decalage vers droit de deux positions
		SE_Shiftn<="1010000000000000";  
		wait for 20 ns;
	end process;
end tb_test;
