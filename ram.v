module ram (din,rx_valid,dout,tx_valid,clk,rst_n);
    input rx_valid,clk,rst_n;
    input[9:0] din;

    output reg tx_valid;
    output reg [7:0] dout;

    parameter MEM_DEPTH=256;
    parameter DATA_WIDTH=8;
    parameter ADDR_SIZE =8;

    reg [DATA_WIDTH-1:0]mem[MEM_DEPTH-1:0];
    reg [ADDR_SIZE-1:0] write_addr,read_addr;
    
    always@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            dout<=8'b00000000;
            write_addr<=8'b0;
            read_addr<=8'b0;
            tx_valid<=0; //unvalid
        end
        else begin
            if (rx_valid) begin
                if(din[9:8]==2'b00) begin
                    write_addr<=din[7:0];
                    tx_valid<=0; //unvalid
                end
                else if(din[9:8]==2'b01) begin
                    tx_valid<=0; //unvalid
                end
                else if(din[9:8]==2'b10) begin
                    read_addr<=din[7:0];
                    tx_valid<=0; //unvalid
                end
                else if(din[9:8]==2'b11) begin
                    dout<=mem[read_addr];
                    tx_valid<=1;//valid now
                end
            end
        end
    end

    always @(posedge clk) begin
        if (rx_valid && din[9:8] == 2'b01) begin
            mem[write_addr] <= din[7:0];  // write immediately
        end
    end

endmodule