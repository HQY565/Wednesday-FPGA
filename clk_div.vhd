library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_div is
    Port (
        clk_100m : in STD_LOGIC;
        rst      : in STD_LOGIC;
        clk_25m  : out STD_LOGIC
    );
end clk_div;

architecture Behavioral of clk_div is
    signal count : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal temp_clk : STD_LOGIC := '0';
begin
    process(clk_100m, rst)
    begin
        if rst = '1' then
            count <= (others => '0');
            temp_clk <= '0';
        elsif rising_edge(clk_100m) then
            if count = "01" then
                temp_clk <= not temp_clk;
                count <= (others => '0');
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clk_25m <= temp_clk;
end Behavioral;
