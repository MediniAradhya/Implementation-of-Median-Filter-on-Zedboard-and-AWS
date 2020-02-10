----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/04/02 13:26:33
-- Design Name: 
-- Module Name: mid_filter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mid_filter is
    Generic (
        width : positive := 8);
    Port ( clk    : in  std_logic;
           rst    : in  std_logic;
           en     : in  std_logic;
           input_prev : in STD_LOGIC_VECTOR (3*width-1 downto 0);
           input_curr : in STD_LOGIC_VECTOR (3*width-1 downto 0);
           input_next : in STD_LOGIC_VECTOR (3*width-1 downto 0);
           output : out STD_LOGIC_VECTOR (width-1 downto 0);
           vld_out : out std_logic);
end mid_filter;

architecture Behavioral of mid_filter is
    signal a,b : STD_LOGIC_VECTOR (9*width-1 downto 0);
    signal vld1, vld2, vld3, vld4, vld5, vld6, vld7, vld8 : std_logic;  
begin
    REGV1 : entity work.regbit port map(clk, rst, '1', en, vld1);
    REGV2 : entity work.regbit port map(clk, rst, '1', vld1, vld2);
    REGV3 : entity work.regbit port map(clk, rst, '1', vld2, vld3);
    REGV4 : entity work.regbit port map(clk, rst, '1', vld3, vld4);
    REGV5 : entity work.regbit port map(clk, rst, '1', vld4, vld5);
    REGV6 : entity work.regbit port map(clk, rst, '1', vld5, vld6);
    REGV7 : entity work.regbit port map(clk, rst, '1', vld6, vld7);
    REGV8 : entity work.regbit port map(clk, rst, '1', vld7, vld8);
    REGV9 : entity work.regbit port map(clk, rst, '1', vld8, vld_out);  
    sort_11 : entity work.triple_sorter
        Generic Map (
            width => width)
        Port Map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => input_prev(3*width-1 downto 2*width),
            in2       => input_prev(2*width-1 downto width),
            in3       => input_prev(width-1 downto 0),
            out1      => a(1*width-1 downto 0*width),
            out2      => a(2*width-1 downto 1*width),
            out3      => a(3*width-1 downto 2*width));           

    sort_12 : entity work.triple_sorter
        Generic Map (
            width => width)
        Port Map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => input_curr(3*width-1 downto 2*width),
            in2       => input_curr(2*width-1 downto width),
            in3       => input_curr(width-1 downto 0),
            out1      => a(4*width-1 downto 3*width),
            out2      => a(5*width-1 downto 4*width),
            out3      => a(6*width-1 downto 5*width));           

    sort_13 : entity work.triple_sorter
        Generic Map (
            width => width)
        Port Map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => input_next(3*width-1 downto 2*width),
            in2       => input_next(2*width-1 downto width),
            in3       => input_next(width-1 downto 0),
            out1      => a(7*width-1 downto 6*width),
            out2      => a(8*width-1 downto 7*width),
            out3      => a(9*width-1 downto 8*width));           

    sort_21 : entity work.triple_sorter
        Generic Map (
            width => width)
        Port Map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => a(1*width-1 downto 0*width),
            in2       => a(4*width-1 downto 3*width),
            in3       => a(7*width-1 downto 6*width),
            out1      => b(1*width-1 downto 0*width),
            out2      => b(4*width-1 downto 3*width),
            out3      => b(7*width-1 downto 6*width));           

    sort_22 : entity work.triple_sorter
        Generic Map (
            width => width)
        Port Map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => a(2*width-1 downto 1*width),
            in2       => a(5*width-1 downto 4*width),
            in3       => a(8*width-1 downto 7*width),
            out1      => b(2*width-1 downto 1*width),
            out2      => b(5*width-1 downto 4*width),
            out3      => b(8*width-1 downto 7*width));           

    sort_23 : entity work.triple_sorter
        Generic Map (
            width => width)
        Port Map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => a(3*width-1 downto 2*width),
            in2       => a(6*width-1 downto 5*width),
            in3       => a(9*width-1 downto 8*width),
            out1      => b(3*width-1 downto 2*width),
            out2      => b(6*width-1 downto 5*width),
            out3      => b(9*width-1 downto 8*width));           

    sort_3 : entity work.triple_sorter
        Generic Map (
            width => width)
        Port Map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => b(3*width-1 downto 2*width),
            in2       => b(5*width-1 downto 4*width),
            in3       => b(7*width-1 downto 6*width),
            out2      => output);           

end Behavioral;
