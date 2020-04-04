library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity test_general is

end entity;

architecture test_gen of test_general is

	component toplevel is
		port(
			btn1,btn0,clk: in std_logic;	--supprimer btn1 aussi sur contraintes
			outputMsg : out std_logic_vector(0 to 15));
	end component ;

	signal Sbtn1,Sbtn0,Sclk:std_logic:='0';	--supprimer btn1 aussi sur contraintes
	signal SoutputMsg : std_logic_vector(0 to 15);
	begin
		l_test: toplevel port map (Sbtn1,Sbtn0,Sclk,SoutputMsg);
		Sclk<= not Sclk after 5 ns;
		process
			begin
				sbtn0<='0';
				sbtn1<='1';
				wait for 2000 ns;
		end process;
end architecture;
