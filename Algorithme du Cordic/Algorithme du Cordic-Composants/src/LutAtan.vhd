LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.fixed_pkg.all; 

entity LutAtan is
	generic (width_sup,width_inf: integer);
	port( cnt_s: in integer:=0;
	      SortieLut: out sfixed (width_sup-1 downto -width_inf):=(others=>'0'));
end entity;

architecture test of LutAtan is
	subtype word_t is sfixed (width_sup-1 downto -width_inf);
	type memory_t is array (0 to 13) of word_t;
	signal rom : memory_t:=( to_sfixed(0.7853981634,width_sup-1,-width_inf),
	to_sfixed(0.463647609,    width_sup-1,-width_inf ),to_sfixed(0.2449786631,   width_sup-1,-width_inf ),
	to_sfixed(0.1243549945,   width_sup-1,-width_inf ),to_sfixed(0.06241881,     width_sup-1,-width_inf ),
	to_sfixed(0.03123983343,  width_sup-1,-width_inf ),to_sfixed(0.01562372862,  width_sup-1,-width_inf ),
	to_sfixed(0.00781234106,  width_sup-1,-width_inf ),to_sfixed(0.003906230132, width_sup-1,-width_inf ),
	to_sfixed(0.001953122516, width_sup-1,-width_inf ),to_sfixed(0.0009765621896,width_sup-1,-width_inf ),
	to_sfixed(0.0004882812112,width_sup-1,-width_inf ),to_sfixed(0.0002441406201,width_sup-1,-width_inf ),
	to_sfixed(0.0001220703119,width_sup-1,-width_inf ));
begin
	process(cnt_s)
	begin
		if cnt_s<14 then --Condition pour eviter d'acceder a des address inexistants 
			SortieLut<=rom(cnt_S);
		else
			SortieLut<=(others=>'0');
		end if;
	end process;
end test;
