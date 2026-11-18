library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;

-- Vivado 2018.3 XSim: captures the actual outputs of vga_top
-- into a plain-text PPM image (P3, 640x480).
entity vga_image_tb is
end entity;

architecture Behavioral of vga_image_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal H, V, R, G, B : std_logic;

    constant SYS_PERIOD : time := 10 ns;  -- 100 MHz
    constant PIX_PERIOD : time := 40 ns;  -- 25 MHz
    constant LINE_PERIOD : time := 32 us; -- 800 * 40 ns

begin
    DUT : entity work.vga_top
        port map (
            clk => clk, rst => rst,
            H => H, V => V,
            R => R, G => G, B => B
        );

    clk <= not clk after SYS_PERIOD / 2;

    process
    begin
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait;
    end process;

    process
        file img : text open write_mode is "vga_output.ppm";
        variable ln : line;
        variable rr, gg, bb : integer;
    begin
        -- PPM header
        write(ln, string'("P3")); writeline(img, ln);
        write(ln, string'("640 480")); writeline(img, ln);
        write(ln, string'("255")); writeline(img, ln);

        -- VSYNC is active low. Its rising edge starts row 493
        -- in the supplied vga_driver; row 0 begins 32 lines later.
        wait until rising_edge(V);
        wait for (32 * LINE_PERIOD) + 1 ns;

        -- Sample each active pixel of a full 640 x 480 frame.
        for y in 0 to 479 loop
            for x in 0 to 639 loop
                if R = '1' then rr := 255; else rr := 0; end if;
                if G = '1' then gg := 255; else gg := 0; end if;
                if B = '1' then bb := 255; else bb := 0; end if;

                write(ln, rr);
                write(ln, string'(" "));
                write(ln, gg);
                write(ln, string'(" "));
                write(ln, bb);
                write(ln, string'(" "));
                wait for PIX_PERIOD;
            end loop;
            writeline(img, ln);
            -- 800 total clocks - 640 displayed clocks = 160 clocks
            wait for 160 * PIX_PERIOD;
        end loop;

        report "Image written: vga_output.ppm (640x480)" severity note;
        wait;
    end process;
end Behavioral;
