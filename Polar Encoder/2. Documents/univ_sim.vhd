LIBRARY std;
LIBRARY IEEE;
-- Inclusion pour std_ulogic et std_ulogic_vector
use IEEE.std_logic_1164.all;
-- Inclusion pour les traitement sur les fichiers
use std.textio.all;
-- Inclusion pour les fonctions et types personnalis�s
use work.fonction_viterbi.all;

-- D�claration de l'entit� vide
entity univ_sim is
    
end univ_sim;


-- D�claration de l'architecture
architecture univ of univ_sim is

-- D�claration du composant D�codeur de Viterbi
component viterbi is
    port(rst :  in std_ulogic;
         clk : in std_ulogic;
         Y1 : in std_ulogic_vector(2 downto 0);
         Y2 : in std_ulogic_vector(2 downto 0);
         Enable : in std_ulogic;
         Bit_d : out std_ulogic;
         CV_OK : out std_ulogic;
         Resc : out std_ulogic;
         Data_V : out std_ulogic);
end component;

-- D�claration des signaux qui relie le composant � l'environnement de simulation
SIGNAL rst       : std_ulogic;                      -- signal reset actif a 0
SIGNAL clk       : std_ulogic;                      -- signal d'horloge   
SIGNAL Y1        : std_ulogic_vector(2 DOWNTO 0);   -- entr�e 1 quantifi�e
SIGNAL Y2        : std_ulogic_vector(2 downto 0);   -- entree 2 quantifi�e 
SIGNAL Enable    : std_ulogic;                      -- entr�e enable indiquant y1 et y2 valide
SIGNAL Bit_d     : std_ulogic;                      -- Bit d�cod�
SIGNAL CV_OK     : std_ulogic;                      -- convergence viterbi est correcte 
SIGNAL Resc      : std_ulogic;                      -- operation de r�-�chelonnage dans l'unit� MN
SIGNAL Data_V    : std_ulogic;                      -- pr�sence de donn�e valide en sortie 
SIGNAL cela_repart : std_ulogic;                     -- activation du bloc de lecture/�criture

begin
    
   ---------------------------------------------------------------
   -- Process reset
   ---------------------------------------------------------------
   reset :    PROCESS
   BEGIN
      rst<='0';
      wait for 47 ns;
      rst<='1';
      WAIT;   -- On tue le process
   END PROCESS reset;

   ---------------------------------------------------------------
   -- Process d'horloge
   ---------------------------------------------------------------
   horloge :    PROCESS
   BEGIN
      clk <='1';
      WAIT FOR 30 ns;
      clk <= '0';
      WAIT FOR 30 ns;
   END PROCESS horloge;
   
   ---------------------------------------------------------------
   -- Process gestion de la lecture d'un bloc 
   ---------------------------------------------------------------
   lecture : PROCESS
   FILE fich         : TEXT OPEN read_mode IS "input.txt";
   VARIABLE ligne    : LINE;
   VARIABLE ny1      : natural;   
   VARIABLE ny2      : natural;
   BEGIN
	-----------------------------
	-- Initialisation des signaux
   Enable  <= '0';
	Y1    <= (OTHERS => '0');
	Y2    <= (OTHERS => '0');
	
	-------------------------------
	-- On attend avant de commencer
	-------------------------------
	-- attendre que le reset passe � 1
	WAIT UNTIL rst = '1';
	-- attendre 30 nanosecondes
	WAIT until clk'event and clk='1';
	
	LOOP
	   -- Tant que fin de fichier non atteinte
      WHILE NOT ENDFILE(fich) LOOP	 
       -- Attente le deuxi�me niveau haut de l'horloge
	    WAIT UNTIL clk'EVENT and clk ='1';                               
       WAIT UNTIL clk'EVENT and clk ='1';
	    ------------------------
	    -- Boucle de lecture du fichier
       ------------------------
       -- Lecture ligne
       READLINE(fich, ligne);
       -----------------------
       -- lecture de l'elements de la ligne
       -- affichage + signaux controles 
       ASSERT true REPORT "Lecture du fichier input.txt" SEVERITY note;
       -- Lecture du prtemier element
       READ(ligne,ny1);
       Y1   <= INT2VEC(ny1);
       -- Lecture du deuxi�me element
       READ(ligne,ny2);
       Y2   <= INT2VEC(ny2);  
       -- Passe l'entr�e enable du composant � 1             
	    Enable <= '1';            
       -----------------------
	   	-- remise a zero des signaux
	   	WAIT UNTIL clk'event and clk='1';
       Y1    <= (OTHERS => '0');
	    Y2    <= (OTHERS => '0');              
	   	Enable <= '0';            
       ------------------------
		 -- Attente du prochain niveau haut de l'horloge
		 
		 WAIT UNTIL clk'event and clk='1';
      END LOOP;-- attente de la fin de fichier
      ASSERT true REPORT "fin de lecture du  fichier d'entr�e" SEVERITY note;
      WAIT UNTIL cela_repart='1';
   END LOOP;      
   -- Attente l'�criture du fichier de sortie
   END PROCESS Lecture;
   
   ---------------------------------------------------------------
   -- Process gestion de l'ecriture d'un bloc 
   ---------------------------------------------------------------
   Ecriture : PROCESS
   FILE fich         : TEXT  OPEN write_mode IS "output_vhdl.txt";
   VARIABLE ibit_d   : integer;
   VARIABLE ligne    : LINE;
 
   BEGIN
	-----------------------------
	-- Initialisation des signaux
   cela_repart<='0';
	LOOP
		----------------------------
		-- On attend une donn�e valide en sortie
		WAIT UNTIL Data_V = '1';
		ASSERT true REPORT "ecriture du fichier output.txt" SEVERITY note;
	   -- On cr�e la ligne � ins�rer dans le fichier
		-- Ecrit la sortie Bit_d dans le fichier
	  	ibit_d := BIT2INT(Bit_d);
	  	WRITE(ligne,ibit_d);
	  	-- Ins�re la ligne cr�e au-dessus dans le fichier texte
	   WRITELINE(fich,ligne);
	   --On positionne cela_repart � 1 pour activer le bloc de lecture
	   WAIT UNTIL clk'event and clk='1';
	   cela_repart<='1';
	   WAIT UNTIL clk'event and clk='1';
	   cela_repart<='0';
   END LOOP;
   
   
END PROCESS Ecriture;

---------------------------------------------------------------
-- Instanciation du composant Viterbi
-- Liaison du composant et des signaux
---------------------------------------------------------------
partie_operative : viterbi PORT MAP (
	     rst => rst,      
        clk => clk,        
        Y1  => Y1,      
        Y2  => Y2,        
     Enable => Enable,  
     Bit_d  => Bit_d,
      CV_OK => CV_OK,  
       Resc => Resc,                   
     Data_V => Data_V                       
	);

    
end univ;

