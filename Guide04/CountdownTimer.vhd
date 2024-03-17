library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CountdownTimer is
    Port (clk   : in std_logic;
          clkIn : in std_logic;
          clkUpd: in std_logic;
          valUp : in std_logic_vector(3 downto 0);
          valDown : in std_logic_vector(3 downto 0);
          reset : in std_logic;
          ss    : in std_logic; -- start stop
          d0    : out std_logic_vector(3 downto 0);
          d1    : out std_logic_vector(3 downto 0);
          d2    : out std_logic_vector(3 downto 0);
          d3    : out std_logic_vector(3 downto 0);
          dp_en : out std_logic;
          done  : out std_logic);
end CountdownTimer;
    
architecture Behavioral of CountdownTimer is
    signal s_clkIn      : std_logic;
    signal s_done       : std_logic;
    signal s_secondUnitsPulse : std_logic;
    signal s_secondTenEnable : std_logic;
    signal s_secondTensPulse : std_logic;
    signal s_minuteUnitEnable : std_logic;
    signal s_minuteUnitsPulse : std_logic;
    signal s_minuteTenEnable : std_logic;
    signal s_minuteTensPulse : std_logic;
    
begin

    s_clkIn <= clkIn and (not s_done);
    SecondUnits: entity work.Counter
        generic map(K => 9)
        port map(clk => clk,
                 clkIn => s_clkIn,
                 en => '1',
                 rst => '0',
                 clkUpd => clkUpd,
                 valUp => valUp(0),
                 valDown => valDown(0),
                 ss => ss,
                 pulseOut => s_secondUnitsPulse,
                 digit => d0);
                 
    s_secondTenEnable <= s_secondUnitsPulse and s_clkIn;
    SecondTens: entity work.Counter
        generic map(K => 5)
        port map(clk => clk,
                 clkIn => s_clkIn,
                 en => s_secondUnitsPulse,
                 rst => '0',
                 clkUpd => clkUpd,
                 valUp => valUp(1),
                 valDown => valDown(1),
                 ss => ss,
                 pulseOut => s_secondTensPulse,
                 digit => d1);
                 
    s_minuteUnitEnable <= s_secondTensPulse and s_secondUnitsPulse and s_clkIn;
    MinuteUnits: entity work.Counter
        generic map(K => 9)
        port map(clk => clk,
                 clkIn => s_clkIn,
                 clkUpd => clkUpd,
                 valUp => valUp(2),
                 valDown => valDown(2),
                 en => s_minuteUnitEnable,
                 rst => '0',
                 ss => ss,
                 pulseOut => s_minuteUnitsPulse,
                 digit => d2);
                 
    s_minuteTenEnable <= s_minuteUnitsPulse and s_secondTensPulse and s_secondUnitsPulse and s_clkIn;
    MinuteTens: entity work.Counter
        generic map(K => 5)
        port map(clk => clk,
                 clkIn => s_clkIn,
                 en => s_minuteTenEnable,
                 rst => '0',
                 clkUpd => clkUpd,
                 valUp => valUp(3),
                 valDown => valDown(3),
                 ss => ss,
                 pulseOut => s_minuteTensPulse,
                 digit => d3);
     
     s_done <= s_minuteTensPulse and s_minuteUnitsPulse and s_secondTensPulse and s_secondUnitsPulse;
     done <= s_done;
end Behavioral;