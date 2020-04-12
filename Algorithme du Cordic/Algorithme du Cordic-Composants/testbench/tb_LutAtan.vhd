LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.fixed_pkg.all; 
use IEEE.numeric_std.all;

entity tb_LutAtan is
generic (tb_width_sup: integer:=3;tb_width_inf: integer:=13);
end entity;

architecture tb_test of tb_LutAtan is

-- declaration of component LutAtan
component LutAtan is
	generic (width_sup,width_inf: integer);
	port( cnt_s: in integer:=0;
	      SortieLut: out sfixed (width_sup-1 downto -width_inf):=(others=>'0'));
end component;

--Déclarations des signaux à utiliser dans le portmap
	Signal Scnt_s:integer:=0;
	Signal SSortieLut: sfixed(tb_width_sup-1 downto -tb_width_inf):=(others=>'0');
begin
 	tb_Lut: LutAtan generic map(tb_width_sup,tb_width_inf) port map (Scnt_s,SSortieLut);
	process
	begin
		--Affichage des valeurs dans la fenêtre de commande
		report real'image(to_real(SSortieLut)); 
 		wait for 10 ns;
		--Compteur pour accéder aux valeurs de la mémoire rom
		Scnt_S<=Scnt_s+1;
	end process;
end tb_test;
