LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.fixed_pkg.all; 

entity tb_Signesigma is
	generic (tb_width_sup:integer:=2;tb_width_inf: integer:=14);
end tb_Signesigma;

architecture tb_test of tb_Signesigma is

-- declaration of component Signe_Sigma
component Signe_Sigma is
	generic (width_sup,width_inf: integer);
	port(   E_Y:in sfixed(width_sup-1 downto -width_inf);
		E_Z:in sfixed(width_sup downto -width_inf+1);
		mode_s : in std_logic;
		S_res  : out std_logic);
end  component;

--Déclarations des signaux à utiliser dans le portmap
	Signal SE_Y: sfixed(tb_width_sup-1 downto -tb_width_inf);
	Signal SE_Z: sfixed(tb_width_sup downto -tb_width_inf+1);
	Signal Smode_s,SS_res: std_logic;
begin
	tb_sig: Signe_Sigma generic map(tb_width_sup,tb_width_inf) 
			       port map (SE_Y,SE_Z,Smode_s,SS_res);
process
	begin
		Smode_s<='0'; --vectorisation 
		SE_Y<="0000000000000000"; --La sortie doit être le bit
		SE_Z<="1000000000000000"; -- le plus significatif de Y 
		wait for 15 ns;
		SE_Y<="1000000000000000";
		SE_Z<="0000000000000000";
		wait for 15 ns;
		Smode_s<='1'; --Rotation
		wait for 15 ns;
		SE_Z<="1000000000000000"; --La sortie doit être l'inverse du bit 
		SE_Y<="0000000000000000"; -- le plus significatif de Z 
		wait for 15 ns;
	end process;
end tb_test;
