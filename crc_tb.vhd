library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crc_tb is

end entity crc_tb;

architecture RTL of crc_tb is
	constant CRC_WIDTH 	: natural := 16;
	constant DATA_WIDTH	: natural := 8;
	
	signal INIT_VAL		: std_logic_vector(15 downto 0) := x"ffff";
	signal POLY			: std_logic_vector(15 downto 0) := x"8408";
	signal d			: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal init			: std_logic;
	signal d_valid		: std_logic;
	signal clk			: std_logic;
	signal crc			: std_logic_vector(CRC_WIDTH-1 downto 0);
	
	
	signal stop 		: boolean := false;
	constant clk_period : time := 20 ns;
	signal rst : std_logic;
begin
	
	
	crc_inst : entity work.crc
		generic map(
			CRC_WIDTH  => CRC_WIDTH,
			DATA_WIDTH => DATA_WIDTH,
			INIT_VAL   => INIT_VAL,
			POLY       => POLY
		)
		port map(
			clk       => clk,
			rst       => rst,
			d_i       => d,
			init_i    => init,
			d_valid_i => d_valid,
			crc_o     => crc
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
			rst <= '0';
			d_valid <= '0';
			init <= '0';
			wait for clk_period;
			
			rst <= '1';
			wait for clk_period;
			
			rst <= '0';
			wait for clk_period;
			init <='0';
		wait for clk_period;
		init <='1';
		wait for clk_period;
		init <='0';
		
		wait for clk_period;
		d <= x"ff";
		d_valid <='1';
		wait for clk_period;
		d_valid <= '0';
		
		wait for 6*clk_period;
		
		d <= x"8f";
		d_valid <='1';
		wait for clk_period;
		d_valid <= '0';
		
		wait for 6*clk_period;
		
		
		
		d <= x"87";
		d_valid <='1';
		wait for clk_period;
		d_valid <= '0';
		
		wait for 6*clk_period;
		
		
		d <= x"73";
		d_valid <='1';
		wait for clk_period;
		d_valid <= '0';
			
		wait for 30*clk_period;
			
		stop<= true; wait;
		
		
		
		
		
end process stim_proc;
		
		
		

end architecture RTL;
