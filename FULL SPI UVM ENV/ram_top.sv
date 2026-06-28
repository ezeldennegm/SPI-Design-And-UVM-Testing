import uvm_pkg::*;
`include "uvm_macros.svh"

import ram_test_pkg::*;

module ram_top();
    bit clk;

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    ram_interface ram_if(clk);

    RAM DUT (
        .clk(clk), 
        .din(ram_if.din), 
        .rst_n(ram_if.rst_n), 
        .rx_valid(ram_if.rx_valid), 
        .dout(ram_if.dout), 
        .tx_valid(ram_if.tx_valid)
    );
    
    bind RAM ram_SVA RAM_DUT_SVA(
        .clk(clk), 
        .rst_n(DUT.rst_n), 
        .din(DUT.din), 
        .rx_valid(DUT.rx_valid), 
        .dout(DUT.dout),
        .tx_valid(DUT.tx_valid)
    );
                                   
    initial begin
        uvm_config_db #(virtual ram_interface)::set(null, "uvm_test_top", "RAM_VIF", ram_if);
        
        run_test("ram_test");
    end
endmodule