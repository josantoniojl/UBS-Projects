library ieee;
use ieee.std_logic_1164.all;

entity controle is
	port(
		endreception, clock, reset, endFbits, endXtoY, endTransmit : in std_logic;
		startreception, startFbits, startXtoY, startTransmit: out std_logic; 
		resetFbits, resetXtoY, resetTransmit : out std_logic
	);
end controle;


architecture Archi_controle of controle is

	type etat is (attente, reception, fbits, XtoY, transmit);--, temp);
	signal setat : etat := attente;

begin

	process(clock, reset)
	variable Sstart: std_logic:='0';
	begin
		if(reset='1') then
			setat <= attente;
			startreception<='1';
			startFbits <= '0';
			startXtoY <= '0';
			startTransmit <= '0';
			resetFbits <= '1';
			resetXtoY <= '1';
			resetTransmit <= '1';
			Sstart:= '0';
		elsif(clock'event and clock='1') then
			resetFbits <= '0';
			resetXtoY <= '0';
			resetTransmit <= '0';
			
			case setat is
				when attente =>
	       		startreception<='1';               
                startFbits <= '0';
			    startXtoY <= '0';
                startTransmit <= '0';
				    if(endreception = '1') then
                        startreception<='0';               
				        startFbits <= '1';
			            setat <= fbits;
--                    end if;
--                    if(start = '0' and Sstart = '1')then
--				        startFbits <= '1';
--				        Sstart:= '0';
--						setat <= fbits;
					else
						setat <= attente;
					end if;
					
				when fbits =>
					if(endFbits='1') then
						startFbits <= '0';
						startXtoY <= '1';
						setat <= XtoY;
					else
						setat <= fbits;
					end if;
					
				when XtoY =>
					if(endXtoY='1') then
						startXtoY <= '0';
						startTransmit <= '1';
						setat <=  transmit;
					else
						setat <= XtoY;
					end if;
					
				when transmit =>
					if(endTransmit='1') then
						--startTransmit <= '0';
						startreception<='1';
						setat <= transmit;
					else
						setat <= transmit;
					end if;
					
--					when temp =>
--                        if(start = '1') then
--                            Sstart:= '';
--                        end if;
--                        if(start = '0' and Sstart = '1')then
--                            setat <= temp;
--                            Sstart:='0';

                        
--                        end if;
					
				when others =>
					setat<=attente;
			end case;
		end if;
	end process;

end Archi_controle;