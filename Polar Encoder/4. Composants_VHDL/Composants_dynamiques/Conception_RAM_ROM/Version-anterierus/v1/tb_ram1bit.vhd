LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity tb_ram1bit is
end tb_ram1bit;


architecture tb_ram1bit_Archi of tb_ram1bit is

	component ram1bit is
		port(
			write_add, read_add : in integer;
			w_enable, reset, clock, data_in : in std_logic;
			data_out : out std_logic
		);
	end component;


	signal Swrite_add, Sread_add : integer;
	signal Sdata_in, Sdata_out : std_logic;
	signal Sw_enable, Sclock, Sreset : std_logic := '0';

begin
	
	liaison : ram1bit port map(Swrite_add, Sread_add, Sw_enable, Sreset, Sclock, Sdata_in, Sdata_out);

	Sclock <= not Sclock after 5 ns;

	process 
	begin

		Sw_enable <= '0';
		Swrite_add <= 1;
		Sdata_in <= '0';
		Sread_add <= 0;
		wait for 15 ns;

		Sw_enable <= '1';
		Swrite_add <= 0;
		Sdata_in <= '1';
		Sread_add <= 1;
		wait for 15 ns;
		
		Sw_enable <= '0';
		Swrite_add <= 1;
		Sdata_in <= '0';
		Sread_add <= 0;
		wait for 15 ns;

		Sreset <= '1';

		Sw_enable <= '1';
		Swrite_add <= 2;
		Sdata_in <= '0';
		Sread_add <= 2;
		wait for 15 ns;

		Sw_enable <= '0';
		Swrite_add <= 1;
		Sdata_in <= '0';
		Sread_add <= 2;
		wait for 15 ns;

	end process;
	

end tb_ram1bit_Archi;
