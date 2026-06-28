module GM_WRAPPER (
    input  clk,
    input  rst_n,
    input  MOSI,
    input  SS_n,
    output MISO
);

    wire [9:0] ram_data_in;
    wire ram_rx_valid;
    wire [7:0] ram_data_out;
    wire ram_tx_valid;

    // Instantiate RAM
    GM_RAM DUT_RAM (
        .din(ram_data_in),
        .rx_valid(ram_rx_valid),
        .dout(ram_data_out),
        .tx_valid(ram_tx_valid),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Instantiate SPI Slave
    GM_SPI_SLAVE DUT_SPI (
        .clk(clk),
        .rst_n(rst_n),
        .SS_n(SS_n),
        .MOSI(MOSI),
        .MISO(MISO),
        .tx_valid(ram_tx_valid),
        .tx_data(ram_data_out),
        .rx_valid(ram_rx_valid),
        .rx_data(ram_data_in)
    );

endmodule
