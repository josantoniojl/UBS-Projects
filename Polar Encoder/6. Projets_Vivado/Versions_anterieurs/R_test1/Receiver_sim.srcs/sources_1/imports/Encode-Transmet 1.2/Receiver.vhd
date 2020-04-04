library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- Needed for shifts
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity receiver is  
    port(
         clk,reset,RxD: in std_logic;
         RxData: out std_logic_vector(7 downto 0));
end entity;

architecture Arch_receiver of receiver is
    signal shift,state,nextstate,clear_bitcounter,inc_bitcounter,inc_samplecounter,clear_samplecounter: std_logic:='0';
    signal bitcounter:std_logic_vector(3 downto 0):=(others=>'0');
    signal samplecounter: std_logic_vector(1 downto 0):=(others=>'0');
    signal counter: std_logic_vector(13 downto 0):=(others=>'0');
    signal rxshiftreg: std_logic_vector(9 downto 0):=(others=>'0');
    --constants
    constant clk_freq:integer:= 100000000;  -- system clk frequency
    constant baud_rate:integer:= 9600; --baud rate
    constant div_sample:integer:= 4; --oversampling
    constant div_counter :integer:= clk_freq/(baud_rate*div_sample);  -- this is the number we have to divide the system clk frequency to get a frequency (div_sample) time higher than (baud_rate)
    constant mid_sample:integer:= (div_sample/2);  -- this is the middle point of a bit where you want to sample it
    constant div_bit:integer:=10; -- 1 start, 8 data, 1 stop

begin

    process(clk,reset)
    begin
      if (reset='1')then  --if reset is asserted
        state <='0'; --set state to idle 
        bitcounter <=(others=>'0'); --reset the bit counter
        counter <=(others=>'0'); --reset the counter
        samplecounter <=(others=>'0'); --reset the sample counter
      elsif(clk'event and clk = '1') then --if reset is not asserted
        counter <= counter + 1; --start count in the counter
        if (counter >= (div_counter - 1)) then  --if counter reach the baud rate with sampling 
          counter <=(others=>'0');--reset the counter
          state <= nextstate; --assign the state to nextstate
            if (shift= '1') then 
              --rxshiftreg <= {RxD,rxshiftreg[9:1]}; --if shift asserted, load the receiving data
              rxshiftreg(0) <= RxD;
              rxshiftreg(9 downto 1) <= rxshiftreg(8 downto 0);
            end if;
            if (clear_samplecounter= '1') then
              samplecounter <=(others=>'0'); --if clear sampl counter asserted, reset sample counter
            end if;
            if (inc_samplecounter= '1') then 
              samplecounter <= samplecounter +1;--if increment counter asserted, start sample count
            end if; 
            if (clear_bitcounter= '1')then 
              bitcounter <=(others=>'0'); --if clear bit counter asserted, reset bit counter
            end if;
            if (inc_bitcounter= '1') then 
              bitcounter <= bitcounter +1; --if increment bit counter asserted, start count bit counter
            end if;
       end if;
      end if;
    end process;

    process(clk, reset) --trigger by clk
    begin 
      if(reset = '1') then
        shift <= '0'; -- set shift to 0 to avoid any shifting 
        clear_samplecounter <='0'; -- set clear sample counter to 0 to avoid reset
        inc_samplecounter <='0'; -- set increment sample counter to 0 to avoid any increment
        clear_bitcounter <='0'; -- set clear bit counter to 0 to avoid claring
        inc_bitcounter <='0'; -- set increment bit counter to avoid any count
        nextstate <='0'; -- set next state to be idle state

      elsif(clk'event and clk='1') then
        case state is
            when '0' =>  -- idle state
              if (RxD='1') then -- if input RxD data line asserted
                nextstate <='0'; -- back to idle state because RxD needs to be low to start transmission    
              else -- if input RxD data line is not asserted
                nextstate <='1'; --jump to receiving state 
                clear_bitcounter <='1'; -- trigger to clear bit counter
                clear_samplecounter <='1'; -- trigger to clear sample counter
              end if;
            when '1' => -- receiving state
              nextstate <= '1'; -- DEFAULT 
              if (samplecounter= mid_sample - 1) then 
                shift <= '1'; -- if sample counter is 1, trigger shift
              end if;
              if (samplecounter= div_sample - 1) then -- if sample counter is 3 as the sample rate used is 3
                if (bitcounter = div_bit - 1) then -- check if bit counter if 9 or not
                  nextstate <= '0'; -- back to idle state if bit counter is 9 as receving is complete
                end if;
                inc_bitcounter <='1'; -- trigger the increment bit counter if bit counter is not 9
                clear_samplecounter <='1'; --trigger the sample counter to reset the sample counter
              else
                inc_samplecounter <='1'; -- if sample is not equal to 3, keep counting
              end if;
            when others =>
              nextstate <= '0';
        end case;
      end if;
    end process;
    
    RxData<=rxshiftreg(8 downto 1);   
end Arch_receiver;