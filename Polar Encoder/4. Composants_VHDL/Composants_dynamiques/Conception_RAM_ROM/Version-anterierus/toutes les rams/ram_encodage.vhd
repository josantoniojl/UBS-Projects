LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity ram_encodage is

	port(
		write_add, read_add_transmit, read_add_A, read_add_B : in integer;
		w_enable, transmit_enable, reset, clock, data_in : in std_logic;
		data_out_transmit : out std_logic_vector(7 downto 0);
		data_out_A, data_out_B : out std_logic
	);
end ram_encodage ;

architecture ram_encodage  of ram_encodage  is 

	TYPE ram is array(0 to 256) of std_logic;
	signal maRam : ram := (others => '1');

begin

	process(clock, reset) 
	begin
		if(reset = '1') then
			maRam<=(others=>'1');
		elsif(clock'event and clock='1') then
		
			if(w_enable = '1') then
				maRam(write_add) <= data_in;
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
			
			data_out_A <= maRam(read_add_A);
			data_out_B <= maRam(read_add_B);
			
		end if;
	end process;

end ram_encodage ;

