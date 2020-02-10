-- Greg Stitt
-- University of Florida
-- EEL 5721/4720 Reconfigurable Computing
--
-- File: user_app_tb.vhd
--
-- Description: This file implements a testbench for the simple pipeline
-- when running on the ZedBoard. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use work.config_pkg.all;
use work.user_pkg.all;

entity user_app_tb is
end user_app_tb;

architecture behavior of user_app_tb is

    constant TEST_SIZE : integer := 400*300/4;
    constant TEST_COLUMN : integer := 300/4;
    constant MAX_CYCLES : integer  := TEST_SIZE*4;
	constant C_MMAP_CYCLES : positive := 1;
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    signal mmap_wr_en   : std_logic                         := '0';
    signal mmap_wr_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
    signal mmap_wr_data : std_logic_vector(MMAP_DATA_RANGE) := (others => '0');

    signal mmap_rd_en   : std_logic                         := '0';
    signal mmap_rd_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
    signal mmap_rd_data : std_logic_vector(MMAP_DATA_RANGE);
	

    signal sim_done : std_logic := '0';
	signal rd_addr,wradr : integer:=0;
	signal temp2 : integer ;
	
	file file_VECTORS : text;
	file file_RESULTS : text;

begin

    UUT : entity work.user_app
        port map (
            clk          => clk,
            rst          => rst,
            mmap_wr_en   => mmap_wr_en,
            mmap_wr_addr => mmap_wr_addr,
            mmap_wr_data => mmap_wr_data,
            mmap_rd_en   => mmap_rd_en,
            mmap_rd_addr => mmap_rd_addr,
            mmap_rd_data => mmap_rd_data
			);

    -- toggle clock
    clk <= not clk after 5 ns when sim_done = '0' else clk;

    -- process to test different inputs
    process


        -- function inttofp ( j : in integer) return std_logic_vector(31 downto 0) is
			-- variable k : std_logic_vector(7 downto 0);
			-- variable mant : std_logic_vector(22 downto 0);
			-- variable exp  : std_logic_vector(7 downto 0);
			-- begin
				-- k=std_logic_vector(to_unsigned(j,8));
				-- for i in 7 to 0 loop
					-- if(i>1) then
						-- if(k(i)='1') then
							-- mant:=k(i-1 downto 0)& std_logic_vector(to_unsigned(0,23-i));
							-- exp:=std_logic_vector(to_unsigned(i,8)+to_unsigned(127,8));
						-- end if;
					-- else 
						-- mant:=(others=>'0')
					-- end if;
				-- end loop;
			-- return ('0' & exp & mant);
		-- end inttofp;
		

		
		procedure clearMMAP is
        begin
            mmap_rd_en <= '0';
            mmap_wr_en <= '0';
        end clearMMAP;

        variable errors       : integer := 0;
        variable total_points : real    := 50.0;
        variable min_grade    : real    := total_points*0.25;
        variable grade        : real;

        variable result : std_logic_vector(C_MMAP_DATA_WIDTH-1 downto 0);
        variable done   : std_logic;
        variable count  : integer;
		variable temp1,temp2,temp3,temp4 : integer;
		file file_VECTORS : text is in "sw400.txt" ;
		file file_RESULTS : text is out "output_results.txt" ;
		variable v_ILINE     : line;
		variable v_OLINE     : line;
		variable fp : std_logic_vector(31 downto 0):=(others=>'0');
		variable k : std_logic_vector(7 downto 0):= (others=>'0');
		variable mant : std_logic_vector(22 downto 0) :=(others=>'0');
		variable exp  : std_logic_vector(7 downto 0) :=(others=>'0');
		variable flag : std_logic:='0';
			
	
	begin

        -- reset circuit  
        rst <= '1';
        clearMMAP;
        wait for 200 ns;

        rst <= '0';
        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';

        --Write Pixel values in Input RAM
	   while not endfile(file_VECTORS) loop
			readline(file_VECTORS, v_ILINE);
			read(v_ILINE, temp1);
			readline(file_VECTORS, v_ILINE);
			read(v_ILINE, temp2);
			readline(file_VECTORS, v_ILINE);
			read(v_ILINE, temp3);
			readline(file_VECTORS, v_ILINE);
			read(v_ILINE, temp4);
			--k:=std_logic_vector(to_unsigned(temp1,8));
			-- for i in 7 downto 1 loop
				-- if(k(i)='1') then
					-- if(flag='0') then
						-- mant:=k(i-1 downto 0)& std_logic_vector(to_unsigned(0,23-i));
						-- exp:=std_logic_vector(to_unsigned(i,8)+to_unsigned(127,8));
						-- flag:='1';
					-- end if;
				-- end if;
			-- end loop;
			-- if(flag='0') then
				-- if(k(0)='1') then
					-- mant:=(others=>'0');
					-- exp:=std_logic_vector(to_unsigned(127,8));
				-- else 
					-- mant:=(others=>'0');
					-- exp:=(others=>'0');
				-- end if;
			-- else 
				-- flag:='0';
			-- end if;		
			-- fp(30 downto 0):= exp & mant;
			-- fp(31):='0';
			mmap_wr_data<=std_logic_vector(to_unsigned(temp1,8))&std_logic_vector(to_unsigned(temp2,8))&std_logic_vector(to_unsigned(temp3,8))&std_logic_vector(to_unsigned(temp4,8));
			mmap_wr_en<='1';
			mmap_wr_addr <= std_logic_vector(to_unsigned(wradr, C_MMAP_ADDR_WIDTH));
			wradr<=wradr+1;
  
			
			for j in 0 to C_MMAP_CYCLES-1 loop
					wait until rising_edge(clk);
					clearMMAP;
			end loop;
        
		end loop;
		
		
		-- send size
        mmap_wr_addr <= C_SIZE_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(TEST_SIZE, C_MMAP_DATA_WIDTH));
        wait until clk'event and clk = '1';
        clearMMAP;

		-- send size
        mmap_wr_addr <= C_COLUMN_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(TEST_COLUMN, C_MMAP_DATA_WIDTH));
        wait until clk'event and clk = '1';
        clearMMAP;

        -- send go = 1 over memory map
        mmap_wr_addr <= C_GO_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(1, C_MMAP_DATA_WIDTH));
        wait until clk'event and clk = '1';
        clearMMAP;
        
        done  := '0';
        count := 0;

        -- read the done signal every cycle to see if the circuit has
        -- completed.
        --
        -- equivalent to wait until (done = '1') for TIMEOUT;      
        while done = '0' and count < MAX_CYCLES loop

            mmap_rd_addr <= C_DONE_ADDR;
            mmap_rd_en   <= '1';
            wait until clk'event and clk = '1';
            clearMMAP;
            -- give entity one cycle to respond
            wait until clk'event and clk = '1';
            done         := mmap_rd_data(0);
            count        := count + 1;
        end loop;

        if (done /= '1') then
            errors := errors + 1;
            report "Done signal not asserted before timeout.";
        end if;
            for j in 0 to 100 loop
                wait until rising_edge(clk);
            end loop;

        -- read outputs from output memory
           for i in 0 to TEST_SIZE-1 loop
				mmap_rd_en<='1';
				mmap_rd_addr<=std_logic_vector(to_unsigned(i,C_MMAP_ADDR_WIDTH));
				wait until rising_edge(clk);
				wait until rising_edge(clk);
				--temp2<=to_integer(unsigned(mmap_rd_data(7 downto 0)));
				write(v_OLINE,to_integer(unsigned(mmap_rd_data(31 downto 24))));
				writeline(file_RESULTS, v_OLINE);
				write(v_OLINE,to_integer(unsigned(mmap_rd_data(23 downto 16))));
				writeline(file_RESULTS, v_OLINE);
				write(v_OLINE,to_integer(unsigned(mmap_rd_data(15 downto 8))));
				writeline(file_RESULTS, v_OLINE);
				write(v_OLINE,to_integer(unsigned(mmap_rd_data(7 downto 0))));
				writeline(file_RESULTS, v_OLINE);
			
				--mmap_rd_data<=std_logic_vector(to_unsigned(temp2,C_MMAP_DATA_WIDTH));
				--rd_addr<=rd_addr+1;
				for j in 0 to C_MMAP_CYCLES-1 loop
					wait until rising_edge(clk);
					clearMMAP;
				end loop;

				
			end loop;  -- i

        report "SIMULATION FINISHED!!!";

        grade := total_points-(real(errors)*total_points*0.05);
        if grade < min_grade then
            grade := min_grade;
        end if;

        report "TOTAL ERRORS : " & integer'image(errors);
        report "GRADE = " & integer'image(integer(grade)) & " out of " &
            integer'image(integer(total_points));
        sim_done <= '1';
        wait;

    end process;
end behavior;
