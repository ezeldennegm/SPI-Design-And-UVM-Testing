import shared_pkg::*;

interface ram_interface(clk);
    input bit clk;

    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;

    
    logic [9:0] din;
    
    logic rst_n;
    
    logic rx_valid;

    
    logic [7:0] dout;
    
    logic tx_valid;

    logic [7:0] dout_GM;

    logic tx_valid_GM;
endinterface
