library ieee;
use ieee.std_logic_1164.all;

entity controle is
	port(
		start, clock, reset, endFbits, endXtoY, endTransmit : in std_logic;
		startFbits, startXtoY, startTransmit, resetFbits, resetXtoY, resetTransmit : out std_logic
	);
end controle;


architecture Archi_controle of controle is

	type etat is (attente, fbits, XtoY, transmit);
	signal setat : etat := attente;

begin

	process(clock, reset)
	begin
		if(reset='1') then
			setat <= attente;
			startFbits <= '0';
			startXtoY <= '0';
			startTransmit <= '0';
			resetFbits <= '1';
			resetXtoY <= '1';
			resetTransmit <= '1';
		elsif(clock'event and clock='1') then
			case setat is
				when attente =>
					if(start='1') then
						setat <= fbits;
						startFbits <= '1';
					else
						setat <= attente;
					end if;
					
				when fbits =>
					if(endFbits='1') then
						setat <= XtoY;
						startXtoY <= '1';
					else
						setat <= fbits;
					end if;
					
				when XtoY =>
					if(endXtoY='1') then
						setat <= transmit;
						startTransmit <= '1';
					else
						setat <= XtoY;
					end if;
					
				when transmit =>
					if(endTransmit='1') then
						setat <= attente;
						startFbits <= '0';
						startXtoY <= '0';
						startTransmit <= '0';
					else
						setat <= transmit;
					end if;
					
			end case;
		end if;
	end process;

end Archi_controle;