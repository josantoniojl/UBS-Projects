library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity transmit_debouncing is -- #(parameter threshold = 2)-- set parameter thresehold to guage how long button pressed
	port(
		clock, btn1 : in std_logic;
		transmit : out std_logic
    );
end transmit_debouncing;



architecture Archi_transmit_debouncing of transmit_debouncing is

	signal button_ff1, button_ff2 : std_logic := '0'; --button flip-flop for synchronization. Initialize it to 0
	--signal count : std_logic_vector(30 downto 0) := others => '0'; --20 bits count for increment & decrement when button is pressed or released. Initialize it to 0 


begin
	-- First use two flip-flops to synchronize the button signal the "clk" clock domain

	process (btn1)
	begin
		button_ff1 <= btn1;
	end process;

	-- When the push-button is pushed or released, we increment or decrement the counter
	-- The counter has to reach threshold before we decide that the push-button state has changed
	
process (button_ff1)
	begin 
	 if (button_ff1 = '1') then --if button_ff1 is 1
		transmit <= '1'; --debounced signal is 1
	 else
		transmit <= '0'; --debounced signal is 0
	end if;
	end process;

end Archi_transmit_debouncing;	
	
	
	