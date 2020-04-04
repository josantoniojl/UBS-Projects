LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;


entity tbPolarEncoder is
	generic (k :integer:= 3; n :integer:= 7; fb :integer:= 4);
end tbPolarEncoder;


architecture Archi_tbPolarEncoder of tbPolarEncoder is

	component polarEncoder is
		generic (k,n,fb:integer);
		port(
			clock, reset, start : in std_logic;
			inputMsg : in std_logic_vector(0 to k);
			outputMsg : out std_logic_vector(0 to n)
		);
	end component;
	
	signal Sclock, Sreset, Sstart : std_logic := '0';
	signal SinputMsg : std_logic_vector(0 to k);
	signal SoutputMsg : std_logic_vector(0 to n);
	
begin
	
	liaison : polarEncoder generic map (k=>k,n=>n,fb=>fb) port map (Sclock, Sreset, Sstart, SinputMsg, SoutputMsg);
	
	Sclock <= not Sclock after 5 ns;
	
	process
	begin
		Sreset<= '0';
		SinputMsg <= "1010";
		Sstart <= '1';
		wait for 350 ns;
	end process;
	
end Archi_tbPolarEncoder;

