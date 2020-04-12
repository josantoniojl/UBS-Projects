LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.fixed_pkg.all; 

entity cordic is
	generic (width_sup,width_inf: integer);
	port( clk, rst,mode_s,start: in std_logic;
	      E_XO,E_YO : in   sfixed(width_sup-1 downto -width_inf):=(others=>'0');
	      E_ZO      : in   sfixed(width_sup downto -width_inf+1):=(others=>'0');
	      S_Xn,S_Yn : out  sfixed(width_sup-1 downto -width_inf):=(others=>'0');
	      S_Zn      : out  sfixed(width_sup downto -width_inf+1):=(others=>'0');
	      finCalcul : out std_logic
	      );
end entity;
architecture test of cordic is

-- declaration of component MACHINE D'ETAT CORDIC
component uc_cordic is
	port( clk, rst,start: in std_logic;
	      cnt_s : in integer; 
	      activeChargement,LoadReg_s,finCalcul : out std_logic);
end component;

-- declaration of component COMPTEUR
component counter is
	port( activeChargement,LoadReg_s,clk: in std_logic;
	      cnt_s : out integer:=0);
end component;

-- declaration of component ROM
component LutAtan is
	generic (width_sup,width_inf: integer);
	port( cnt_s: in integer:=0;
	      SortieLut: out sfixed (width_sup-1 downto -width_inf):=(others=>'0'));
end component;

-- declaration of component SIGNE
component Signe_Sigma is
	generic (width_sup,width_inf: integer);
	port(   E_Y:in sfixed(width_sup-1 downto -width_inf);
		E_Z:in sfixed(width_sup downto -width_inf+1);
		mode_s : in  std_logic;
		S_res  : out std_logic);
end  component;

-- declaration of component REGISTRE
component Registre is
	generic(width_sup,width_inf: integer);
	port(   E_Reg_0,E_Reg_I : in sfixed(width_sup-1 downto -width_inf);
		activeChargement,LoadReg_s,clk : in std_logic;
		S_Reg  : out sfixed(width_sup-1 downto -width_inf));
end component ;

-- declaration of component SHIFT
component shiftin is
	generic (width_sup,width_inf: integer);
	port (cnt_s : in integer:= 1;
	      E_Shiftn  : in  sfixed(width_sup-1 downto -width_inf);
	      S_Shiftn  : out sfixed(width_sup-1 downto -width_inf));
end component;

-- declaration of component ADDITIONEUR/SOUSTRACTEUR
component adder_subtractor is
	generic (width_sup,width_inf: integer);
	port (add_sub : in std_logic;
	      E_addsub_1, E_addsub_2 : in   sfixed(width_sup-1 downto -width_inf):=(others=>'0');
	      S_addsub  : 	       out  sfixed (width_sup-1 downto -width_inf):=(others=>'0'));
end component;

-- declaration of Signals UCORDIC-COUNTER-ROM-SIGNE-REGISTRE-SHIFT-ADDITIONEUR/SOUSTRACTEUR
	Signal SactiveChargement,SLoadReg_s,SfinCalcul,SStart,SS_res,SS_resY: std_logic;
	Signal Scnt_s : integer;	
 	Signal SS_addsub_X,SS_addsub_Y: sfixed(width_sup-1 downto -width_inf):=(others=>'0');
	Signal SS_Shiftn_X,SS_Shiftn_Y: sfixed(width_sup-1 downto -width_inf);
	Signal SS_Xn,SS_Yn,SSortieLut : sfixed(width_sup-1 downto -width_inf):=(others=>'0');
 	Signal SS_addsub_Z,SS_Zn: sfixed(width_sup downto -width_inf+1):=(others=>'0');

begin
      -- Instantation du composant REGISRE 
	Reg_X: Registre generic map(width_sup,width_inf)     port map (E_XO,SS_addsub_X,SactiveChargement,SLoadReg_s,clk,SS_Xn);
	Reg_Y: Registre generic map(width_sup,width_inf)     port map (E_YO,SS_addsub_Y,SactiveChargement,SLoadReg_s,clk,SS_Yn);
	Reg_Z: Registre generic map(width_sup+1,width_inf-1) port map (E_ZO,SS_addsub_Z,SactiveChargement,SLoadReg_s,clk,SS_Zn);
      -- Instantation du composant SHIFT 
	Shif_X: shiftin generic map(width_sup,width_inf) port map(Scnt_s,SS_Xn,SS_Shiftn_X);
	Shif_Y: shiftin generic map(width_sup,width_inf) port map(Scnt_s,SS_Yn,SS_Shiftn_Y);
      -- Instantation du composant ADDITIONEUR/SOUSTRACTEUR
	Addsub_X: adder_subtractor generic map(width_sup,width_inf)     port map (SS_res,SS_Xn,SS_Shiftn_Y,SS_addsub_X);
	Addsub_Y: adder_subtractor generic map(width_sup,width_inf)     port map (SS_resY,SS_Yn,SS_Shiftn_X,SS_addsub_Y);
	Addsub_Z: adder_subtractor generic map(width_sup+1,width_inf-1) port map (SS_res,SS_Zn,SSortieLut,SS_addsub_Z);
      -- Instantation des composants SIGNE, MACHINE D'ETAT, ROM,COMPTEUR
	Sig  : Signe_Sigma generic map(width_sup,width_inf) port map (SS_Yn,SS_Zn,mode_s,SS_res);
	cordic: uc_cordic port map(clk,rst,Start,Scnt_s,SactiveChargement,SLoadReg_s,finCalcul);
	Lut: LutAtan generic map(width_sup+1,width_inf-1) port map (Scnt_s,SSortieLut);
	count: counter port map(SactiveChargement,SLoadReg_s,clk,Scnt_s);
	SS_resY<= not SS_res; -- Inverser l'opération arithmétique
      -- Assigner des valeurs de sortie
        S_Xn<=SS_Xn;
        S_Yn<=SS_Yn;
        S_Zn<=SS_Zn;
end architecture;

