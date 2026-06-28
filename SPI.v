module SPI (MOSI,MISO,SS_n,clk,rst_n,tx_valid,tx_data,rx_data,rx_valid);
input MOSI,clk,rst_n,SS_n,tx_valid;
input [7:0] tx_data;
output [9:0] rx_data;
output rx_valid,MISO;
reg cs,ns,read_add_done;
parameter IDLE=3'b000 ;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b100;
reg [3:0] bit_cnt;
reg [9:0] rx_shift;
reg [7:0] tx_buffer;
reg [1:0] cmd_type;
always@(*)begin //Next state logic
if(~rst_n)
ns=IDLE;
else begin
case(cs)
IDLE:begin
if(~SS_n)
ns=CHK_CMD;
else
ns=IDLE;
end
WRITE:begin
if(~SS_n&& bit_cnt < 11)
ns=WRITE;
else
ns=IDLE;
end
CHK_CMD:begin
if(~SS_n&&~MOSI)
ns=WRITE;
else if (~SS_n&&MOSI&&~read_add_done) begin
ns=READ_ADD;
end
else if(~SS_n&&MOSI&&read_add_done) begin
ns=READ_DATA;
end
else 
ns=IDLE;
end
READ_ADD:begin
if(~SS_n&& bit_cnt < 11)
ns=READ_ADD;
else
ns=IDLE;
end
READ_DATA:begin
if(~SS_n&& bit_cnt < 11)
ns=READ_DATA;
else
ns=IDLE;
end
default:ns=IDLE;
endcase
end
end
always@(posedge clk or negedge rst_n) begin
if(~rst_n) begin
cs<=IDLE;
read_add_done<=0;
bit_cnt<=0;
end
else begin
cs<=ns;
if (cs == READ_ADD && bit_cnt == 10)
read_add_done <= 1;
  if (SS_n)
bit_cnt <= 0;
else if (cs != IDLE)
bit_cnt <= bit_cnt + 1;
end
end
always@(posedge clk or negedge rst_n)begin
if(~rst_n)
rx_shift<=0;
else if((cs==WRITE||cs==READ_ADD)&&~SS_n)
rx_shift={rx_shift[8:0],MOSI};
end
assign rx_data=rx_shift;
assign rx_valid = (bit_cnt == 10) && (cs == WRITE || cs == READ_ADD);
integer i;
always@(posedge clk or negedge rst_n)begin
if(~rst_n)
 tx_buffer<=0;
else begin
   if (tx_valid && (cs == IDLE || cs == CHK_CMD))
   tx_buffer<=tx_data;
else if (cs == READ_DATA && ~SS_n && bit_cnt >= 3) begin
 tx_buffer <= {tx_buffer[6:0], 1'b0};  // Shift left
 end
end
end
assign MISO = (cs == READ_DATA && ~SS_n && bit_cnt >= 3) ? tx_buffer[7] : 1'bz;
always@(posedge clk or negedge rst_n) begin
if(~rst_n)
cmd_type<=0;
else if(bit_cnt==1&&cs==CHK_CMD)
cmd_type={cmd_type[0], MOSI};
end
endmodule