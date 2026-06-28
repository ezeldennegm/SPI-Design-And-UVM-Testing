import uvm_pkg::*;
import WRAPPER_test_pkg::*;
`include "uvm_macros.svh"

module WRAPPER_top();
    bit clk;
    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    WRAPPER_interface WRAPPER_top_if(clk);
    SPI_interface     spiif(clk);
    ram_interface     ram_if(clk);

    // ===================================================
    // SPI Interface ↔ WRAPPER Interface
    // ===================================================
    // For signals that exist inside WRAPPER_interface
    assign spiif.MOSI     = WRAPPER_top_if.MOSI;
    assign spiif.MISO     = WRAPPER_top_if.MISO_DUT;
    assign spiif.MISO_ref = WRAPPER_top_if.MISO_GM;
    assign spiif.SS_n     = WRAPPER_top_if.SS_n;
    assign spiif.rst_n    = WRAPPER_top_if.rst_n;

    // ===================================================
    // SPI Interface Direct Connections (not in wrapper_if)
    // ===================================================
    assign spiif.rx_data      = DUT.rx_data_din;
    assign spiif.rx_valid     = DUT.rx_valid;
    assign spiif.tx_data      = DUT.tx_data_dout;
    assign spiif.tx_valid     = DUT.tx_valid;

    assign spiif.rx_data_ref  = GM.ram_data_in;
    assign spiif.rx_valid_ref = GM.ram_rx_valid;

    assign spiif.mosi_bits = WRAPPER_top_if.MOSI_bits;


    // ===================================================
    // RAM Interface ↔ WRAPPER Interface
    // ===================================================
    // Signals that exist in WRAPPER_interface
    assign ram_if.rst_n    = WRAPPER_top_if.rst_n;

    // ===================================================
    // RAM Interface Direct Connections (not in wrapper_if)
    // ===================================================
    assign ram_if.rx_valid = DUT.rx_valid;
    assign ram_if.tx_valid = DUT.tx_valid;
    assign ram_if.din      = DUT.rx_data_din;
    assign ram_if.dout     = DUT.tx_data_dout;

    assign ram_if.dout_GM = GM.ram_data_out;
    assign ram_if.tx_valid_GM = GM.ram_tx_valid;

    WRAPPER DUT (
        .MOSI  (WRAPPER_top_if.MOSI),
        .MISO  (WRAPPER_top_if.MISO_DUT),
        .SS_n  (WRAPPER_top_if.SS_n),
        .clk   (WRAPPER_top_if.clk),
        .rst_n (WRAPPER_top_if.rst_n)
    );

    GM_WRAPPER GM (
        .MOSI  (WRAPPER_top_if.MOSI),
        .MISO  (WRAPPER_top_if.MISO_GM),
        .SS_n  (WRAPPER_top_if.SS_n),
        .clk   (WRAPPER_top_if.clk),
        .rst_n (WRAPPER_top_if.rst_n)
    );

    bind DUT WRAPPER_assertions WRAPPER_asserts (
        .clk      (clk),
        .rst_n    (WRAPPER_top_if.rst_n),
        .MISO     (WRAPPER_top_if.MISO_DUT),
        .rx_valid (DUT.rx_valid),
        .rx_data  (DUT.rx_data_din),
        .cs  (DUT.SLAVE_instance.cs)
    );

    bind DUT.RAM_instance ram_SVA ram_asserts (
        .clk       (ram_if.clk),
        .rst_n     (ram_if.rst_n),
        .din       (ram_if.din),
        .rx_valid  (ram_if.rx_valid),
        .dout      (ram_if.dout),
        .tx_valid  (ram_if.tx_valid)
    );

    bind DUT.SLAVE_instance spi_slave_assertions spi_slave_asserts (
        .clk      (spiif.clk),
        .rst_n    (spiif.rst_n),
        .SS_n     (spiif.SS_n),
        .MISO     (spiif.MISO),
        .rx_valid (spiif.rx_valid),
        .rx_data  (spiif.rx_data),
        .cs       (DUT.SLAVE_instance.cs),
        .MOSI     (MOSI)
    );

    initial begin
        uvm_config_db #(virtual WRAPPER_interface) ::set(null,"uvm_test_top","WRAPPER_V_IF",WRAPPER_top_if);
        uvm_config_db#(virtual SPI_interface)::set(null, "uvm_test_top", "SPI_VIF", spiif);
        uvm_config_db#(virtual ram_interface)::set(null, "uvm_test_top", "RAM_VIF", ram_if);
        run_test("WRAPPER_test");
    end
endmodule