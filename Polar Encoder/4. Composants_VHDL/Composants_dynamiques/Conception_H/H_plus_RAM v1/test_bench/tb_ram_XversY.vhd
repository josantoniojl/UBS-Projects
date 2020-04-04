LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity tb_ram_XversY is
end tb_ram_XversY;


architecture tb_ram_XversY_Archi of tb_ram_XversY is

	component ram1_8_1_1AvecClock is
		port(
			write_add, read_add_transmit, read_add_A, read_add_B : in integer;
			w_enable, transmit_enable, reset, clock, data_in : in std_logic;
			data_out_transmit : out std_logic_vector(7 downto 0);
			data_out_A, data_out_B : out std_logic
		);
	end component;
	
	
	component Hadamard is 
		port(
			clk,rst,start : in std_logic;
			logM: in integer;
			sortieRamA, sortieRamB : in std_logic;
			read_add_A, read_add_B, write_add : out integer;
			w_enable, enableTraitement : out std_logic;
			sortie : out std_logic
		);
	end component; 

	signal Sstart, SenableTraitement, Sinutile6 : std_logic; 
	signal SlogM, Sinutile4 : integer;
	signal Sinutile5 : std_logic_vector(7 downto 0);

	signal Swrite_add, Sread_add_A, Sread_add_B : integer;
	signal SsortieRamA, SsortieRamB : std_logic;
	signal Sw_enable, Sclock, Sreset, Ssortie : std_logic := '0';

begin 
	
	liaisonRam : ram1_8_1_1AvecClock port map(Swrite_add, Sinutile4, Sread_add_A, Sread_add_B, Sw_enable, Sinutile6, Sreset, Sclock, Ssortie, Sinutile5, SsortieRamA, SsortieRamB);
	liaisonXversY : Hadamard port map(Sclock, Sreset, Sstart, SlogM, SsortieRamA, SsortieRamB, Sread_add_A, Sread_add_B, Swrite_add, Sw_enable, SenableTraitement, Ssortie);
	
	Sclock <= not Sclock after 5 ns;

	process 
	begin
		SlogM <= 4; -- msg de 16bits
		wait for 20 ns;
		Sstart <= '1';
		wait for 50 ns;
		Sstart <= '0';
		wait for 1500 ns;
		
		
		SlogM <= 3; -- msg de 8bits
		
		Sstart <= '1';
		wait for 50 ns;
		Sstart <= '0';
		wait for 600 ns;
		
		

	end process;
	

end tb_ram_XversY_Archi;
