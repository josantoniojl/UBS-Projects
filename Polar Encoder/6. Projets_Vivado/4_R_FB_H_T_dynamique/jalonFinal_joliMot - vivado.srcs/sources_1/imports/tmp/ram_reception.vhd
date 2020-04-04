LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity ram_reception is
	port(
	
		w_addr_rec, r_addr_rec : in integer;
		w_enable_rec, reset, clock : in std_logic;
		in_rec : in std_logic_vector(7 downto 0);
		out_rec : out std_logic);
end ram_reception;



architecture ram_reception_Archi of ram_reception is 

	TYPE ram is array(0 to 256) of std_logic;
	signal maRam : ram := (others => '0');

begin

	process(clock, reset) 
	begin
		if(reset = '1') then
			maRam<=(others=>'1');
			
		elsif(clock'event and clock='1') then
				if(w_enable_rec = '1') then
					maRam(w_addr_rec) <= in_rec(0);
					maRam(w_addr_rec+1) <= in_rec(1);
					maRam(w_addr_rec+2) <= in_rec(2);
					maRam(w_addr_rec+3) <= in_rec(3);
					maRam(w_addr_rec+4) <= in_rec(4);
					maRam(w_addr_rec+5) <= in_rec(5);
					maRam(w_addr_rec+6) <= in_rec(6);
					maRam(w_addr_rec+7) <= in_rec(7);
				end if;
				out_rec <= maRam(r_addr_rec);
		end if;
	end process;

end ram_reception_Archi;

