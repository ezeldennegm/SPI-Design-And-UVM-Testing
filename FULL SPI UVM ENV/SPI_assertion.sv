module spi_slave_assertions (clk, rst_n, SS_n, MISO, rx_valid,rx_data, cs, MOSI );
    input logic clk;
    input logic rst_n;
    input logic SS_n;
    input logic MISO;
    input logic rx_valid;
    input logic [9:0] rx_data;
    input logic [2:0] cs ;
    input logic MOSI;

localparam IDLE      = 3'b000;
    localparam WRITE     = 3'b001;
    localparam CHK_CMD   = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam READ_DATA = 3'b100;

    sequence write_add_seq;
        (SS_n==1) ##1 (SS_n==0) ##1 (MOSI == 0)[*3];
        endsequence
    sequence write_data_seq;
        (SS_n==1) ##1 (SS_n==0) ##1 (MOSI == 0)[*2] ##1(MOSI==1);
    endsequence
    sequence read_add_seq;
        (SS_n==1) ##1 (SS_n==0) ##1 (MOSI == 1)[*2] ##1(MOSI==0);
    endsequence

    sequence read_data_seq;
        (SS_n==1) ##1 (SS_n==0) ##1 (MOSI == 1)[*3];
    endsequence

 property p1 ;
        @(posedge clk) 
            !rst_n |=> (MISO == 1'b0 && rx_valid == 1'b0 && rx_data == '0)
 endproperty

 property p2 ;
             @(posedge clk) disable iff (!rst_n)
        ($fell(SS_n) ##1 !SS_n [*1:$]) |-> s_eventually (rx_valid && !SS_n);

 endproperty

 //property chck_rx_valid;
    //@(posedge clk) disable iff(~rst_n)
        //(write_add_seq or write_data_seq or read_add_seq or read_data_seq) |=> ##9 ($rose(rx_valid) && $rose(SS_n)[->1]);
//endproperty

//ASSERT_CHCK_RX_VALID: assert property (chck_rx_valid)
    //else $error("rx_valid or SS_n did not rise correctly 9 cycles after operation start!");

//COVER_CHCK_RX_VALID: cover property (chck_rx_valid);

 property p3 ;
          @(posedge clk) disable iff (!rst_n)
            $rose(rx_valid) |-> s_eventually $rose(SS_n)
 endproperty
ap1:assert property(p1);
cp1:cover property(p1);
ap2:assert property(p2);
cp2:cover property(p2);
ap3:assert property(p3);
cp3:cover property(p3);
endmodule