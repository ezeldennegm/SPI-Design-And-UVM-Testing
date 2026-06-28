package SPI_driver_pkg;
import uvm_pkg::*;
import SPI_sequence_item_pkg::*;
`include"uvm_macros.svh"

class SPI_driver extends uvm_driver #(SPI_sequence_item);
`uvm_component_utils(SPI_driver)
SPI_sequence_item seq_item;
virtual SPI_interface SPIinterface;
 int SSn_cycle_count = 0;
   int period_cycles;
    int extra_idle;
function new(string name="SPI_driver",uvm_component parent=null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
seq_item=SPI_sequence_item::type_id::create("seq_item");
seq_item_port.get_next_item(seq_item);
SPIinterface.rst_n=seq_item.rst_n;
SPIinterface.tx_data=seq_item.tx_data;
SPIinterface.tx_valid=seq_item.tx_valid;
 if (seq_item.mosi_bits[10:8] == 3'b111)
        period_cycles = 23;
      else
        period_cycles = 13;
SPIinterface.SS_n = 0;
 SSn_cycle_count++;
for(int i=0;i<11;i=i+1) begin
@(negedge SPIinterface.clk);
SPIinterface.MOSI=seq_item.mosi_bits[10-i];
SPIinterface.mosi_bits=seq_item.mosi_bits;
 SSn_cycle_count++;
end
if (seq_item.mosi_bits[10:8] == 3'b111) begin
for(int j=0;j<8;j=j+1) begin
@(negedge SPIinterface.clk);
SSn_cycle_count++;
end
end
 extra_idle = period_cycles - SSn_cycle_count;
        if (extra_idle > 0) begin
          repeat (extra_idle) begin
            @(negedge SPIinterface.clk);
            SSn_cycle_count++;
          end
        end
        @(negedge SPIinterface.clk);
        SPIinterface.SS_n = 1;
        SSn_cycle_count = 0;
       repeat(2) @(negedge SPIinterface.clk);
        SPIinterface.SS_n = 0; 
seq_item_port.item_done();
`uvm_info("run phase in driver",seq_item.convert2string_stimulus(),UVM_HIGH);
end
endtask
endclass
endpackage