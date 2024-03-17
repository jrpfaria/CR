library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nexys4DispDriver is
    Port(clk        : in STD_LOGIC;
         clk_en     : in STD_LOGIC;
         EN_digits  : in STD_LOGIC_VECTOR(7 downto 0);
         EN_dot     : in STD_LOGIC_VECTOR(7 downto 0);
         D0         : in STD_LOGIC_VECTOR(3 downto 0);
         D1         : in STD_LOGIC_VECTOR(3 downto 0);
         D2         : in STD_LOGIC_VECTOR(3 downto 0);
         D3         : in STD_LOGIC_VECTOR(3 downto 0);
         D4         : in STD_LOGIC_VECTOR(3 downto 0);
         D5         : in STD_LOGIC_VECTOR(3 downto 0);
         D6         : in STD_LOGIC_VECTOR(3 downto 0);
         D7         : in STD_LOGIC_VECTOR(3 downto 0);
         an_L       : out STD_LOGIC_VECTOR(7 downto 0);
         cat_L      : out STD_LOGIC_VECTOR(6 downto 0);
         dp_L       : out STD_LOGIC
        );
end Nexys4DispDriver;


architecture Behavioral of Nexys4DispDriver is
        signal s_dispNumber : NATURAL range 0 to 7 := 0;
        signal s_enable     : STD_LOGIC;
        signal s_digit      : STD_LOGIC_VECTOR(3 downto 0);
begin
    
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (clk_en = '1') then
                s_dispNumber <= s_dispNumber + 1;
            end if;
        end if;
    end process;

    process (s_dispNumber, D0, D1, D2, D3, D4, D5, D6, D7, EN_dot, EN_digits)            
    begin
        dp_L <= not EN_dot(s_dispNumber);
        s_enable <= EN_digits(s_dispNumber);
        case s_dispNumber is
            when 0 => s_digit <= D0;
                      an_L <= x"FE";
            when 1 => s_digit <= D1;
                      an_L <= x"FD";
            when 2 => s_digit <= D2;
                      an_L <= x"FB";
            when 3 => s_digit <= D3;
                      an_L <= x"F7";
            when 4 => s_digit <= D4;
                      an_L <= x"EF";
            when 5 => s_digit <= D5;
                      an_L <= x"DF";
            when 6 => s_digit <= D6;
                      an_L <= x"BF";
            when 7 => s_digit <= D7;
                      an_L <= x"7F";
            when others => null;
        end case;
    end process;
    
    process(s_enable, s_digit)
    begin
        if (s_enable = '0') then
            cat_L <= (others => '1');
        else
            case s_digit is
                when x"0" =>
                    cat_L <= "1000000";
                when x"1" =>
                    cat_L <= "1111001";
                when x"2" =>
                    cat_L <= "0100100";
                when x"3" =>
                    cat_L <= "0110000";
                when x"4" =>
                    cat_L <= "0011001";
                when x"5" =>
                    cat_L <= "0010010";
                when x"6" =>
                    cat_L <= "0000010";
                when x"7" =>
                    cat_L <= "1111000";
                when x"8" =>
                    cat_L <= "0000000";
                when x"9" =>
                    cat_L <= "0010000";
                when others =>
                    cat_L <= "1111111";
            end case;
        end if;
    end process;

end Behavioral;