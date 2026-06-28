module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);

input      [9:0] din;
input            clk, rst_n, rx_valid;

output reg [7:0] dout;
output reg       tx_valid;

reg [7:0] MEM [255:0];
reg [7:0] Rd_Addr, Wr_Addr;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else begin                                         
        
        if (rx_valid) begin
            // Default: tx_valid is low unless READ_DATA command
            case (din[9:8])
                2'b00 : begin 
                    Wr_Addr <= din[7:0];
                    tx_valid <= 0;
                end           
                2'b01 : begin 
                    MEM[Wr_Addr] <= din[7:0];
                    tx_valid <= 0;
                end    
                2'b10 : begin 
                    Rd_Addr <= din[7:0];
                    tx_valid <= 0;
                end
                2'b11 : begin                          // Read Data
                    dout <= MEM[Rd_Addr];
                    tx_valid <= 1'b1;
                end
            
            endcase
        end
    end
end

endmodule