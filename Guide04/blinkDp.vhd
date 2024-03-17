library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blinkDp is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ss : in STD_LOGIC;
           pulse_out : out STD_LOGIC);
end blinkDp;

architecture Behavioral of blinkDp is
    signal light : STD_LOGIC := '1';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                if (ss = '0') then
                    light <= not light;
                end if;
            end if;
            pulse_out <= light;
        end if;
    end process;

end Behavioral;
