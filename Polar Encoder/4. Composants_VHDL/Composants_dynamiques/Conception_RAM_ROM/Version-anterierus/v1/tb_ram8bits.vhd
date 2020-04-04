LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity tb_ram8bits is
end tb_ram8bits;


architecture tb_ram8bits_Archi of tb_ram8bits is

	component ram8bits is
		port(
			write_add, read_add : in integer;
			w_enable, reset, clock : in std_logic;
			data_in : in std_logic_vector(7 downto 0);
			data_out : out std_logic_vector(7 downto 0)
		);
	end component;


	signal Swrite_add, Sread_add : integer;
	signal Sdata_in, Sdata_out : std_logic_vector(7 downto 0);
	signal Sw_enable, Sclock, Sreset : std_logic := '0';

begin
	
	liaison : ram8bits port map(Swrite_add, Sread_add, Sw_enable, Sreset, Sclock, Sdata_in, Sdata_out);

	Sclock <= not Sclock after 5 ns;

	process 
	begin

		Sw_enable <= '0';
		Swrite_add <= 1;
		Sdata_in <= "11111111";
		Sread_add <= 0;
		wait for 15 ns;

		Sw_enable <= '1';
		Swrite_add <= 0;
		Sdata_in <= "01010101";
		Sread_add <= 1;
		wait for 15 ns;
		
		Sw_enable <= '0';
		Swrite_add <= 1;
		Sdata_in <= "11111111";
		Sread_add <= 0;
		wait for 15 ns;

		Sreset <= '1';

		Sw_enable <= '1';
		Swrite_add <= 2;
		Sdata_in <= "11110000";
		Sread_add <= 2;
		wait for 15 ns;

		Sw_enable <= '0';
		Swrite_add <= 1;
		Sdata_in <= "11111111";
		Sread_add <= 2;
		wait for 15 ns;

	end process;
	

end tb_ram8bits_Archi;
