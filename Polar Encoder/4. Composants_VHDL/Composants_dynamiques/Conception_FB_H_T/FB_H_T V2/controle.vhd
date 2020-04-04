library ieee;
use ieee.std_logic_1164.all;

entity controle is
	port(
		boutton, clock, reset, end_fbits, end_hadamard, end_transmit : in std_logic;
		start_fbits, start_hadamard, start_transmit : out std_logic; 
		reset_fbits, reset_hadamard: out std_logic 
	);
end controle;


architecture Archi_controle of controle is

	type etat is (reception, fbits, Hadamard, transmit, Fin);
	signal setat : etat := reception;

begin

	process(clock, reset)
	variable Sstart: std_logic:='0';	
	begin
		if(reset='1') then
			start_fbits <= '0';
			start_hadamard <= '0';
			reset_fbits <= '1';
			reset_hadamard <= '1';
			Sstart:= '0';
			setat <= reception;
		elsif(clock'event and clock='1') then
			reset_fbits <= '0';
			reset_hadamard <= '0';
			
			case setat is
				when reception =>
                    start_fbits <= '0';
                    start_hadamard <= '0';
					start_transmit <= '0';
				    if(boutton = '1') then					
				        start_fbits <= '1';
			            setat <= fbits;
					else
						setat <= reception;
					end if;
					
				when fbits =>
					if(end_fbits='1') then
						start_fbits <= '0';
						start_hadamard <= '1';
						setat <= Hadamard;
					else
						setat <= fbits;
					end if;
					
				when Hadamard =>
					if(end_hadamard='1') then
						start_transmit <= '1';
						setat <=  transmit;
					else
						start_hadamard <= '0'; 
						setat <= Hadamard;
					end if;

				when transmit =>
					if(end_transmit = '1') then
						start_transmit <= '0';
						setat <= Fin;
					else
						setat <= transmit;
					end if;

				when Fin =>
					setat<=Fin;			

				when others =>
					setat<=reception;
			end case;
		end if;
	end process;

end Archi_controle;