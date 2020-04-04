----------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
----------------------------------------------------------------------
-- This file contains the UART Transmitter.  This transmitter is able
-- to transmit 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When transmit is complete enable will be
-- driven high for one clock cycle.
--
-- Set Generic g_CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of clock)/(Frequency of UART)
-- Example: 10 MHz Clock, 115200 baud UART
-- (10000000)/(115200) = 87
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity UART_TX is
	generic ( g_CLKS_PER_BIT : integer);
	port (
		start, clock : in  std_logic;
		out_enc_T : in  std_logic_vector(7 downto 0);
		n : in integer;
		end_T, r_enable_enc_T : out std_logic;
		r_addr_enc_T: out integer;
		TxD : out std_logic
	);
end UART_TX;
 
 
architecture Archi_UART_TX of UART_TX is
 
type t_SM_Main is (r_donnes,synchro,Recuperation_RAM, s_TX_Start_Bit, s_TX_Data_Bits,
				   s_TX_Stop_Bit,compteur,fin);
signal r_SM_Main : t_SM_Main := r_donnes;
signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
signal r_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
signal stransmite_enable : std_logic := '0';

signal Sadd_transmit: integer :=0;

begin
	 	   
	p_UART_TX : process (clock)
	variable vcompteur : integer :=0;
	variable arret_boucle:integer :=0;
	begin
	arret_boucle:=(n+1)/8;
		if rising_edge(clock) then	 
			case r_SM_Main is
				when r_donnes => --Recuperation des octets de la RAM		
                   TxD <= '1';         -- Drive Line High for Idle
                   end_T   <= '0';
					r_Clk_Count <= 0;
					r_Bit_Index <= 0;			
					if start= '1' then
						Sadd_transmit<=n-(8*vcompteur); --Acces au registre precis 
						stransmite_enable<='1';-- Lecture mode RAM activée
						r_SM_Main <= synchro;
					else
						Sadd_transmit<=n-1;
			            stransmite_enable<='0';	
						r_SM_Main <= r_donnes;
					end if;
				when synchro =>
					r_SM_Main <= Recuperation_RAM;

				when Recuperation_RAM =>
					r_TX_Data <= out_enc_T;
					stransmite_enable<='0';
					r_SM_Main <= s_TX_Start_Bit;
					-- Send out Start Bit. Start bit = 0
				when s_TX_Start_Bit =>
					TxD <= '0'; 
					-- Wait g_CLKS_PER_BIT-1 clock cycles for start bit to finish
					if r_Clk_Count < g_CLKS_PER_BIT-1 then
						r_Clk_Count <= r_Clk_Count + 1;
						r_SM_Main   <= s_TX_Start_Bit;
					else
						r_Clk_Count <= 0;
						r_SM_Main   <= s_TX_Data_Bits;
					end if;
							
				-- Wait g_CLKS_PER_BIT-1 clock cycles for data bits to finish          
				when s_TX_Data_Bits =>
					TxD <= r_TX_Data(r_Bit_Index);
						
					if r_Clk_Count < g_CLKS_PER_BIT-1 then
						r_Clk_Count <= r_Clk_Count + 1;
						r_SM_Main   <= s_TX_Data_Bits;
					else
						r_Clk_Count <= 0;         
								-- Check if we have sent out all bits
						if r_Bit_Index < 7 then
							r_Bit_Index <= r_Bit_Index + 1;
							r_SM_Main   <= s_TX_Data_Bits;
						else
							r_Bit_Index <= 0;
							r_SM_Main   <= s_TX_Stop_Bit;
						end if;
					end if;
				-- Send out Stop bit.  Stop bit = 1
				when s_TX_Stop_Bit =>
					TxD <= '1';
					-- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
					if r_Clk_Count < g_CLKS_PER_BIT-1 then
						r_Clk_Count <= r_Clk_Count + 1;
						r_SM_Main   <= s_TX_Stop_Bit;
					else
						r_Clk_Count <= 0;
						r_SM_Main   <= compteur;
					end if;
						  
				when compteur =>
					if(vcompteur<arret_boucle-1) then
						vcompteur:=vcompteur+1; --Selon la quanité de donées on repete le process
						r_SM_Main <= r_donnes;
					else
						end_T   <= '1';
						r_SM_Main <= fin;
					end if;
				when fin =>
					vcompteur:=0;
					r_SM_Main <= r_donnes;
				when others =>
				    r_SM_Main <= r_donnes;
			end case;
		end if;
	end process p_UART_TX; 
	r_enable_enc_T<= stransmite_enable;
  	r_addr_enc_T<=Sadd_transmit;
end Archi_UART_TX;
-- -- -- -- --------------------------------------------------------------------
-- -- -- -- File Downloaded from http://www.nandland.com
-- -- -- -- --------------------------------------------------------------------
-- -- -- -- This file contains the UART Transmitter.  This transmitter is able
-- -- -- -- to transmit 8 bits of serial data, one start bit, one stop bit,
-- -- -- -- and no parity bit.  When transmit is complete enable will be
-- -- -- -- driven high for one clock cycle.

-- -- -- -- Set Generic g_CLKS_PER_BIT as follows:
-- -- -- -- g_CLKS_PER_BIT = (Frequency of clock)/(Frequency of UART)
-- -- -- -- Example: 10 MHz Clock, 115200 baud UART
-- -- -- -- (10000000)/(115200) = 87

-- -- -- library ieee;
-- -- -- use ieee.std_logic_1164.all;
-- -- -- use ieee.numeric_std.all;
 
