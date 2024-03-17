library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipFlop is
    Port ( clk : in STD_LOGIC;
           pulse : in STD_LOGIC;
           en : in STD_LOGIC;
           pulseOut : out STD_LOGIC);
end flipFlop;

architecture Behavioral of flipFlop is
begin

process(clk)
begin
    if rising_edge(clk) then
        pulseOut <= pulse and en;
    end if;
end process;

end Behavioral;
