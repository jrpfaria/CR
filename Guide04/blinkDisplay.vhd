library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blinkDisplay is
    Generic ( defEn : STD_LOGIC_VECTOR(7 downto 0));
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           code : in STD_LOGIC_VECTOR (7 downto 0);
           pulse : out STD_LOGIC_VECTOR (7 downto 0)
         );
end blinkDisplay;

architecture Behavioral of blinkDisplay is
    signal s_pulse : STD_LOGIC_VECTOR(7 downto 0) := defEn;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                for i in code'range loop
                    if code(i) = '1' then
                        s_pulse(i) <= not s_pulse(i);
                    else
                        s_pulse(i) <= defEn(i);
                    end if;
                end loop;
            end if;
        end if;
    end process;

    pulse <= s_pulse;
    
end Behavioral;
