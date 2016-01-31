library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package my_lib is

	component fifo
		generic(DATA_WIDTH  : natural := 8;
			    LENGTH : natural := 4);
		port(clk     : in  std_logic;
			 a_rst   : in  std_logic;
			 rst     : in  std_logic;
			 we_i    : in  std_logic;
			 d_i     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 re_i    : in  std_logic;
			 d_o     : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			 full_o  : out std_logic;
			 empty_o : out std_logic);
	end component fifo;
	
end package my_lib;

package body my_lib is
	
end package body my_lib;
