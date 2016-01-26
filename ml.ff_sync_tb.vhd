library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ff_sync_tb is
end entity ff_sync_tb;

architecture RTL of ff_sync_tb is
	signal clk_i : std_logic := '0';
	signal clk_o : std_logic := '0';
	signal rst : std_logic:='0';
	signal s_i : std_logic := 'U';
	signal s_o : std_logic;
	
	constant clk_period	:	time := 20 ns;
	constant nr_stages	:	natural := 3;
	
	signal stop :	boolean := false;
	
begin
	
	ff_sync_inst : entity work.ff_sync
		generic map(
			nr_stages => nr_stages
		)
		port map(
			clk_i => clk_i,
			clk_o => clk_o,
			rst   => rst,
			s_i   => s_i,
			s_o   => s_o
		);
		
		
		clk_i_stim : process is
		begin
			wait for clk_period/2;
			clk_i <= not clk_i;
			if stop then 
				wait;
			end if;
		end process clk_i_stim;
		
		clk_o_stim : process is
		begin
			wait on clk_i;
			wait for clk_period/3;
			clk_o <= clk_i; 
		end process clk_o_stim;
		
		
		
		stim_process : process is
		begin
			rst<='0';
			wait for 30 ns;
			rst <= '1';
			wait for clk_period;
			rst <= '0';
			
			s_i <= '0';
			wait for clk_period;
			s_i <= '1';
			wait for clk_period;
			s_i <= '1';
			wait for clk_period;
			s_i <= '1';
			wait for clk_period;
			s_i <= '0';
			wait for clk_period;
			s_i <= '1';
			wait for clk_period;
			s_i <= '0';
			wait for clk_period;
			s_i <= '1';
			
			wait for (nr_stages+1)*clk_period;
			
			stop <= true;
			wait;
			
		end process stim_process;
		
		
	
end architecture RTL;

