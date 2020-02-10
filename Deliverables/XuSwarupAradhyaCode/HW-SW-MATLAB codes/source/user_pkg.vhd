-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;

package user_pkg is

    constant C_MEM_ADDR_WIDTH : positive := 15;
    constant C_MEM_IN_WIDTH   : positive := 32;
    constant C_MEM_OUT_WIDTH  : positive := 32;

    constant C_MEM_START_ADDR : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
    constant C_MEM_END_ADDR   : std_logic_vector(MMAP_ADDR_RANGE) := std_logic_vector(unsigned(C_MEM_START_ADDR)+(2**C_MEM_ADDR_WIDTH-1));

  ---  constant C_GO_ADDR   : std_logic_vector(MMAP_ADDR_RANGE) := std_logic_vector(to_unsigned(2**C_MMAP_ADDR_WIDTH-3, C_MMAP_ADDR_WIDTH));
   --- constant C_SIZE_ADDR : std_logic_vector(MMAP_ADDR_RANGE) := std_logic_vector(to_unsigned(2**C_MMAP_ADDR_WIDTH-2, C_MMAP_ADDR_WIDTH));
   --- constant C_DONE_ADDR : std_logic_vector(MMAP_ADDR_RANGE) := std_logic_vector(to_unsigned(2**C_MMAP_ADDR_WIDTH-1, C_MMAP_ADDR_WIDTH));

    constant C_1 : std_logic := '1';
    constant C_0 : std_logic := '0';
	constant C_KERNEL_SIZE           : positive := 9;
    constant C_KERNEL_WIDTH          : positive := 32;
    constant C_MAX_SIGNAL_SIZE       : positive := 2**(C_MEM_ADDR_WIDTH+1);
    constant C_MAX_SIGNAL_SIZE_WIDTH : positive := C_MEM_IN_WIDTH;
    constant C_SIGNAL_WIDTH          : positive := 32;
    constant C_MAX_OUTPUT_SIZE       : positive := C_MAX_SIGNAL_SIZE + C_KERNEL_SIZE - 1;
    --constant C_OUTPUT_SIZE_WIDTH     : positive := bitsNeeded(C_MAX_OUTPUT_SIZE);

    --subtype KERNEL_SIZE_RANGE is natural range C_KERNEL_SIZE-1 downto 0;
   -- subtype KERNEL_WIDTH_RANGE is natural range C_KERNEL_WIDTH-1 downto 0;
    --subtype MAX_SIGNAL_SIZE_RANGE is natural range C_MAX_SIGNAL_SIZE_WIDTH-1 downto 0;
    --subtype SIGNAL_WIDTH_RANGE is natural range C_SIGNAL_WIDTH-1 downto 0;
    --subtype OUTPUT_SIZE_RANGE is natural range C_OUTPUT_SIZE_WIDTH-1 downto 0;
	--subtype CLIPPER_RANGE is natural range C_SIGNAL_WIDTH+C_KERNEL_WIDTH+clog2(C_KERNEL_SIZE)-1 downto 16;
	type buffer_array is array(integer range<>) of std_logic_vector(C_SIGNAL_WIDTH-1 downto 0);

	
end user_pkg;
