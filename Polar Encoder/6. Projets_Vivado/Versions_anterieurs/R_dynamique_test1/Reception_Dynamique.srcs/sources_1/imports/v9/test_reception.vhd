LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity test_reception is
	port(
		clk,data_out,start: in std_logic;
		Sk: in integer;
		add_lec: out integer;
		sortie: out std_logic_vector(7 downto 0));	
end test_reception;



architecture test_reception_Archi of test_reception is 

signal Ssortie: std_logic_vector(7 downto 0):= (others=>'0');
type etat is (lecture,synchro,donne,fin);
signal Setat : etat := lecture;
signal Ssk,sadd_lec:integer:=0;
begin

	process(clk) 
	variable adresse : integer :=0;
	begin
		if(clk'event and clk='1') then
		 case Setat is
			when lecture =>
				if(start='1') then
					sadd_lec<=adresse;
					--sortie(7)<='1';
					Setat<= synchro;
				else
				    Setat<= lecture;
				end if;

			when synchro =>
			    Ssk<=Sk;
			    --sortie(6)<='1';
				Setat<= donne;
			when donne =>
			      --sortie(4 downto 0)<=std_logic_vector(to_unsigned(Sk,5));
				if(adresse<=Ssk) then
					Ssortie(adresse)<=data_out;
					adresse:=adresse+1;
					Setat<= lecture;
                else					
					Setat<= fin;
				end if;
			when fin =>
			   --  sortie<=std_logic_vector(to_unsigned(Ssk,8));
				sortie<=Ssortie;
				--sortie(5)<='1';
				Setat<= fin;
				adresse:=0;
				sadd_lec<=0;
			when others=>
			Setat<=lecture;
		end case;
		end if;
	add_lec<=sadd_lec;
	end process;
end test_reception_Archi;