-- -- -- entity UART_TX is
	-- -- -- generic ( g_CLKS_PER_BIT : integer := 10416);
	-- -- -- port (  n		: in integer;
		-- -- -- clock,start     : in  std_logic;
		-- -- -- out_enc_T   : in  std_logic_vector(7 downto 0);
		-- -- -- TxD : out std_logic;
		-- -- -- r_enable_enc_T   : out std_logic;
		-- -- -- r_addr_enc_T: out integer);
-- -- -- end UART_TX;
 
 
-- -- -- architecture RTL of UART_TX is
 
-- -- -- type t_SM_Main is (r_donnes,synchro,Recuperation_RAM, s_TX_Start_Bit, s_TX_Data_Bits,
				   -- -- -- s_TX_Stop_Bit,compteur,fin);
-- -- -- signal r_SM_Main : t_SM_Main := r_donnes;
-- -- -- signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
-- -- -- signal r_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
-- -- -- signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
-- -- -- signal end_T,stransmite_enable : std_logic := '0';

-- -- -- signal Sadd_transmit: integer :=0;

-- -- -- begin
	 	   
	-- -- -- p_UART_TX : process (clock)
	-- -- -- variable vcompteur : integer :=0;
	-- -- -- variable arret_boucle:integer :=0;
	-- -- -- begin
	-- -- -- arret_boucle:=(n+1)/8;
		-- -- -- if rising_edge(clock) then	 
			-- -- -- case r_SM_Main is
				-- -- -- when r_donnes => --Recuperation des octets de la RAM		
                    -- -- -- TxD <= '1';         -- Drive Line High for Idle
                    -- -- -- end_T   <= '0';
					-- -- -- r_Clk_Count <= 0;
					-- -- -- r_Bit_Index <= 0;			
					-- -- -- if start= '1' then
						-- -- -- Sadd_transmit<=n-(8*vcompteur); --Acces au registre precis 
						-- -- -- stransmite_enable<='1';-- Lecture mode RAM activée
						-- -- -- r_SM_Main <= synchro;
					-- -- -- else
						-- -- -- Sadd_transmit<=n-1;
			            -- -- -- stransmite_enable<='0';	
						-- -- -- r_SM_Main <= r_donnes;
					-- -- -- end if;
				-- -- -- when synchro =>
 					-- -- -- r_SM_Main <= Recuperation_RAM;

				-- -- -- when Recuperation_RAM =>
					-- -- -- r_TX_Data <= out_enc_T;
					-- -- -- stransmite_enable<='0';
					-- -- -- r_SM_Main <= s_TX_Start_Bit;
					-- -- -- -- Send out Start Bit. Start bit = 0
				-- -- -- when s_TX_Start_Bit =>
					-- -- -- TxD <= '0'; 
					-- -- -- -- Wait g_CLKS_PER_BIT-1 clock cycles for start bit to finish
					-- -- -- if r_Clk_Count < g_CLKS_PER_BIT-1 then
						-- -- -- r_Clk_Count <= r_Clk_Count + 1;
						-- -- -- r_SM_Main   <= s_TX_Start_Bit;
					-- -- -- else
						-- -- -- r_Clk_Count <= 0;
						-- -- -- r_SM_Main   <= s_TX_Data_Bits;
					-- -- -- end if;
							
				-- -- -- -- Wait g_CLKS_PER_BIT-1 clock cycles for data bits to finish          
				-- -- -- when s_TX_Data_Bits =>
					-- -- -- TxD <= r_TX_Data(r_Bit_Index);
						
					-- -- -- if r_Clk_Count < g_CLKS_PER_BIT-1 then
						-- -- -- r_Clk_Count <= r_Clk_Count + 1;
						-- -- -- r_SM_Main   <= s_TX_Data_Bits;
					-- -- -- else
						-- -- -- r_Clk_Count <= 0;         
								-- -- -- -- Check if we have sent out all bits
						-- -- -- if r_Bit_Index < 7 then
							-- -- -- r_Bit_Index <= r_Bit_Index + 1;
							-- -- -- r_SM_Main   <= s_TX_Data_Bits;
						-- -- -- else
							-- -- -- r_Bit_Index <= 0;
							-- -- -- r_SM_Main   <= s_TX_Stop_Bit;
						-- -- -- end if;
					-- -- -- end if;
				-- -- -- -- Send out Stop bit.  Stop bit = 1
				-- -- -- when s_TX_Stop_Bit =>
					-- -- -- TxD <= '1';
					-- -- -- -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
					-- -- -- if r_Clk_Count < g_CLKS_PER_BIT-1 then
						-- -- -- r_Clk_Count <= r_Clk_Count + 1;
						-- -- -- r_SM_Main   <= s_TX_Stop_Bit;
					-- -- -- else
						-- -- -- r_Clk_Count <= 0;
						-- -- -- r_SM_Main   <= compteur;
					-- -- -- end if;
						  
				-- -- -- when compteur =>
					-- -- -- if(vcompteur<arret_boucle-1) then
						-- -- -- vcompteur:=vcompteur+1; --Selon la quanité de donées on repete le process
						-- -- -- r_SM_Main <= r_donnes;
					-- -- -- else
						-- -- -- end_T   <= '1';
						-- -- -- r_SM_Main <= fin;
					-- -- -- end if;
				-- -- -- when fin =>
					-- -- -- vcompteur:=0;
					-- -- -- r_SM_Main <= r_donnes;
				-- -- -- when others =>
				    -- -- -- r_SM_Main <= r_donnes;
			-- -- -- end case;
		-- -- -- end if;
	-- -- -- end process p_UART_TX; 
	-- -- -- r_enable_enc_T<= stransmite_enable;
   	-- -- -- r_addr_enc_T<=Sadd_transmit;
-- -- -- end RTL;