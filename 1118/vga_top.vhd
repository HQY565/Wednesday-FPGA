library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_top is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        H, V : out STD_LOGIC;
        R, G, B : out STD_LOGIC
    );
end vga_top;

architecture Behavioral of vga_top is
    signal pixel_clk : STD_LOGIC;
    signal row, column : STD_LOGIC_VECTOR(9 downto 0);
    signal red_signal, green_signal, blue_signal : STD_LOGIC;
    constant CIRCLE_X : integer := 160;
    constant CIRCLE_Y : integer := 240;
    constant R_SQUARE : integer := 3600;
    constant SQUARE_X1 : integer := 280;
    constant SQUARE_X2 : integer := 400;
    constant SQUARE_Y1 : integer := 180;
    constant SQUARE_Y2 : integer := 300;
begin
    clk_div_inst : entity work.clk_div
        port map (clk_100m => clk, rst => rst, clk_25m => pixel_clk);

    vga_driver_inst : entity work.vga_driver
        port map (
            clock => pixel_clk,
            red_in => red_signal, green_in => green_signal, blue_in => blue_signal,
            row => row, column => column,
            Rout => R, Gout => G, Bout => B, H => H, V => V
        );

    process(row, column)
        variable x_pos, y_pos : integer;
        variable c_x_diff, c_y_diff : integer;
        variable in_circle, in_square, in_triangle : boolean;
    begin
        x_pos := conv_integer(column);
        y_pos := conv_integer(row);
        in_circle := false;
        in_square := false;
        in_triangle := false;

        if x_pos < 640 and y_pos < 480 then
            c_x_diff := x_pos - CIRCLE_X;
            c_y_diff := y_pos - CIRCLE_Y;
            if (c_x_diff * c_x_diff + c_y_diff * c_y_diff) <= R_SQUARE then
                in_circle := true;
            end if;
            if x_pos >= SQUARE_X1 and x_pos <= SQUARE_X2 and
               y_pos >= SQUARE_Y1 and y_pos <= SQUARE_Y2 then
                in_square := true;
            end if;
            -- 保留課堂原始三角形條件：右下角超過 x=639 時會裁切
            if y_pos >= 180 and y_pos <= 300 then
                if x_pos >= (540 - (y_pos - 180)) and
                   x_pos <= (540 + (y_pos - 180)) then
                    in_triangle := true;
                end if;
            end if;

            if in_circle then
                red_signal <= '1'; green_signal <= '0'; blue_signal <= '0';
            elsif in_square then
                red_signal <= '0'; green_signal <= '1'; blue_signal <= '0';
            elsif in_triangle then
                red_signal <= '0'; green_signal <= '0'; blue_signal <= '1';
            else
                red_signal <= '0'; green_signal <= '0'; blue_signal <= '0';
            end if;
        else
            red_signal <= '0'; green_signal <= '0'; blue_signal <= '0';
        end if;
    end process;
end Behavioral;
