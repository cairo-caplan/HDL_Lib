library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    
--http://www.asic-world.com/code/vhdl_examples/aFifo.vhd
    
entity async_fifo is
    generic (
        DATA_WIDTH	:	natural := 8;
        ADDR_WIDTH	:	natural := 4
    );
    port (
    	rst			:	in  std_logic;
        -- Reading port.
        d_o    		:	out std_logic_vector(DATA_WIDTH-1 downto 0);
        empty_o   	:	out std_logic;
        read_i		:	in  std_logic;
        r_clk_i		:	in  std_logic;
        -- Writing port.
        d_i     	:	in  std_logic_vector(DATA_WIDTH-1 downto 0);
        full_o   	:	out std_logic;
        write_i  	:	in  std_logic;
        w_clk_i		:	in  std_logic
    );
end entity;
architecture rtl of async_fifo is
    ----/Internal connections & variables------
    constant FIFO_DEPTH :integer := 2**ADDR_WIDTH;

    type RAM is array (integer range <>)of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal mem : RAM (0 to FIFO_DEPTH-1);
    
    signal w_ptr     			:std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal r_ptr      			:std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal eq_addr       		:std_logic;
    signal w_ptr_en   			:std_logic;
    signal r_ptr_en    			:std_logic;
    signal set_status			:std_logic;
    signal rst_status			:std_logic;
    signal status				:std_logic;
    signal preset_full			:std_logic;
    signal preset_empty			:std_logic;
    signal empty,full           :std_logic;
    
    component gray_counter
    	generic(COUNTER_WIDTH : natural := 4);
    	port(clk          : in  std_logic;
    		 rst          : in  std_logic;
    		 en_i         : in  std_logic;
    		 gray_count_o : out std_logic_vector(COUNTER_WIDTH - 1 downto 0));
    end component gray_counter;
    
begin

    --------------Code--------------/
    --Data ports logic:
    --(Uses a dual-port RAM).
    --'Data_out' logic:
    process (r_clk_i) begin
        if (rising_edge(r_clk_i)) then
            if (read_i = '1' and empty = '0') then
                d_o <= mem(conv_integer(r_ptr));
            end if;
        end if;
    end process;
            
    --'Data_in' logic:
    process (w_clk_i) begin
        if (rising_edge(w_clk_i)) then
            if (write_i = '1' and full = '0') then
                mem(conv_integer(w_ptr)) <= d_i;
            end if;
        end if;
    end process;

    --Fifo addresses support logic: 
    --'Next Addresses' enable logic:
    w_ptr_en <= write_i and (not full);
    r_ptr_en  <= read_i  and (not empty);
           
    --Addreses (Gray counters) logic:
    gray_counter_w_ptr :  gray_counter
    	generic map(
    		COUNTER_WIDTH => 4
    	)
    	port map(
    		clk          => w_clk_i,
    		rst          => rst,
    		en_i         => w_ptr_en,
    		gray_count_o => w_ptr
    	);
    	
   gray_counter_r_ptr :  gray_counter
    	generic map(
    		COUNTER_WIDTH => 4
    	)
    	port map(
    		clk          => r_clk_i,
    		rst          => rst,
    		en_i         => r_ptr_en,
    		gray_count_o => r_ptr
    	);
    

    --'EqualAddresses' logic:
    eq_addr <= '1' when (w_ptr = r_ptr) else '0';

    --'Quadrant selectors' logic:
    process (w_ptr, r_ptr)
        variable set_status_bit0 :std_logic;
        variable set_status_bit1 :std_logic;
        variable rst_status_bit0 :std_logic;
        variable rst_status_bit1 :std_logic;
    begin
        set_status_bit0 := w_ptr(ADDR_WIDTH-2) xnor r_ptr(ADDR_WIDTH-1);
        set_status_bit1 := w_ptr(ADDR_WIDTH-1) xor  r_ptr(ADDR_WIDTH-2);
        set_status <= set_status_bit0 and set_status_bit1;
        
        rst_status_bit0 := w_ptr(ADDR_WIDTH-2) xor  r_ptr(ADDR_WIDTH-1);
        rst_status_bit1 := w_ptr(ADDR_WIDTH-1) xnor r_ptr(ADDR_WIDTH-2);
        rst_status      <= rst_status_bit0 and rst_status_bit1;
    end process;
    
    --'Status' latch logic:
    process (set_status, rst_status, rst) begin--D Latch w/ Asynchronous Clear & Preset.
        if (rst_status = '1' or rst = '1') then
            status <= '0';  --Going 'Empty'.
        elsif (set_status = '1') then
            status <= '1';  --Going 'Full'.
        end if;
    end process;
    
    --'Full_out' logic for the writing port:
    preset_full <= status and eq_addr;  --'Full' Fifo.
    
    process (w_clk_i, preset_full) begin --D Flip-Flop w/ Asynchronous Preset.
        if (preset_full = '1') then
            full <= '1';
        elsif (rising_edge(w_clk_i)) then
            full <= '0';
        end if;
    end process;
    full_o <= full;
    
    --'Empty_out' logic for the reading port:
    preset_empty <= not status and eq_addr;  --'Empty' Fifo.
    
    process (r_clk_i, preset_empty) begin --D Flip-Flop w/ Asynchronous Preset.
        if (preset_empty = '1') then
            empty <= '1';
        elsif (rising_edge(r_clk_i)) then
            empty <= '0';
        end if;
    end process;
    
    empty_o <= empty;
end architecture;