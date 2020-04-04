library IEEE;
use IEEE.std_logic_1164.ALL;

entity global is
	generic (k :integer:= 4; n :integer:= 7; fb :integer:= 3);
end global;

architecture Archi_global of global is

	component toplevel is
		generic (k :integer; n :integer; fb :integer);
		port(
			sw: in std_logic_vector(0 to k);
			btn0,btn1,clk: in std_logic;
			outputMsg : out std_logic_vector(0 to n);
			TxD,TxD_debug,transmit_debug,button_debug,clk_debug: out std_logic
		);
	end component;

	signal Ssw : std_logic_vector(0 to k);
	signal Sbtn0, Sbtn1, Sclk, STxD, STxD_debug, Stransmit_debug, Sbutton_debug, Sclk_debug : std_logic := '0';
	signal SoutputMsg : std_logic_vector(0 to n);
	
begin

	liaison : toplevel generic map (k=>k, n=>n, fb=>fb) port map (Ssw, Sbtn0, Sbtn1, Sclk, SoutputMsg, STxD, STxD_debug, Stransmit_debug, Sbutton_debug, Sclk_debug);

	Sclk <= not Sclk after 5 ns;

	process
	begin
		Ssw <= "11001";
		wait for 20 ns;
		Sbtn1 <= '1';
	end process;
	
end Archi_global;