library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ceil;

entity UART_RX is
	generic (g_CLKS_PER_BIT : integer := 10416 );
	port (	i_Clk, start: in std_logic;
			i_RX_Serial : in std_logic;
			enable, enable_reception : out std_logic;
			o_RX_Byte,in_ram : out std_logic_vector(7 downto 0);
			add_reception,Sk,Sn,SlogM: out integer);
end UART_RX;
 
 
architecture arch_uartrx of UART_RX is
 
	type t_SM_Main is (s_Idle, s_RX_Start_Bit, s_RX_Data_Bits,
	s_RX_Stop_Bit, Compteur, s_Cleanup);
	signal r_SM_Main : t_SM_Main := s_Idle;
	 
	signal r_RX_Data_R : std_logic := '0';
	signal r_RX_Data : std_logic := '0';

	signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
	signal r_Bit_Index : integer range 0 to 7 := 0;-- 8 Bits Total
	signal r_RX_Byte : std_logic_vector(7 downto 0) := (others => '0');
	signal r_RX_DV : std_logic := '0';
	signal add_recep:integer :=0;
	--signal Sk:integer :=0;
	signal enable_recp: std_logic :='0';
	 
	begin
	 
	-- Purpose: Double-register the incoming data.
	-- This allows it to be used in the UART RX Clock Domain.
	-- (It removes problems caused by metastabiliy)
	p_SAMPLE : process (i_Clk)
	begin
		if(i_Clk'event and i_Clk='1') then
			if start='1' then
				r_RX_Data_R <= i_RX_Serial;
				r_RX_Data <= r_RX_Data_R;
			end if;
		end if;
	end process p_SAMPLE;
	 
	 
	-- Purpose: Control RX state machine
	p_UART_RX : process (i_Clk)
	variable compteur_general,compteur_donnees,arret_boucle,stop,tempSk : integer :=0;
	begin
		if(i_Clk'event and i_Clk='1') then
			case r_SM_Main is
			 
				when s_Idle =>
					r_RX_DV <= '0';
					r_Clk_Count <= 0;
					r_Bit_Index <= 0;
					if r_RX_Data = '0' and start='1' then-- Start bit detected
						r_SM_Main <= s_RX_Start_Bit;
					else
						r_SM_Main <= s_Idle;
				end if;
				 

				 -- Check middle of start bit to make sure it's still low
				when s_RX_Start_Bit =>
					if r_Clk_Count = (g_CLKS_PER_BIT-1)/2 then
						if r_RX_Data = '0' then
							r_Clk_Count <= 0;-- reset counter since we found the middle
							r_SM_Main <= s_RX_Data_Bits;
						else
							r_SM_Main <= s_Idle;
						end if;
					else
						r_Clk_Count <= r_Clk_Count + 1;
						r_SM_Main <= s_RX_Start_Bit;
					end if;
				 

				 -- Wait g_CLKS_PER_BIT-1 clock cycles to sample serial data
				when s_RX_Data_Bits =>
					if r_Clk_Count < g_CLKS_PER_BIT-1 then
						r_Clk_Count <= r_Clk_Count + 1;
						r_SM_Main <= s_RX_Data_Bits;
					else
						r_Clk_Count <= 0;
						r_RX_Byte(r_Bit_Index) <= r_RX_Data;

						-- Check if we have sent out all bits
						if r_Bit_Index < 7 then
							r_Bit_Index <= r_Bit_Index + 1;
							r_SM_Main <= s_RX_Data_Bits;
						else
							r_Bit_Index <= 0;
							r_SM_Main <= s_RX_Stop_Bit;
						end if;
					end if;
				 				 
				 -- Receive Stop bit.Stop bit = 1
				 when s_RX_Stop_Bit =>
				 -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
					if r_Clk_Count < g_CLKS_PER_BIT-1 then
						r_Clk_Count <= r_Clk_Count + 1;
						r_SM_Main <= s_RX_Stop_Bit;
					else
						r_Clk_Count <= 0;
						r_SM_Main <= Compteur;
					end if;
				 
				 -- Stay here 1 clock
				when Compteur =>
				compteur_general:=compteur_general+1;
				enable_recp<='1';
					if(compteur_general=1)then
						tempSk:= to_integer(unsigned(r_RX_Byte));
						Sk<=to_integer(unsigned(r_RX_Byte))-1;
						if (tempSk mod 8 = 0) then
						  stop:= tempSk/8;
						else
						  stop:=(tempSk/8)+1;
						end if;						
						r_SM_Main <= s_Idle;
					elsif(compteur_general=2)then
						Sn<=to_integer(unsigned(r_RX_Byte))-1;
						r_SM_Main <= s_Idle;
					elsif(compteur_general=3)then
						SlogM<=to_integer(unsigned(r_RX_Byte));
						r_SM_Main <= s_Idle;
					else
						add_recep<=(compteur_donnees*8);
						in_ram<=r_RX_Byte;
						compteur_donnees:=compteur_donnees+1;
						if(compteur_donnees >= stop) then
							enable_recp<='0';
							r_RX_DV <= '1';
							r_SM_Main <= s_Cleanup;							
						else
						     r_SM_Main <= s_Idle;
						end if;	
					end if;
					
				when s_Cleanup =>
					compteur_general:=0;
					compteur_donnees:=0;
					stop:=0;
					tempSk:=0;
					r_RX_DV <= '1';
				    r_SM_Main <= s_Cleanup;
				when others =>
					r_SM_Main <= s_Idle;
				 
			end case;
		end if;
	end process p_UART_RX;
	enable_reception<=enable_recp; 
	add_reception<=add_recep;
	enable <= r_RX_DV;
	o_RX_Byte <= r_RX_Byte;
 
end arch_uartrx;
