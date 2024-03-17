library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is
    Generic(K : natural range 0 to 9 := 9);
    Port ( clk : in STD_LOGIC;
           clkIn : in STD_LOGIC;
           en : in STD_LOGIC;
           clkUpd : in STD_LOGIC;
           valUp : in STD_LOGIC; -- related to changing the counter value
           valDown : in STD_LOGIC; --
           rst : in STD_LOGIC; 
           ss  : in STD_LOGIC; -- start / stop
           pulseOut : out STD_LOGIC;
           digit : out STD_LOGIC_VECTOR(3 downto 0));
end Counter;

architecture Behavioral of Counter is
    signal s_counterValue : natural := K;
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
           if(en ='1' and clkIn = '1' and ss = '0') then
                if (s_counterValue < 0 or s_counterValue > K) then
                    s_counterValue <= K;
                else
                    s_counterValue <= (s_counterValue-1);
                end if;
           elsif(ss = '1' and clkUpd = '1') then
                if (valUp = '1') then
                    if (s_counterValue = K) then
                        s_counterValue <= 0;
                    else
                        s_counterValue <= s_counterValue + 1;
                    end if;
                elsif (valDown = '1') then
                    if (s_counterValue = 0) then
                        s_counterValue <= K;
                    else
                        s_counterValue <= s_counterValue - 1;
                    end if;
                end if;
           end if;
           if(s_counterValue=0) then
                pulseOut<='1';
           else 
                pulseOut<='0';
           end if;
           digit <= std_logic_vector(to_unsigned(s_counterValue,digit'length));
        end if;
    end process;
end Behavioral;
