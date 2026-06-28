package SPI_coverage1_pkg;
import uvm_pkg::*;
`include"uvm_macros.svh"
import SPI_sequence_item_pkg::*;
class SPI_coverage1 extends uvm_component;
`uvm_component_utils(SPI_coverage1);
uvm_analysis_export #(SPI_sequence_item) cov_export;
uvm_tlm_analysis_fifo #(SPI_sequence_item) cov_fifo;
SPI_sequence_item seq_item;
covergroup g1;
rx_data_cp: coverpoint seq_item.rx_data[9:8] {
    bins all_values[] = {2'b00, 2'b01, 2'b10, 2'b11};
      bins transitions[] = (2'b00 => 2'b01),
                           (2'b10 => 2'b11),
                           (2'b11 => 2'b00);
} 
ss_n_cp: coverpoint seq_item.SS_n{
      bins values1[]= {0,1};
      bins normal_txn  = (1 => 0 [*13] => 1);  
      bins read_txn    = (1 => 0 [*23] => 1);
}
mosi_cp: coverpoint seq_item.mosi_bits[10:8]{
      bins values2[] = {3'b000,3'b001,3'b110,3'b111};
  bins write_sequence = (3'b000 => 3'b001); 
  bins read_sequence  = (3'b110 => 3'b111); 
}
 cross1: cross  ss_n_cp,mosi_cp{
    ignore_bins ignored_bins = binsof(ss_n_cp) intersect {1'b1};
    bins cross_bins=binsof(ss_n_cp.values1)&&binsof(mosi_cp.values2);
}

endgroup
function new (string name=" SPI_coverage1",uvm_component parent =null);
super.new(name,parent);
g1=new();
endfunction
function void build_phase (uvm_phase phase);
super.build_phase(phase);
cov_export=new("cov_export",this);
cov_fifo=new("cov_fifo",this);
endfunction
function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
cov_fifo.get(seq_item);
g1.sample();
end
endtask
endclass
endpackage