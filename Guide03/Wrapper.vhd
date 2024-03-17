library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Wrapper is
    port(clk	: in  std_logic;
		 dp	: out std_logic;
		 an : out std_logic_vector(7 downto 0);
		 seg: out std_logic_vector(6 downto 0)
		 );
end Wrapper;

architecture Behavioral of Wrapper is

    signal pulseOut : STD_LOGIC;
    
begin
    PulseGenerator: entity work.PulseGenerator
       port map(clk => clk,
                clkOut => pulseOut);

    Display_Drivers: entity work.Nexys4DispDriver
	   port map(clk => clk,
	            clk_en => pulseOut,
	            EN_digits => x"FF",
	            EN_dot => not x"AE",
	            D0 => x"4",
	            D1 => x"2",
	            D2 => x"0",
	            D3 => x"2",
	            D4 => x"3",
	            D5 => x"0",
	            D6 => x"3",
	            D7 => x"0",
	            cat_L => seg,
	            an_L => an,
	            dp_L => dp);
end Behavioral;
