interface SPI_interface (clk);
input logic clk;
logic MOSI, rst_n, SS_n, tx_valid;
logic [7:0] tx_data;
logic [9:0] rx_data;
logic rx_valid, MISO;
logic [9:0] rx_data_ref;
logic rx_valid_ref, MISO_ref;
bit [10:0] mosi_bits; 
endinterface 