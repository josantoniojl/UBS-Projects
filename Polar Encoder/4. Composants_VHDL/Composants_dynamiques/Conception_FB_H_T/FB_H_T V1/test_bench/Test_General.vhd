library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity test_general is
	generic ( g_CLKS_PER_BIT : integer := 10416);
end entity;

architecture test_gen of test_general is

	component toplevel is
		generic ( g_CLKS_PER_BIT : integer);
		port(
			btn1,btn0,clk: in std_logic;	--supprimer btn1 aussi sur contraintes
			outputMsg : out std_logic_vector(0 to 15));
	end component ;

	signal Sbtn1,Sbtn0,Sclk:std_logic:='0';	--supprimer btn1 aussi sur contraintes
	signal SoutputMsg : std_logic_vector(0 to 15);
	begin
		l_test: toplevel generic map (g_CLKS_PER_BIT => g_CLKS_PER_BIT) port map (Sbtn1,Sbtn0,Sclk,SoutputMsg);
		Sclk<= not Sclk after 5 ns;
		process
			begin
				sbtn0<='0';
				sbtn1<='1';
				wait for 200 ns;
				sbtn1 <= '0';
				wait for 2500 ns;
		end process;
end architecture;
