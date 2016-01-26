library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filename is
	generic(
		ADDR_WIDTH	:	natural := 4;
		WIDTH		:	natural := 8
	);
	port (
		rst		:	in	std_logic;
		--
		empty_i	:	in	std_logic;
		full_o	:	out	std_logic;
		--
		wclk_i	:	in	std_logic;
		we_i	:	in	std_logic;
		d_i		:	in	std_logic_vector(WIDTH downto 0);
		--
		rclk_i	:	in	std_logic;
		re_i	:	in	std_logic;
		d_o		:	out	std_logic_vector(WIDTH downto 0)
		
		
	);
end entity filename;

architecture RTL of filename is
	
	signal waddr, raddr	:	natural range 0 to (2**ADDR_WIDTH) - 1;
	signal wptr, rptr,  wq2_rptr, rq2_wptr	:	natural range 0 to (2**ADDR_WIDTH) - 1;
	
begin
	
	fifo_inst : entity work.fifo
		generic map(
			WIDTH  => WIDTH,
			LENGTH => 2**ADDR_WIDTH
		)
		port map(
			clk     => wclk_i,
			a_rst   => '0',
			rst     => rst,
			we_i    => we_i,
			d_i     => d_i,
			re_i    => re_i,
			d_o     => d_o,
			full_o  => full_o,
			empty_o => empty_o
		);

end architecture RTL;
