LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.fixed_pkg.all; 

entity tb_cordic is
generic (tb_width_sup: integer:=2;tb_width_inf: integer:=14);
end entity;

architecture tb_test of tb_cordic is

-- declaration of component Cordic
component cordic is
	generic (width_sup,width_inf: integer);
	port( clk, rst,mode_s,start: in std_logic;
	      E_XO,E_YO :  in   sfixed(width_sup-1 downto -width_inf):=(others=>'0');
	      E_ZO      :  in   sfixed(width_sup downto -width_inf+1):=(others=>'0');
	      S_Xn,S_Yn : out   sfixed(width_sup-1 downto -width_inf):=(others=>'0');
	      S_Zn      : out   sfixed(width_sup downto -width_inf+1):=(others=>'0');
	      finCalcul : out std_logic
	      );
end component;

--Déclarations des signaux à utiliser dans le portmap
	Signal Sclk, Srst,Smode_s,Sstart,SfinCalcul:  std_logic :='0';
	Signal SE_XO,SE_YO : sfixed(tb_width_sup-1 downto -tb_width_inf):=(others=>'0');
	Signal SS_Xn,SS_Yn : sfixed(tb_width_sup-1 downto -tb_width_inf):=(others=>'0');	
	Signal SE_ZO       : sfixed(tb_width_sup downto -tb_width_inf+1):=(others=>'0');
	Signal SS_Zn       : sfixed(tb_width_sup downto -tb_width_inf+1):=(others=>'0');
begin
	TB_CORDIC: cordic generic map (tb_width_sup,tb_width_inf) 
			     port map (Sclk, Srst, Smode_s, SStart, SE_XO, SE_YO, SE_ZO,SS_Xn,SS_Yn,SS_Zn,Sfincalcul);
	Sclk <= not Sclk after 5 ns;
	process
	begin
		Srst <= '0';
		SStart<='1';  --Démarrer le calcul de Cordic
		Smode_s<= '0';--Selection mode [0-vectorisation] [1 Rotation]
		--Valeurs a tester
		SE_XO <= to_sfixed(0.125,tb_width_sup-1,-tb_width_inf);
		SE_YO <= to_sfixed(0.5625,tb_width_sup-1,-tb_width_inf);  
		SE_ZO <= to_sfixed(0.5,tb_width_sup,-tb_width_inf+1); 
		wait for 210 ns;
		--Affichages des valerus finales Xn, Yn et Zn
		report real'image(to_real(SS_Xn)); 
		report real'image(to_real(SS_Yn)); 
		report real'image(to_real(SS_Zn)); 
		wait for 20 ns;
		SStart<='0'; --Redémarrage du cycle Cordic
		wait for 20 ns;
		SStart<='1';  --Démarrer le calcul de Cordic
		Smode_s<= '1';--Selection mode 
		wait for 210 ns;
		report real'image(to_real(SS_Xn)); 
		report real'image(to_real(SS_Yn)); 
		report real'image(to_real(SS_Zn)); 
	end process;
end architecture;
