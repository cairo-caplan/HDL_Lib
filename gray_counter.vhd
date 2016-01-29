library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_counter is
	generic (
		COUNTER_WIDTH	:	natural	:=4
	);
	port (
		clk			: in	std_logic;
		rst			: in	std_logic;
		en_i		: in	std_logic;
		gray_count_o	: out	std_logic_vector (COUNTER_WIDTH-1 downto 0)
	);
end entity gray_counter;

architecture RTL of gray_counter is
	signal binary_count : unsigned(COUNTER_WIDTH-1 downto 0);
begin
	
	sync_process : process (clk, rst) is
	begin
		if rst = '1' then
			binary_count   <= ( 0=>'1', others=>'0');  
			gray_count_o <= (others=>'0');
			
		elsif rising_edge(clk) then
			if en_i = '1' then
			 binary_count   <= binary_count + 1;
                gray_count_o <= std_logic_vector(binary_count(COUNTER_WIDTH-1) 
                	& (binary_count(COUNTER_WIDTH-2 downto 0) xor binary_count(COUNTER_WIDTH-1 downto 1))
                );
             end if;
		end if;
	end process sync_process;
	

end architecture RTL;