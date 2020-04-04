library ieee;
use ieee.std_logic_1164.all;

entity controle is
	port(
		start, clock, reset, endFbits, endXtoY, endTransmit : in std_logic;
		startFbits, startXtoY, startTransmit: out std_logic; 
		resetFbits, resetXtoY, resetTransmit : out std_logic
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
			resetFbits <= '0';
			resetXtoY <= '0';
			resetTransmit <= '0';
			
			case setat is
				when attente =>
					if(start='1') then
						startFbits <= '1';
						setat <= fbits;
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
						setat <= transmit;
					else
						setat <= XtoY;
					end if;
					
				when transmit =>
					if(endTransmit='1') then
						startTransmit <= '0';
						setat <= attente;
					else
						setat <= transmit;
					end if;
				when others =>
					setat<=attente;
			end case;
		end if;
	end process;

end Archi_controle;