library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_top_tb is
end vga_top_tb;

architecture Behavioral of vga_top_tb is
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal H, V, R, G, B : STD_LOGIC;
    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.vga_top
        port map (clk => clk, rst => rst, H => H, V => V, R => R, G => G, B => B);
    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;
    stim_proc: process
    begin
        rst <= '1'; wait for 50 ns;
        rst <= '0'; wait for 20 ms;
        report "VGA simulation reached 20ms" severity note;
        wait;
    end process;
end Behavioral;
