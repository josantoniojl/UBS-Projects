LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity ram_encodage is

	port(
		write_add_Fb, write_add_H , read_add_transmit, read_add_Fb, read_add_H1, read_add_H2 : in integer;
		w_enable_Fb, w_enable_H, data_in_Fb, data_in_H, transmit_enable, reset, clock : in std_logic;
		data_out_transmit : out std_logic_vector(7 downto 0);
		data_out_Fb, data_out_H1, data_out_H2 : out std_logic
	);
end ram_encodage;

architecture arch_ram_encodage of ram_encodage is

	TYPE ram is array(0 to 256) of std_logic;
	signal maRam : ram := ('1', '0', '0', '0', '1', '0', '1', '0', '1', '1', '1', '1', '0', '0', '1', '1', others => '0');

begin

	process(clock, reset) 
	begin
		if(reset = '1') then
			maRam<=(others=>'1');
		elsif(clock'event and clock='1') then
		
			if(w_enable_Fb = '1') then
				maRam(write_add_Fb) <= data_in_Fb;
			elsif(w_enable_H = '1') then
				maRam(write_add_H) <= data_in_H;
			end if;
				
			if(transmit_enable = '1') then
				data_out_transmit(0) <= maRam(read_add_transmit);
				data_out_transmit(1) <= maRam(read_add_transmit+1);
				data_out_transmit(2) <= maRam(read_add_transmit+2);
				data_out_transmit(3) <= maRam(read_add_transmit+3);
				data_out_transmit(4) <= maRam(read_add_transmit+4);
				data_out_transmit(5) <= maRam(read_add_transmit+5);
				data_out_transmit(6) <= maRam(read_add_transmit+6);
				data_out_transmit(7) <= maRam(read_add_transmit+7);
			end if;
			
			data_out_Fb <= maRam(read_add_Fb);
			data_out_H1 <= maRam(read_add_H1);
			data_out_H2 <= maRam(read_add_H2);
			
		end if;
	end process;

end arch_ram_encodage;
