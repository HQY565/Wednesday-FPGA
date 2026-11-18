library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity vga_driver is
    port(
        clock : in std_logic;
        red_in, green_in, blue_in : in std_logic;
        row, column : out std_logic_vector(9 downto 0);
        Rout, Gout, Bout, H, V : out std_logic
    );
end vga_driver;

architecture behavioral of vga_driver is
    subtype counter is std_logic_vector(9 downto 0);
    constant B : natural := 93;
    constant C : natural := 45;
    constant D : natural := 640;
    constant E : natural := 22;
    constant A : natural := B + C + D + E;
    constant P : natural := 2;
    constant Q : natural := 32;
    constant R : natural := 480;
    constant S : natural := 11;
    constant O : natural := P + Q + R + S;
begin
    Rout <= red_in;
    Gout <= green_in;
    Bout <= blue_in;

    process
        variable vertical, horizontal : counter := (others => '0');
    begin
        wait until rising_edge(clock);
        if horizontal < A - 1 then
            horizontal := horizontal + 1;
        else
            horizontal := (others => '0');
            if vertical < O - 1 then
                vertical := vertical + 1;
            else
                vertical := (others => '0');
            end if;
        end if;

        if horizontal >= (D + E) and horizontal < (D + E + B) then
            H <= '0';
        else
            H <= '1';
        end if;
        if vertical >= (R + S) and vertical < (R + S + P) then
            V <= '0';
        else
            V <= '1';
        end if;

        row <= vertical;
        column <= horizontal;
    end process;
end architecture;
