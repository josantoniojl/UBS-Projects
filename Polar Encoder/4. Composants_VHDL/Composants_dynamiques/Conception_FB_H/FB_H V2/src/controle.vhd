library ieee;
use ieee.std_logic_1164.all;

entity controle is
	port(
		boutton, clock, reset, endFbits, endHadamard : in std_logic;
		startFbits, startHadamard: out std_logic; 
		resetFbits, resetHadamard: out std_logic);
end controle;


architecture Archi_controle of controle is

	type etat is (reception, fbits, Hadamard, Fin);
	signal setat : etat := reception;

begin

	process(clock, reset)
	variable Sstart: std_logic:='0';
	begin
		if(reset='1') then
			setat <= reception;
			startFbits <= '0';
			startHadamard <= '0';
			resetFbits <= '1';
			resetHadamard <= '1';
			Sstart:= '0';
		elsif(clock'event and clock='1') then
			resetFbits <= '0';
			resetHadamard <= '0';
			
			case setat is
				when reception =>
                    startFbits <= '0';
                    startHadamard <= '0';
				    if(boutton = '1') then					
				        startFbits <= '1';
			            setat <= fbits;
					else
						setat <= reception;
					end if;
					
				when fbits =>
					if(endFbits='1') then
						startFbits <= '0';
						startHadamard <= '1';
						setat <= Hadamard;
					else
						setat <= fbits;
					end if;
					
				when Hadamard =>
					if(endHadamard='1') then
						setat <=  Fin;
					else
						setat <= Hadamard;
					startHadamard <= '0';
					end if;
				when Fin =>
					setat<=Fin;			
					
				when others =>
					setat<=reception;
			end case;
		end if;
	end process;

end Archi_controle;