library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_fifo_tb is

end entity async_fifo_tb;

architecture RTL of async_fifo_tb is
	constant DATA_WIDTH : integer := 8;
	constant ADDR_WIDTH : integer := 4;
	signal Data_out : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal Empty_out : std_logic;
	signal ReadEn_in : std_logic;
	signal rclk : std_logic;
	signal Full_out : std_logic;
	signal Data_in : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal WriteEn_in : std_logic;
	signal wclk : std_logic;
	signal Clear_in : std_logic;
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
			Data_out   => Data_out,
			Empty_out  => Empty_out,
			ReadEn_in  => ReadEn_in,
			RClk       => rclk,
			Data_in    => Data_in,
			Full_out   => Full_out,
			WriteEn_in => WriteEn_in,
			WClk       => wclk,
			Clear_in   => Clear_in
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
			Clear_in <= '1';
			WriteEn_in <= '0';
			ReadEn_in <= '0';
			
			wait for wclk_period;
			Clear_in <= '0';
			wait for wclk_period;
			
			wait for wclk_period;
			WriteEn_in <= '1';
			Data_in <= x"34";
			wait for wclk_period;
			WriteEn_in <= '0';
			
			wait for wclk_period;
			WriteEn_in <= '1';
			Data_in <= x"56";
			wait for wclk_period;
			WriteEn_in <= '0';
			
			wait for wclk_period;
			WriteEn_in <= '1';
			Data_in <= x"89";
			wait for wclk_period;
			WriteEn_in <= '0';
			
			wait for wclk_period;
			WriteEn_in <= '1';
			Data_in <= x"ab";
			wait for wclk_period;
			WriteEn_in <= '0';
			
			
			
			
			wait for rclk_period;
			ReadEn_in <= '1';
			wait for rclk_period;
			ReadEn_in <= '0';
			
			wait for rclk_period;
			ReadEn_in <= '1';
			wait for rclk_period;
			ReadEn_in <= '0';
			
			wait for rclk_period;
			ReadEn_in <= '1';
			wait for rclk_period;
			ReadEn_in <= '0';
			
			wait for rclk_period;
			ReadEn_in <= '1';
			wait for rclk_period;
			ReadEn_in <= '0';
			
			wait for rclk_period;
			
			stop <= true;
			wait;
			
			
			
			
		end process stim_proc;
	
end architecture RTL;
