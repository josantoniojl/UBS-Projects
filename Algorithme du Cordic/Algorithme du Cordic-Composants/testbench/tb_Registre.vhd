LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.fixed_pkg.all; 

entity tb_Registre is
	generic(tb_width_sup:integer:=2;tb_width_inf:integer:=14);
end entity;

architecture tb_test of tb_Registre is

-- declaration of component Registre
component Registre is
	generic(width_sup,width_inf: integer);
	port(   E_Reg_0,E_Reg_I : in sfixed(width_sup-1 downto -width_inf);
		activeChargement,LoadReg_s,clk: in std_logic;
		S_Reg  : out sfixed(width_sup-1 downto -width_inf));
end component ;

--Déclarations des signaux à utiliser dans le portmap
	Signal SactiveChargement,SLoadReg_s : std_logic;
	Signal Sclk: std_logic:='0';
	Signal SE_Reg_0,SE_Reg_I,SS_Reg: sfixed(tb_width_sup-1 downto -tb_width_inf);  

begin
	tb_Reg: Registre generic map(tb_width_sup,tb_width_inf) 
		port map (SE_Reg_0,SE_Reg_I,SactiveChargement,SLoadReg_s,Sclk,SS_Reg);        

	Sclk<= not Sclk after 5 ns;
	process
	begin
		SLoadReg_s<='0';         --Cas où l'élément Registre n'est pas activé 			
		Sactivechargement<='0';
		SE_REG_0<="1100000000000000";
		SE_REG_I<="1111000000000000";
		wait for 10 ns;
		SLoadReg_s<='1';	--Cas dans lequel la sortie du système doit être le signal REG_0
		SE_REG_0<="0001000000000000";
		SE_REG_I<="1111000000000000";
		wait for 10 ns;	
		Sactivechargement<='1';	--Cas dans lequel la sortie du système doit être le signal REG_I
		SE_REG_0<="0001000000000000";
		SE_REG_I<="1111000000000000";
		wait for 10 ns;
	end process;
end architecture;
