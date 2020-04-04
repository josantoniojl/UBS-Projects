LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ram1_8_1_1SansClock is

	port(
		write_add, read_add_transmit, read_add_A, read_add_B : in integer;
		w_enable, transmit_enable, reset, data_in : in std_logic;
		data_out_transmit : out std_logic_vector(7 downto 0);
		data_out_A, data_out_B : out std_logic
	);
end ram1_8_1_1SansClock;

architecture ram1_8_1_1SansClock_Archi of ram1_8_1_1SansClock is 

	TYPE ram is array(0 to 256) of std_logic;
	signal maRam : ram := ('0', '0', '0', others => '0');

begin

	process(reset,w_enable, transmit_enable, write_add, read_add_transmit, read_add_A, read_add_B) -- tu peux itérer 2 fois en mode écriture avec 2 adresses différentes
	begin
		if(reset = '1') then
			maRam<=(others=>'1');
		elsif(w_enable = '1') then
				maRam(write_add) <= data_in;
			elsif(transmit_enable = '1') then
					data_out_transmit(0) <= maRam(read_add_transmit);
					data_out_transmit(1) <= maRam(read_add_transmit+1);
					data_out_transmit(2) <= maRam(read_add_transmit+2);
					data_out_transmit(3) <= maRam(read_add_transmit+3);
					data_out_transmit(4) <= maRam(read_add_transmit+4);
					data_out_transmit(5) <= maRam(read_add_transmit+5);
					data_out_transmit(6) <= maRam(read_add_transmit+6);
					data_out_transmit(7) <= maRam(read_add_transmit+7);
				else
					data_out_A <= maRam(read_add_A);
					data_out_B <= maRam(read_add_B);
		end if;
	end process;

end ram1_8_1_1SansClock_Archi;