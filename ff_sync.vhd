library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ff_sync is
	generic(
		nr_stages	:	natural :=2
	);
	port (
		clk_i	:	in	std_logic;
		clk_o	:	in	std_logic;
		rst 	:	in	std_logic;
		s_i		:	in	std_logic;
		s_o		:	out	std_logic
	);
end entity ff_sync;

architecture RTL of ff_sync is
	signal	s_inbuf	:	std_logic;
	signal	s_stage	:	std_logic_vector(0 to nr_stages-1);
	
begin
	
	clk_i_process : process (clk_i, rst) is
	begin
		if rst = '1' then
			s_inbuf <= '0';
		elsif rising_edge(clk_i) then
			s_inbuf <= s_i;
			
		end if;
	end process clk_i_process;
	
	clk_o_proc : process (clk_o, rst) is
	begin
		if rst = '1' then
			s_stage(0 to s_stage'high) <= (others=>'0');
		elsif rising_edge(clk_o) then
			s_stage(0) <= s_inbuf; 
			for i in 1 to nr_stages-1 loop
				s_stage(i) <= s_stage(i-1); 
			end loop;
		end if;
	end process clk_o_proc;
	
	
	s_o <= s_stage(nr_stages-1);
	

end architecture RTL;
