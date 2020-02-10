library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.config_pkg.all;

entity ip_address_generator is
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    en        : in  std_logic;
    size      : in  std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    column    : in  std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    prev_addr : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    curr_addr : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    next_addr : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    vld_out   : out std_logic);    

end ip_address_generator;

architecture address of ip_address_generator is
begin
  process(clk, rst)
  variable increment : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0) := (0 => '1', others => '0');
  variable gen_addr : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0) := (others => '0');
    begin
      if rst = '1' then
		gen_addr := (others => '0');
        vld_out <= '0';
      elsif rising_edge(clk) then
	    if en = '1' then
          if gen_addr <= size then
            prev_addr <= gen_addr;
            curr_addr <= std_logic_vector(unsigned(gen_addr) + unsigned(column));
            next_addr <= std_logic_vector(unsigned(gen_addr) + shift_left(unsigned(column),1));
            vld_out <= '1';
          else
            vld_out <= '0';
          end if;
     	  gen_addr := std_logic_vector(unsigned(gen_addr) + unsigned(increment));
        else 
          gen_addr := gen_addr;
          vld_out <= '0';
        end if;  
      end if;
    end process;	  
end address;
