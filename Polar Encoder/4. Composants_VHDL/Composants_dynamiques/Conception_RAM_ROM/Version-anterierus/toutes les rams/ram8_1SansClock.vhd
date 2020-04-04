LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity ram8_1SansClock is

	port(
		write_add, read_add : in integer;
		w_enable, reset : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic
	);
end ram8_1SansClock;

architecture ram8_1SansClock_Archi of ram8_1SansClock is 

	TYPE ram is array(0 to 256) of std_logic;
	signal maRam : ram := ('0', '0', '0', others => '0');

begin

	process(reset,w_enable)
	begin
		if(reset = '1') then
			maRam<=(others=>'1');
		elsif(w_enable = '1') then
			maRam(write_add) <= data_in(0);
			maRam(write_add+1) <= data_in(1);
			maRam(write_add+2) <= data_in(2);
			maRam(write_add+3) <= data_in(3);
			maRam(write_add+4) <= data_in(4);
			maRam(write_add+5) <= data_in(5);
			maRam(write_add+6) <= data_in(6);
			maRam(write_add+7) <= data_in(7);			
		else
			data_out <= maRam(read_add);
		end if;
	end process;

end ram8_1SansClock_Archi;
