LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity tb_uc_cordic is

end entity;

architecture tb_test of tb_uc_cordic is

-- declaration of component uc_cordic
component uc_cordic is
	port( clk, rst,start: in std_logic;
	      cnt_s : in integer; 
	      activeChargement,LoadReg_s,finCalcul : out std_logic);
end component;

component counter is
	port( activeChargement,LoadReg_s,clk: in std_logic;
	      cnt_s : out integer:=0);
end component;

--Déclarations des signaux à utiliser dans le portmap
	Signal SactiveChargement,SLoadReg_s,Srst,SfinCalcul,SStart: std_logic;
	Signal Sclk: std_logic:='0';
	Signal Scnt_s : integer;
begin
	tb_Coun: counter port map ( SactiveChargement,SLoadReg_s,Sclk,Scnt_s);
	tb_cordic: uc_cordic port map(Sclk,Srst,SStart,Scnt_s,SactiveChargement,SLoadReg_s,SfinCalcul);
	Sclk <= not Sclk after 5 ns;
	process
	begin
		Srst<='0';
		Sstart<='1';  -- Début de la séquence 
		wait for 200 ns; --Pendant ce temps, les quatre 
				 --états de la machine d'état seront exécutés. 
		Sstart<='0'; --Retour à l'état de repos 
		wait for 40 ns;
	end process;
end tb_test;
