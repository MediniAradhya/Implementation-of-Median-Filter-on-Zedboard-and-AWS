----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/03/29 11:09:56
-- Design Name: 
-- Module Name: triple_sorter - Behavioral
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

entity triple_sorter is
    Generic (
        width : positive := 8);
    Port ( clk    : in  std_logic;
           rst    : in  std_logic;
           en     : in  std_logic;
           in1 : in STD_LOGIC_VECTOR (width-1 downto 0);
           in2 : in STD_LOGIC_VECTOR (width-1 downto 0);
           in3 : in STD_LOGIC_VECTOR (width-1 downto 0);
           out1 : out STD_LOGIC_VECTOR (width-1 downto 0);
           out2 : out STD_LOGIC_VECTOR (width-1 downto 0);
           out3 : out STD_LOGIC_VECTOR (width-1 downto 0));
end triple_sorter;

architecture Behavioral of triple_sorter is
    signal a1 : STD_LOGIC_VECTOR (width-1 downto 0);
    signal a1s : STD_LOGIC_VECTOR (width-1 downto 0);
    signal a2 : STD_LOGIC_VECTOR (width-1 downto 0);
    signal a2s : STD_LOGIC_VECTOR (width-1 downto 0);
    signal a3 : STD_LOGIC_VECTOR (width-1 downto 0);
    signal b1 : STD_LOGIC_VECTOR (width-1 downto 0);
    signal b2 : STD_LOGIC_VECTOR (width-1 downto 0);
    signal b2s : STD_LOGIC_VECTOR (width-1 downto 0);
    signal b3 : STD_LOGIC_VECTOR (width-1 downto 0);
    signal b3s : STD_LOGIC_VECTOR (width-1 downto 0);
    signal c1 : STD_LOGIC_VECTOR (width-1 downto 0);
    signal c2 : STD_LOGIC_VECTOR (width-1 downto 0);

begin
    pipe1 : entity work.reg_3byte
        generic map (
            width => width)
        port map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => in1,
            in2       => in2,
            in3       => in3,
            out1      => a1,
            out2      => a2,
            out3      => a3);

    sort1 : entity work.dual_sorter
        generic map (
            width => width)
        port map (
            in1       => a1,
            in2       => a2,
            out1      => a1s,
            out2      => a2s);

    pipe2 : entity work.reg_3byte
        generic map (
            width => width)
        port map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => a1s,
            in2       => a2s,
            in3       => a3,
            out1      => b1,
            out2      => b2,
            out3      => b3);

    sort2 : entity work.dual_sorter
        generic map (
            width => width)
        port map (
            in1       => b2,
            in2       => b3,
            out1      => b2s,
            out2      => b3s);
            
    pipe3 : entity work.reg_3byte
        generic map (
            width => width)
        port map (
            clk       => clk,
            rst       => rst,
            en        => en,
            in1       => b1,
            in2       => b2s,
            in3       => b3s,
            out1      => c1,
            out2      => c2,
            out3      => out3);

    sort3 : entity work.dual_sorter
        generic map (
            width => width)
        port map (
            in1       => c1,
            in2       => c2,
            out1      => out1,
            out2      => out2);




end Behavioral;
