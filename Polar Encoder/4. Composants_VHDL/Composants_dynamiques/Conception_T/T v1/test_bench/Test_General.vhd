library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity test_general is

end entity;

architecture test_gen of test_general is

	component toplevel is
		port(
			btn0,clk: in std_logic;	--supprimer btn1 aussi sur contraintes
			TxD : out std_logic);
	end component ;

	signal Sbtn1,Sclk,STxD:std_logic:='0';	--supprimer btn1 aussi sur contraintes
	begin
		l_test: toplevel port map (Sbtn1,Sclk,STxD);
		Sclk<= not Sclk after 5 ns;
		process
			begin
				sbtn1<='1';
				wait for 100000 ns;
		end process;
end architecture;
