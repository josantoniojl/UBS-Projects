LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity ram1bit is

	port(
		write_add, read_add : in integer;
		w_enable, clock,reset, data_in : in std_logic;
		data_out : out std_logic
	);
end ram1bit;

architecture ram1bit_Archi of ram1bit is 

	TYPE ram is array(0 to 256) of std_logic;
	signal maRam : ram := (others => '1');

begin

	process(reset,clock) 
	begin
		if(reset = '1') then
		
			maram<=(others=>'1');
		elsif (clock'event and clock='1') then
			if(w_enable = '1') then
				maRam(write_add) <= data_in;			
			end if;
			data_out <= maRam(read_add);
		end if;
	end process;

end ram1bit_Archi;
