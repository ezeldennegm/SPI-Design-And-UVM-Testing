package SPI_monitor_pkg;
import uvm_pkg::*;
import SPI_sequence_item_pkg::*;
`include"uvm_macros.svh"
class SPI_monitor extends uvm_monitor;
`uvm_component_utils(SPI_monitor)
virtual SPI_interface SPIinterface;
SPI_sequence_item seq_item;
uvm_analysis_port #(SPI_sequence_item) mon_ap;
bit prev_SS_n = 1;
function new(string name="SPI_monitor",uvm_component parent=null);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase); 
super.build_phase(phase);
mon_ap=new("mon_ap",this);
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
    forever begin
      seq_item = SPI_sequence_item::type_id::create("seq_item");
      @(negedge SPIinterface.clk);
      seq_item.MOSI = SPIinterface.MOSI;
      seq_item.MISO_ref = SPIinterface.MISO_ref;
      seq_item.rx_data       = SPIinterface.rx_data;
      seq_item.rx_data_ref   = SPIinterface.rx_data_ref;
      seq_item.MISO   = SPIinterface.MISO;
      seq_item.SS_n  = SPIinterface.SS_n;
      seq_item.rst_n   = SPIinterface.rst_n;
      seq_item.rx_valid_ref   = SPIinterface.rx_valid_ref;
      seq_item.tx_data  = SPIinterface.tx_data;
      seq_item.tx_valid  = SPIinterface.tx_valid;
      seq_item.rx_valid  = SPIinterface.rx_valid;
      seq_item.mosi_bits=SPIinterface.mosi_bits;
      mon_ap.write(seq_item);
      `uvm_info("SPI_MONITOR", seq_item.convert2string(), UVM_HIGH);
    end

endtask
endclass
endpackage 