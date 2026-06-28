package SPI_sequence_item_pkg ;
import uvm_pkg::*;
`include "uvm_macros.svh"
class SPI_sequence_item extends uvm_sequence_item;
`uvm_object_utils(SPI_sequence_item)
rand logic MOSI, rst_n, SS_n, tx_valid;
rand logic [7:0] tx_data;
logic [9:0] rx_data;
logic rx_valid;
logic  MISO;
logic [9:0] rx_data_ref;
logic rx_valid_ref;
logic MISO_ref;
int SS_n_count;
 rand bit [10:0] mosi_bits; 
function new(string name = "SPI_sequence_item");
    super.new(name);
endfunction
function string convert2string();
return $sformatf(" %S MOSI=%0b, rst_n=%0b, SS_n=%0b, tx_valid=%0b, tx_data=%0h, rx_data=%0h, rx_valid=%0b, MISO=%0b", 
                    super.convert2string(), MOSI, rst_n, SS_n, tx_valid, tx_data, rx_data, rx_valid, MISO);

endfunction
function string convert2string_stimulus();
return $sformatf(" %S MOSI=%0b, rst_n=%0b, SS_n=%0b, tx_valid=%0b, tx_data=%0h ", 
                    super.convert2string(), MOSI, rst_n, SS_n, tx_valid, tx_data);
endfunction

constraint c1 {
rst_n dist{1:=95,0:=5};
 mosi_bits[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
}
function void post_randomize();
   if (mosi_bits[10:8] == 3'b111)
      tx_valid = 1;
   else
      tx_valid = 0;
endfunction
endclass
endpackage