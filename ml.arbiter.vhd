library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arbiter is
	generic(
		NUMBER_OF_DEVICES	:	natural	:= 7;
		TIME_SLICE			:	natural	:= 10
	);
	port (
		clk		:	in std_logic;
		rst		:	in std_logic;
		req_i	:	in	std_logic_vector(0 to NUMBER_OF_DEVICES-1);
		gnt_o 	:	out	std_logic_vector(0 to NUMBER_OF_DEVICES-1)
	);
end entity arbiter;

architecture RTL of arbiter is
	
	signal	timer		:	natural range 0 to TIME_SLICE-1;
	signal	curr_device	:	natural range 0 to NUMBER_OF_DEVICES-1 := 0;
	signal	gnt 		:	std_logic_vector(0 to NUMBER_OF_DEVICES-1);

	
begin
	
	sync_proc : process (clk) is
		variable granted	:	std_logic;
		variable gnt_var	:	std_logic_vector(0 to NUMBER_OF_DEVICES-1);
	begin
		if rising_edge(clk) then
			if rst = '1' then
				gnt <= (others=>'0');
				timer <= 0;
			else
				if (timer /= TIME_SLICE-1) and (gnt/=(gnt'range => '0')) then
					timer <= timer + 1;
				else
					timer <= 0;
					granted := '0';
					gnt_var := (others=>'0');
					if granted = '0' and curr_device/=NUMBER_OF_DEVICES-1 then
						for i in curr_device+1 to NUMBER_OF_DEVICES-1 loop
							if req_i(i)='1' then
								curr_device <= i;
								granted := '1';
								gnt_var(i):='1';
								exit;
							end if;
						end loop;
					end if;
					
					if granted = '0' and curr_device/=0 then
						for i in 0 to curr_device-1 loop
							if req_i(i)='1' then
								curr_device <= i;
								granted := '1';
								gnt_var(i):='1';
								exit;
							end if;
						end loop;
					end if;
					
					if granted='0' then
						gnt_var(curr_device) := '1';
					end if;
					
					gnt <= gnt_var;

				end if;
			end if;
		end if;
		gnt_o <= gnt;
	end process sync_proc;
	
	
	

end architecture RTL;

