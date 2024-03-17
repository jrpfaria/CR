library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity PulseGenerator is
    generic(K : positive := 100_000_000);
    port(
        clk    : in  std_logic;
        clkOut : out std_logic
    );
end PulseGenerator;

architecture RTL of PulseGenerator is
    signal s_divCounter : natural;
begin    
    process(clk)
    begin
        if rising_edge(clk) then
            if (s_divCounter = K - 1) then
                clkOut <= '1';
                s_divCounter <= 0;
            else
                clkOut <= '0';
                s_divCounter <= s_divCounter + 1;
            end if;
        end if;
    end process;

end RTL;
