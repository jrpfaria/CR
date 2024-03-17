library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Wrapper is
    Port ( clk : in STD_LOGIC;
           btnC : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           led  : out STD_LOGIC_VECTOR(0 downto 0);
           dp   : out STD_LOGIC;
           an   : out STD_LOGIC_VECTOR(7 downto 0);
           seg  : out STD_LOGIC_VECTOR(6 downto 0)
         );
end Wrapper;

architecture Behavioral of Wrapper is
    signal pulseOut, pulseOutCounter, pulseOutUpdate, pulseOutDp, pulseOutUpDown: STD_LOGIC;
    signal s_dot : STD_LOGIC := '1';
    signal s_btnC, s_btnR, s_btnU, s_btnD: STD_LOGIC;
    signal s_stop : STD_LOGIC := '1';
    signal s_done : STD_LOGIC;
    signal s_dotEn : STD_LOGIC_VECTOR(7 downto 0) := x"10";
    signal digit0, digit1, digit2, digit3 : STD_LOGIC_VECTOR(3 downto 0);
    signal s_displaysToBlink, s_processedDispEn : STD_LOGIC_VECTOR (7 downto 0);
    signal s_up, s_down : STD_LOGIC_VECTOR(3 downto 0) := x"0";

    type TState is (start, stop, d0, d1, d2, d3);
    signal state : TState := stop;

begin
    PulseGeneratorDisplay: entity work.PulseGenerator
       generic map(K => 100_000)
       port map(clk => clk,
                clkOut => pulseOut);
                
    PulseGeneratorCounter: entity work.PulseGenerator
       generic map(K => 100_000_000) -- 1Hz
       port map(clk => clk,
                clkOut => pulseOutCounter);
    
    PulseGeneratorUpdate: entity work.PulseGenerator
       generic map(K => 25_000_000)
       port map(clk => clk,
                clkOut => pulseOutUpdate);
                
    PulseGeneratorUpDown: entity  work.PulseGenerator
       generic map(K => 50_000_000)
       port map(clk => clk,
                clkOut => pulseOutUpDown);
    
    PulseGeneratorDecimalPointer: entity work.PulseGenerator
        generic map(K => 50_000_000)
        port map(clk => clk,
                 clkOut => pulseOutDp);            
                
    Display_Drivers: entity work.Nexys4DispDriver
	   port map(clk => clk,
	            clk_en => pulseOut,
	            EN_digits => s_processedDispEn,
	            EN_dot => s_dotEn,
	            D0 => x"0",
	            D1 => x"0",
	            D2 => digit0,
	            D3 => digit1,
	            D4 => digit2,
	            D5 => digit3,
	            D6 => x"0",
	            D7 => x"0",
	            cat_L => seg,
	            an_L => an,
	            dp_L => dp);
    
    CountdownTimer: entity work.CountdownTimer
        port map(clk => clk,
                 clkIn => pulseOutCounter,
                 clkUpd => pulseOutUpDown,
                 reset => '0',
                 valUp => s_up,
                 valDown => s_down,
                 ss => s_stop,
                 d0 => digit0,
                 d1 => digit1,
                 d2 => digit2,
                 d3 => digit3,
                 dp_en => s_dot,
                 done => s_done);	  
    
    DebouncingUnitC: entity work.DebouncingUnit
        port map(refClk => clk,
                 dirty => btnC,
                 pulsedOut => s_btnC);
                 
    DebouncingUnitR: entity work.DebouncingUnit
        port map(refClk => clk,
                 dirty => btnR,
                 pulsedOut => s_btnR);
    
    BlinkDisplay: entity work.blinkDisplay
        generic map(defEn => x"3C")
        port map(clk => clk,
                 en => pulseOutUpdate,
                 code => s_displaysToBlink,
                 pulse => s_processedDispEn);
    
    BlinkDecimalPoint: entity work.blinkDp
        port map (clk => clk,
                  en => pulseOutDp,
                  ss => s_stop,
                  pulse_out => s_dot);
    
    FlipFlopUp: entity work.flipFlop
        port map (clk => clk,
                  en => '1',
                  pulse => btnU,
                  pulseOut => s_btnU);
                  
    FlipFlopDown: entity work.flipFlop
        port map (clk => clk,
                  en => '1',
                  pulse => btnD,
                  pulseOut => s_btnD);     
    
    process(clk)
    begin
        if(rising_edge(clk)) then
            led(0) <= s_done;
            s_dotEn(4) <= s_dot;
        end if;
    end process;
    
    StateMachineProcess: process(clk)
    begin
        if rising_edge(clk) then
            case state is
                -- Start
                when start =>
                    if (s_btnC = '1' or s_done = '1') then
                        state <= stop;
                    elsif (s_btnR = '1') then
                        state <= d3;
                    end if;
                    s_displaysToBlink <= x"00";
                    s_stop <= '0';
                
                -- Stop
                when stop =>
                    if (s_btnC = '1') then
                        state <= start;
                    else
                        s_stop <= '1';
                    end if;
                    s_displaysToBlink <= x"00";
                   
                -- Digit 3
                when d3 =>
                    if (pulseOutUpDown = '1') then
                        if (s_btnU = '1') then
                            s_up <= x"8";
                        elsif (s_btnD = '1') then
                            s_down <= x"8";
                        else
                            s_up <= x"0";
                            s_down <= x"0";
                        end if;
                    
                    end if;
                    if (s_btnR = '1') then
                        state <= d2;
                    end if;
                    s_displaysToBlink <= x"20";
                    s_stop <= '1';
                    
                -- Digit 2
                when d2 =>
                    if (pulseOutUpDown = '1') then
                        if (s_btnU = '1') then
                            s_up <= x"4";
                        elsif (s_btnD = '1') then
                            s_down <= x"4";
                        else
                            s_up <= x"0";
                            s_down <= x"0";
                        end if;
                    end if;
                    if (s_btnR = '1') then
                        state <= d1;
                    end if;
                    s_displaysToBlink <= x"10";
                    
                -- Digit 1
                when d1 =>
                    if (pulseOutUpDown = '1') then
                        if (s_btnU = '1') then
                            s_up <= x"2";
                        elsif (s_btnD = '1') then
                            s_down <= x"2";
                        else
                            s_up <= x"0";
                            s_down <= x"0";
                        end if;
                    end if;
                    if (s_btnR = '1') then
                        state <= d0;
                    end if;
                    s_displaysToBlink <= x"08";
                    
                -- Digit 0
                when d0 =>
                    if (pulseOutUpDown = '1') then
                        if (s_btnU = '1') then
                            s_up <= x"1";
                        elsif (s_btnD = '1') then
                            s_down <= x"1";
                        else
                            s_up <= x"0";
                            s_down <= x"0";
                        end if;
                    end if;
                    if (s_btnR = '1') then
                        state <= stop;
                    end if;
                    s_displaysToBlink <= x"04";
            end case;
        end if;
    end process;
    
end Behavioral;
