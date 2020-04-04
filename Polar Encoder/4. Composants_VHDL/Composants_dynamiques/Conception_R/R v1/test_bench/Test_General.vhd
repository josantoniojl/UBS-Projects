library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity test_general is

end entity;

architecture test_gen of test_general is

	component toplevel is
		port(
			btn1,btn0,RxD,clk: in std_logic;	
			outputMsg : out std_logic_vector(0 to 7));
	end component ;

	signal Sbtn1,Sbtn0,Sclk,SRxD:std_logic:='0';	--supprimer btn1 aussi sur contraintes
	signal SoutMsg: std_logic_vector(0 to 7);
	begin
		l_test: toplevel port map (Sbtn1,Sclk,SRxD,Sclk,SoutMsg);
		Sclk<= not Sclk after 5 ns;
		process
			begin
				sbtn1<='1';
				wait for 100000 ns;
		end process;
end architecture;
