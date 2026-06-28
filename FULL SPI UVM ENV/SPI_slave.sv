module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (received_address) 
                        ns = READ_DATA; 
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
        counter<=0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
        endcase
    end
end
`ifdef SIM
 property p4;
           @(posedge clk) disable iff (!rst_n)
            (cs == IDLE && !SS_n) |=> (cs == CHK_CMD)
 endproperty
 property p5;
               @(posedge clk) disable iff (!rst_n)
            (cs == CHK_CMD && !SS_n) |=> (cs == WRITE || cs == READ_ADD || cs == READ_DATA)
 endproperty

 property p6;
             @(posedge clk) disable iff (!rst_n)
            (cs == WRITE && SS_n) |=> (cs == IDLE)
 endproperty
     property p7;
             @(posedge clk) disable iff (!rst_n)
            (cs == READ_ADD && SS_n) |=> (cs == IDLE)
 endproperty
     property p8;
             @(posedge clk) disable iff (!rst_n)
            (cs == READ_DATA && SS_n) |=> (cs == IDLE)
 endproperty
ap4:assert property(p4);
cp4:cover property(p4);
ap5:assert property(p5);
cp5:cover property(p5);
ap6:assert property(p6);
cp6:cover property(p6);
ap7:assert property(p7);
cp7:cover property(p7);
ap8:assert property(p8);
cp8:cover property(p8);
`endif
endmodule
// 1) make the next state READ_DATA when the received_address is high.
// 2) Reset the counter when rst_n is asserted.