library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity ram_tb is
end entity ram_tb;

architecture RTL of ram_tb is
	constant WORD_WIDTH : natural := 8;
	constant NR_LINES : natural	:= 1024;
	signal we : std_logic := '0';
	signal addr : natural range 0 to NR_LINES-1;
	signal data_r : std_logic_vector(WORD_WIDTH-1 downto 0);
	signal data_w : std_logic_vector(WORD_WIDTH-1 downto 0);
	signal clk : std_logic;
	
	signal stop	:	boolean:= false;
	
	type mem_t is array(natural range <>) of std_logic_vector(WORD_WIDTH-1 downto 0);
	
	
begin
	
	ram_inst : entity work.ram
		generic map(
			WORD_WIDTH => WORD_WIDTH,
			NR_LINES   => NR_LINES
		)
		port map(
			clk      => clk,
			we_i     => we,
			addr_i   => addr,
			data_w_i => data_w,
			data_r_o => data_r
		);
		
		clk_process : process is
		begin
			clk <= '0';
			while not stop loop
				wait for 20 ns;
				clk <= not clk;
			end loop;
			wait;
				
		end process clk_process;
		
				
		stim_proc : process is
			variable i	:	natural;
			variable values	: mem_t(0 to NR_LINES-1);	
			--
			variable seed1, seed2: positive;               -- seed values for random generator
		    variable rand: real;   -- random real-number value in range 0 to 1.0  
		    constant range_of_rand : real := 2.0**WORD_WIDTH;    -- the range of random values created will be 0 to +1000.
		begin
			
			i:=0;
			while i<NR_LINES loop
			
				uniform(seed1, seed2, rand);   -- generate random number
			    values(i) := std_logic_vector( to_unsigned(integer(rand*range_of_rand-1.0),WORD_WIDTH));  -- rescale to 0..1000, convert integer part
			    addr	<= i;
			    data_w	<= values(i);
			    we		<= '1';
				wait until rising_edge(clk);
				i := i+1;
			end loop;
			we <= '0';
			
			i:=0;
			while i<=NR_LINES loop
				if i < NR_LINES then
					addr	<= i;
				end if;
				wait until rising_edge(clk);
				if i>0 then
					 if data_r /= values(i-1) then
						report "Failed on address " & integer'image(i) severity failure;
					end if;
				end if;
				
				i := i+1;
			end loop;
			
			report "Passed!";
			stop <= true;
			wait;
			
			
			
		end process stim_proc;
		

end architecture RTL;
