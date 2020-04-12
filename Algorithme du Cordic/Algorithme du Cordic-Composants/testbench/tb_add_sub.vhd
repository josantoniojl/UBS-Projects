LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.fixed_pkg.all; 

entity tb_add_sub is
	generic(tb_width_sup:integer:=2;tb_width_inf:integer:=14);
end entity;

architecture tb_test of tb_add_sub is

-- declaration of component Adder_Subracteur
component adder_subtractor is
	generic (width_sup,width_inf: integer);
	port (add_sub : in std_logic;
	      E_addsub_1, E_addsub_2 : in   sfixed(width_sup-1 downto -width_inf):=(others=>'0');
	      S_addsub  : out  sfixed (width_sup-1 downto -width_inf):=(others=>'0'));
end component;

--Déclarations des signaux à utiliser dans le portmap
	Signal Sadd_sub : std_logic:='0';
	Signal SEntree_1, SEntree_2,SS_addsub: sfixed(tb_width_sup-1 downto -tb_width_inf):=(others=>'0');
begin
	TB_addsub: adder_subtractor generic map(tb_width_sup,tb_width_inf) 
				       port map (Sadd_sub,Sentree_1,SEntree_2,SS_addsub);
	process
	begin
		Sadd_Sub<='0';	
		SEntree_1<="0010000000000000"; -- Adittion 0.5+0.5=1.0
		SEntree_2<="0010000000000000"; -- C'est a dire "0100000000000000"
		wait for 10 ns;
		SEntree_1<="0100000000000000"; -- Adittion 1.0+0.75=1.75
		SEntree_2<="0011000000000000"; -- C'est a dire "0111000000000000"
		wait for 10 ns;
		Sadd_Sub<='1';
		SEntree_1<="0100000000000000"; -- Sustraction  1.0-0.125=0.875 
		SEntree_2<="0000100000000000"; -- C'est a dire "0011100000000000"
		wait for 10 ns;
		SEntree_1<="0111000000000000"; -- Sustraction 1.75-0.25= 1.5 
		SEntree_2<="0001000000000000"; -- C'est a dire "0110000000000000"
		wait for 10 ns;
	end process;
end architecture;
