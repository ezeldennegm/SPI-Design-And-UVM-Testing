import uvm_pkg::*;
`include"uvm_macros.svh"
import SPI_test_pkg::*;
module top ();
logic clk;
initial begin
clk=0;
forever #1 clk=~clk;
end
SPI_interface SPIinterface(clk);
SLAVE DUT1(.MOSI(SPIinterface.MOSI),.MISO(SPIinterface.MISO),.SS_n(SPIinterface.SS_n),.clk(SPIinterface.clk),.rst_n(SPIinterface.rst_n),.rx_data(SPIinterface.rx_data),.rx_valid(SPIinterface.rx_valid),.tx_data(SPIinterface.tx_data),.tx_valid(SPIinterface.tx_valid));
SPI_slave GOLDEN1 ( .clk(SPIinterface.clk),.rst_n(SPIinterface.rst_n),.SS_n(SPIinterface.SS_n),.MOSI(SPIinterface.MOSI),.tx_valid(SPIinterface.tx_valid),.tx_data(SPIinterface.tx_data),.MISO(SPIinterface.MISO_ref),.rx_valid(SPIinterface.rx_valid_ref),.rx_data(SPIinterface.rx_data_ref));
 bind SLAVE spi_slave_assertions alu_assertion_inst(.clk      (clk),
        .rst_n    (SPIinterface.rst_n),
        .MISO     (SPIinterface.MISO),
        .rx_valid (SPIinterface.rx_valid),
        .rx_data  (SPIinterface.rx_data),
        .SS_n (SPIinterface.SS_n),
        .cs  (DUT1.cs));

initial begin
uvm_config_db #(virtual SPI_interface)::set(null,"uvm_test_top","VIF",SPIinterface);
run_test("SPI_test");
end
endmodule
