----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/03/29 10:51:26
-- Design Name: 
-- Module Name: dual_sorter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dual_sorter is
    Generic (
        width : positive := 8);
    Port ( in1 : in STD_LOGIC_VECTOR (width-1 downto 0);
           in2 : in STD_LOGIC_VECTOR (width-1 downto 0);
           out1 : out STD_LOGIC_VECTOR (width-1 downto 0);
           out2 : out STD_LOGIC_VECTOR (width-1 downto 0));
end dual_sorter;

architecture Behavioral of dual_sorter is

begin
    process(in1, in2)
    begin
        if unsigned(in1)<unsigned(in2) then
            out1 <= in1;
            out2 <= in2;
        else
            out1 <= in2;
            out2 <= in1;
        end if;
    end process;


end Behavioral;
