library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- Needed for shifts
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;




entity transmitter is
	port(
		clock, reset, start : in std_logic;
		data : in std_logic_vector(7 downto 0);
		TxD, enable : out std_logic
	);
end transmitter;

architecture archi_transmitter of transmitter is

	--internal variables
	signal bitcounter : std_logic_vector(3 downto 0); --4 bits counter to count up to 10
	signal counter : std_logic_vector(13 downto 0); --14 bits counter to count the baud rate, counter = clock / baud rate
	signal state,nextstate : std_logic; -- initial & next state variable
	-- 10 bits data needed to be shifted out during transmission.
	--The least significant bit is initialized with the binary value “0” (a start bit) A binary value “1” is introduced in the most significant bit 
	signal rightshiftsignal : std_logic_vector(9 downto 0); 
	signal shift : std_logic; --shift signal to start bit shifting in UART
	signal load : std_logic; --load signal to start loading the data into rightshift signalister and add start and stop bit
	signal clear : std_logic; --clear signal to start reset the bitcounter for UART transmission
	signal Sstart,STxD: std_logic;
begin

	--UART transmission logic
	process(clock, reset) 
	begin 
		if (reset = '1') then 
			state <= '0'; -- state is idle (state = 0)
			counter <= (others=>'0'); -- counter for baud rate is reset to 0 
			bitcounter <= (others=>'0'); --counter for bit transmission is reset to 0
		else
			if(clock'event and clock = '1') then
				counter <= counter + 1; --counter for baud rate generator start counting 
				if (counter >= 10415) then --if count to 10416 (from 0 to 10415)
					state <= nextstate; --previous state change to next state
					counter <= (others=>'0'); -- reset couter to 0
					if (load = '1') then
						rightshiftsignal(0) <= '0';
						rightshiftsignal(8 downto 1) <= data;
						rightshiftsignal(9) <= '1';
					end if;
					if (clear = '1') then
						bitcounter <= (others=>'0'); -- reset the bitcounter if clear is asserted
					end if;
					if (shift = '1') then
						rightshiftsignal  <= std_logic_vector(shift_right(unsigned(rightshiftsignal ), 1)); --right shift the data as we start the data from lsb
						bitcounter <= bitcounter + 1; --count the bitcounter
					end if;
				end if;
			end if;
		end if;
	end process;

	-- UART transmission logic
	process(clock, reset)
	begin
		if(reset = '1') then
			load <='0'; -- set load equal to 0 at the beginning
			shift <='0'; -- set shift equal to 0 at the beginning
			clear <='0'; -- set clear equal to 0 at the beginning
			TxD <='1'; -- set TxD equals to during no transmission
		else
			if(clock'event and clock='1') then
				case state is
					when '0' => -- idle state
						if (start'event and start = '1') then -- assert start input
							nextstate <= '1'; -- Move to start state
							load <='1'; -- set load to 1 to prepare to load the data
							shift <='0'; -- set shift to 0 so no shift ready yet
							clear <='0'; -- set clear to 0 to avoid clear any counter
						else
							nextstate <= '0'; -- next state is back to idle state
							TxD <= '1';
						end if;
					when '1' => -- start state
						if (bitcounter >= 10) then -- check if transmission is complete
							nextstate <= '0'; -- set nextstate back to 0 to idle state
							clear <= '1'; -- set clear to 1 to clear all counters
						else -- if transmisssion is not complete 
							nextstate <= '1'; -- set nextstate to 1 to stay in start state
							TxD <= rightshiftsignal(0); -- shift the bit to output TxD
							shift <= '1'; -- set shift to 1 to continue shifting the data
						end if;
					when others =>
						nextstate <= '0';
				end case;
			end if;
		end if;
	end process;
end archi_transmitter;
