library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arbiter_tb is

end entity arbiter_tb;

architecture RTL of arbiter_tb is
	constant NUMBER_OF_DEVICES : natural := 4;
	
	constant TIME_SLICE : natural := 10;
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal req : std_logic_vector(0 to NUMBER_OF_DEVICES-1);
	signal gnt : std_logic_vector(0 to NUMBER_OF_DEVICES-1);
	
	
	
begin
	
	arbiter_inst : entity work.arbiter
		generic map(
			NUMBER_OF_DEVICES => NUMBER_OF_DEVICES,
			TIME_SLICE        => TIME_SLICE
		)
		port map(
			clk   => clk,
			rst   => rst,
			req_i => req,
			gnt_o => gnt
		);
		
		clk_process : process is
		begin
			wait for 20 ns;
			clk <= not clk;
			if now = 15000 ns then 
				wait;
			end if;
				
		end process clk_process;
		
		
		
		
		
		
		stim : process is
		begin
			req <= "1111";
			rst <= '0';
			wait for 60 ns;
			
			rst <= '1';
			wait for 40 ns;
			rst <= '0';
			
			wait for 4000 ns;
			req <= "1100";
			wait for 4000 ns;
			req <= "1010";
			
			wait;
			
			
			
		end process stim;
		

end architecture RTL;
