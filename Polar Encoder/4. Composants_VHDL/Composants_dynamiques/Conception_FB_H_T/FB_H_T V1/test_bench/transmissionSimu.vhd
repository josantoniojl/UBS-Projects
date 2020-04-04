library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity transmissionSimu is
	port(
		start, clk: in std_logic;
		sortieRam : in std_logic_vector(0 to 7);
		logM : in integer;
		end_transmit, read_transmit_enable : out std_logic;
		read_add_transmit : out integer;
		outputMsg : out std_logic_vector(0 to 15)
	);
end transmissionSimu;

architecture transmissionSimu_Archi of transmissionSimu is
	type etat is(attrape, att, stock, fin);
	signal Setat : etat := attrape;
	signal SoutputMsg : std_logic_vector(0 to 15);
begin

	process (clk)
		variable i : integer := 23;
	begin
		if(clk'event and clk = '1') then
			if(start = '1') then
				case Setat is
					when attrape =>
						i:=i-8;
						read_transmit_enable <= '1';
						end_transmit <= '0';
						read_add_transmit <= i;
						Setat <= att;
					
					when att =>
						Setat <= stock;
						
					when stock =>
						SoutputMsg(i-7 to i) <= sortieRam;
						if(i < 8) then
							Setat <= fin;
						else
							Setat <= attrape;
						end if;
						
					when fin =>
						read_transmit_enable <= '0';
						end_transmit <= '1';
						Setat <= fin;
						
				end case;
			end if;
		end if;
		outputMsg <= SoutputMsg;
	end process;
	
end transmissionSimu_Archi;