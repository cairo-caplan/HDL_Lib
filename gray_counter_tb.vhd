library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_counter_tb is
end entity gray_counter_tb;

architecture RTL of gray_counter_tb is
	constant COUNTER_WIDTH : natural := 4;
	signal clk : std_logic;
	signal rst : std_logic;
	signal en_i : std_logic;
	signal gray_count_o : std_logic_vector (COUNTER_WIDTH-1 downto 0);
	
	constant clk_period	:	time := 20 ns;
	constant nr_stages	:	natural := 3;
	
	signal stop :	boolean := false;
	
begin
	
	gray_counter_inst : entity work.gray_counter
		generic map(
			COUNTER_WIDTH => COUNTER_WIDTH
		)
		port map(
			clk          => clk,
			rst          => rst,
			en_i         => en_i,
			gray_count_o => gray_count_o
		);
		
		clk_stim : process is
		begin
			clk <= '0';
			while stop=false loop
				wait for clk_period/2;
				clk <= not clk;
			end loop;
			wait;
		end process clk_stim;
		
		stim_proc : process is
		begin
			rst <= '1';
			en_i <= '0';
			wait for clk_period;
			rst <= '0';
			wait for clk_period;
			
			for i in 1 to 2**COUNTER_WIDTH loop
				en_i <= '1';
				wait for clk_period;
			end loop;
			
			en_i <= '0';
			 
			stop <= true;
			wait;
		
			
			
		end process stim_proc;
		

end architecture RTL;
