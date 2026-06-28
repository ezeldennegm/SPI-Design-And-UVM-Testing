//======================================================
// SPI Wrapper Assertions
//======================================================
module WRAPPER_assertions (
    input logic clk,
    input logic rst_n,
    input logic MISO,
    input logic rx_valid,
    input logic [9:0] rx_data,
    input logic[2:0] cs // 1 when READ operation is active
);

    //======================================================
    // 1. Ensure outputs inactive during reset
    //======================================================
    property outputs_inactive_during_reset;
        @(posedge clk)
        !rst_n |->##1 (MISO == 1'b0 && rx_valid == 1'b0 && rx_data == '0);
    endproperty

    ASSERT_RESET_INACTIVE: assert property (outputs_inactive_during_reset)
        else $error("Outputs active during reset!");

    COVER_RESET_INACTIVE: cover property (outputs_inactive_during_reset);
    //======================================================
    // 2. Ensure MISO remains stable when not in READ operation
    //======================================================
    property miso_stable_when_not_read;
        @(posedge clk)
        disable iff (!rst_n)
        (!(cs == 3'b100)) |->##1 $stable(MISO);
    endproperty

    ASSERT_MISO_STABLE: assert property (miso_stable_when_not_read)
        else $error("MISO changed outside READ operation!");
    
    COVER_MISO_STABLE: cover property (miso_stable_when_not_read);

endmodule