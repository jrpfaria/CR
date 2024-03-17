library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity PulseGenerator is
    port(
        clk    : in  std_logic;
        clkOut : out std_logic
    );
end PulseGenerator;

architecture RTL of PulseGenerator is
    signal s_divCounter : unsigned(15 downto 0);
    signal s_pulseCounter : unsigned(3 downto 0);
    signal s_pulseActive : std_logic;

begin    
    process(clk)
    begin
        if rising_edge(clk) then
            if s_divCounter = 62499 then  -- 1.25ms period for 50MHz clock
                s_divCounter <= (others => '0');
                if s_pulseCounter = 9 then  -- 10ns pulse width
                    s_pulseCounter <= (others => '0');
                    s_pulseActive <= '0';
                else
                    s_pulseCounter <= s_pulseCounter + 1;
                    s_pulseActive <= '1';
                end if;
            else
                s_divCounter <= s_divCounter + 1;
                s_pulseActive <= '0';
            end if;
        end if;
    end process;

    clkOut <= s_pulseActive;

end RTL;
