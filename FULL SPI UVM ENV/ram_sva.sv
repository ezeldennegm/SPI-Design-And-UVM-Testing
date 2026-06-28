module ram_SVA #(parameter MEM_DEPTH = 256, ADDR_SIZE = 8)
    (
        input logic clk, 
        input logic rst_n, 
        input logic [9:0] din,
        input logic rx_valid,
        input logic [7:0] dout,
        input logic tx_valid
    );

    //assertion_1: Reset assertion 
    property Reset_Outputs;
        @(posedge clk) (!rst_n |-> (tx_valid == 0 && dout == 0));
    endproperty

    Reset_Outputs_label: assert property(Reset_Outputs) 
        else $error("Reset failed: tx_valid = %0b, dout = 0x%0h", tx_valid, dout);

    cover property(Reset_Outputs);

    //assertion_2
    property TX_Valid_Deasserted_During_Input;
        @(posedge clk) disable iff(!rst_n) 
        (rx_valid && (din[9:8] inside {2'b00, 2'b01, 2'b10})) |=> (tx_valid == 0);
    endproperty

    TX_Valid_Deasserted_label: assert property(TX_Valid_Deasserted_During_Input) 
        else $error("tx_valid should be 0 during write_add/write_data/read_add, din = %b, tx_valid = %b", 
                    din, tx_valid);

    cover property(TX_Valid_Deasserted_During_Input);

    //assertion_3_1
    property TX_Valid_Rise_After_Read_Data;
        @(posedge clk) disable iff(!rst_n) 
        (rx_valid && din[9:8] == 2'b11) |=> (tx_valid == 1);
    endproperty

    TX_Valid_Rise_label: assert property(TX_Valid_Rise_After_Read_Data) 
        else $error("tx_valid should rise after read_data, din = %b, tx_valid = %b", din, tx_valid);

    cover property(TX_Valid_Rise_After_Read_Data);

    //assertion_3_2
    property TX_Valid_Fall_After_Rise;
        @(posedge clk) disable iff(!rst_n) 
        ($rose(tx_valid)) |=> ##[0:$] (!tx_valid);
    endproperty

    TX_Valid_Fall_label: assert property(TX_Valid_Fall_After_Rise) 
        else $error("tx_valid should eventually fall after rising");

    cover property(TX_Valid_Fall_After_Rise);

    //assertion_4: Write sequence assertion 
    property Write_Address_Followed_By_Write_Data;
        @(posedge clk) disable iff(!rst_n) 
        (rx_valid && din[9:8] == 2'b00) |-> ##[1:$] (rx_valid && din[9:8] == 2'b01);
    endproperty

    Write_Addr_Wr_Data_label: assert property(Write_Address_Followed_By_Write_Data) 
        else $error("Write Address must be eventually followed by Write Data");

    cover property(Write_Address_Followed_By_Write_Data);

    //assertion_5: Read sequence assertion 
    property Read_Address_Followed_By_Read_Data;
        @(posedge clk) disable iff(!rst_n) 
        (rx_valid && din[9:8] == 2'b10) |-> ##[1:$] (rx_valid && din[9:8] == 2'b11);
    endproperty

    Read_Addr_Rd_Data_label: assert property(Read_Address_Followed_By_Read_Data) 
        else $error("Read Address must be eventually followed by Read Data");

    cover property(Read_Address_Followed_By_Read_Data);

endmodule