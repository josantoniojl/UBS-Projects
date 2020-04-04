LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity ram_encodage is

	port(
		w_addr_enc_fb, w_addr_enc_H , r_addr_enc_T, r_addr_enc_fb, r_addr_enc_H1, r_addr_enc_H2 : in integer;
		w_enable_enc_fb, w_enable_enc_H, in_enc_fb, in_enc_H, r_enable_enc_T, reset, clock : in std_logic;
		out_enc_T : out std_logic_vector(0 to 7);
		out_enc_fb, out_enc_H1, out_enc_H2 : out std_logic
	);
end ram_encodage;

architecture arch_ram_encodage of ram_encodage is

	TYPE ram is array(0 to 256) of std_logic;
	signal maRam : ram := ('0', '1', '1', '0', '1', '0', '1', '0', '1', '1', '1', '1', '0', '0', '0', '0', others => '0');

begin

	process(clock, reset) 
	begin
		if(reset = '1') then
			maRam<=(others=>'1');
		elsif(clock'event and clock='1') then
		
			if(w_enable_enc_fb = '1') then
				maRam(w_addr_enc_fb) <= in_enc_fb;
			elsif(w_enable_enc_H = '1') then
				maRam(w_addr_enc_H) <= in_enc_H;
			end if;
				
			if(r_enable_enc_T = '1') then
				out_enc_T(0) <= maRam(r_addr_enc_T);
				out_enc_T(1) <= maRam(r_addr_enc_T-1);
				out_enc_T(2) <= maRam(r_addr_enc_T-2);
				out_enc_T(3) <= maRam(r_addr_enc_T-3);
				out_enc_T(4) <= maRam(r_addr_enc_T-4);
				out_enc_T(5) <= maRam(r_addr_enc_T-5);
				out_enc_T(6) <= maRam(r_addr_enc_T-6);
				out_enc_T(7) <= maRam(r_addr_enc_T-7);
			end if;
			
			out_enc_fb <= maRam(r_addr_enc_fb);
			out_enc_H1 <= maRam(r_addr_enc_H1);
			out_enc_H2 <= maRam(r_addr_enc_H2);
			
		end if;
	end process;

end arch_ram_encodage;
