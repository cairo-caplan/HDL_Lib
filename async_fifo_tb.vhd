library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_fifo_tb is

end entity async_fifo_tb;

architecture RTL of async_fifo_tb is
	constant DATA_WIDTH : integer := 8;
	constant ADDR_WIDTH : integer := 4;
	signal data_out : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal empty : std_logic;
	signal read : std_logic;
	signal rclk : std_logic;
	signal full : std_logic;
	signal data_in : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal write : std_logic;
	signal wclk : std_logic;
	signal rst : std_logic;
	signal wclk_period : time := 20 ns;
	signal stop : boolean;
	signal rclk_period : time := 110 ns;

	
	
begin
	
	async_fifo_inst : entity work.async_fifo
		generic map(
			DATA_WIDTH => DATA_WIDTH,
			ADDR_WIDTH => ADDR_WIDTH
		)
		port map(
			d_o   => data_out,
			empty_o  => empty,
			read_i  => read,
			r_clk_i       => rclk,
			d_i    => data_in,
			full_o   => full,
			write_i => write,
			w_clk_i       => wclk,
			rst   => rst
		);
		
		wclk_proc : process is
		begin
			wclk <= '0';
			while stop=false loop
				wait for wclk_period/2;
				wclk <= not wclk;
			end loop;
			wait;
		end process wclk_proc;
		
		rclk_proc : process is
		begin
			rclk <= '0';
			while stop=false loop
				wait for rclk_period/2;
				rclk <= not rclk;
			end loop;
			wait;
		end process rclk_proc;
		
		stim_proc : process is
		begin
			rst <= '1';
			write <= '0';
			read <= '0';
			
			wait for wclk_period;
			rst <= '0';
			wait for wclk_period;
			
			wait for wclk_period;
			write <= '1';
			data_in <= x"34";
			wait for wclk_period;
			write <= '0';
			
			wait for wclk_period;
			write <= '1';
			data_in <= x"56";
			wait for wclk_period;
			write <= '0';
			
			wait for wclk_period;
			write <= '1';
			data_in <= x"89";
			wait for wclk_period;
			write <= '0';
			
			wait for wclk_period;
			write <= '1';
			data_in <= x"ab";
			wait for wclk_period;
			write <= '0';
			
			
			
			
			wait for rclk_period;
			read <= '1';
			wait for rclk_period;
			read <= '0';
			
			wait for rclk_period;
			read <= '1';
			wait for rclk_period;
			read <= '0';
			
			wait for rclk_period;
			read <= '1';
			wait for rclk_period;
			read <= '0';
			
			wait for rclk_period;
			read <= '1';
			wait for rclk_period;
			read <= '0';
			
			wait for rclk_period;
			
			stop <= true;
			wait;
			
			
			
			
		end process stim_proc;
	
end architecture RTL;
