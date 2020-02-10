library ieee;
use ieee.std_logic_1164.all;

entity reg_3byte is
  generic (
    width  :     positive);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    en     : in  std_logic;
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1 downto 0);
    in3    : in  std_logic_vector(width-1 downto 0);
    out1   : out std_logic_vector(width-1 downto 0);
    out2   : out std_logic_vector(width-1 downto 0);
    out3   : out std_logic_vector(width-1 downto 0));
end reg_3byte;

architecture BHV of reg_3byte is
begin
  process(clk, rst)
  begin
    if (rst = '1') then
      out1   <= (others => '0');
      out2   <= (others => '0');
      out3   <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (en = '1') then
        out1 <= in1;
        out2 <= in2;
        out3 <= in3;
      end if;
    end if;
  end process;
end BHV;
