library ieee;
use ieee.std_logic_1164.all;

entity controle is
	port(
		endreception, clock, reset, endFbits, endHadamard, endTransmit : in std_logic;
		startreception, startFbits, startHadamard, startTransmit: out std_logic; 
		resetFbits, resetHadamard, resetTransmit : out std_logic
	);
end controle;


architecture Archi_controle of controle is

	type etat is (reception, fbits, Hadamard, transmit);
	signal setat : etat := reception;

begin

	process(clock, reset)
	variable Sstart: std_logic:='0';
	begin
		if(reset='1') then
			setat <= reception;
			startreception<='1';
			startFbits <= '0';
			startHadamard <= '0';
			startTransmit <= '0';
			resetFbits <= '1';
			resetHadamard <= '1';
			resetTransmit <= '1';
			Sstart:= '0';
		elsif(clock'event and clock='1') then
			resetFbits <= '0';
			resetHadamard <= '0';
			resetTransmit <= '0';
			
			case setat is
				when reception =>
                    startreception<='1';
                    startFbits <= '0';
                    startHadamard <= '0';
                    startTransmit <= '0';
				    if(endreception = '1') then					
                        startreception<='0';
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
						startHadamard <= '0';
						startTransmit <= '1';
						setat <=  transmit;
					else
						setat <= Hadamard;
					end if;
					
				when transmit =>
					if(endTransmit='1') then
						startTransmit <= '0';
						setat <= reception;
					else
						setat <= transmit;
					end if;
				when others =>
					setat<=reception;
			end case;
		end if;
	end process;

end Archi_controle;