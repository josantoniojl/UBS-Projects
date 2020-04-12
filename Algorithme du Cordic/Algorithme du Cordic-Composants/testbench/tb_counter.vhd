LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity tb_counter is
end tb_counter;

architecture tb_test of tb_counter is

-- declaration of component Counter
component counter is
	port( activeChargement,LoadReg_s,clk: in std_logic;
	      cnt_s : out integer);
end component;

--Déclarations des signaux à utiliser dans le portmap
	Signal SactiveChargement,SLoadReg_s :  std_logic;
	Signal Sclk   : std_logic:='0';
	Signal Scnt_s : integer;

begin
	tb_count: counter port map(SactiveChargement,SLoadReg_s,Sclk,Scnt_s);  
	Sclk<= not Sclk after 5 ns;
	process
	begin 
		SactiveChargement<='1'; --Démarrage par compteur
		SLoadReg_s<='1';
		wait for 200 ns;
		SactiveChargement<='0'; --Arrêt du compteur
		SLoadReg_s<='1';
		wait for 10 ns;
	end process;
end tb_test;
