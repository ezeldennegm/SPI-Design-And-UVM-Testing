interface WRAPPER_interface(clk);
    input clk;
    logic rst_n, MOSI, SS_n;
    logic MISO_DUT, MISO_GM;
    logic [10:0] MOSI_bits;
endinterface