# ZC702 HDMI 後續規劃（尚未完成實體測試）

目前 `rtl/vga_top.vhd` 是教學用 VGA 波形輸出：`H/V/R/G/B` 五個單 bit 訊號，**不是** ZC702 板載 HDMI 的頂層。不可將其直接與 HDMI 專用 XDC 綁定並期待螢幕顯示。

若要轉為 ZC702 的 HDMI 實作，須額外完成：

1. 在 Vivado IP Integrator 建立 ZYNQ7 Processing System，設定板卡、PS clock / reset 與 I²C。
2. 以 Clocking Wizard 產生符合影像模式的像素時脈，做好重置/跨時脈設計。
3. 增加 HDMI 的 `hdmi_clk`、`hdmi_hsync`、`hdmi_vsync`、`hdmi_de`、`hdmi_data[15:0]`，使用適當 16-bit YCbCr 4:2:2 封裝與同步。
4. 透過 PS I²C 配置 PCA9548 與 ADV7511，確認彩色空間、取樣時序及 HPD。
5. 配合 ZC702 官方使用手冊確認完整 FPGA pin mapping 和 bank I/O 電壓；用對應頂層的 XDC。
6. 完成靜態時序分析、HDMI 模擬及上板測試。

在沒有板子的階段，只能確認邏輯波形、座標和自訂的 HDMI/I²C testbench 行為，無法宣稱 HDMI 硬體顯示成功。

參考：
- AMD/Xilinx ZC702 Evaluation Board User Guide UG850
- Analog Devices ADV7511 Programming Guide
