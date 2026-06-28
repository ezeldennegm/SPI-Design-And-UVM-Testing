package SPI_main_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_sequence_item_pkg::*;
class SPI_main_sequence extends uvm_sequence #(SPI_sequence_item);
`uvm_object_utils(SPI_main_sequence)
SPI_sequence_item seq_item;
function new(string name="SPI_main_sequence");
super.new(name);
endfunction
task body();
seq_item=SPI_sequence_item::type_id::create("seq_item");
repeat(2000) begin
start_item(seq_item);
assert(seq_item.randomize());
finish_item(seq_item);
end
start_item(seq_item);
 seq_item.randomize() with { mosi_bits[10:8] == 3'b000; };
finish_item(seq_item);
start_item(seq_item);
 seq_item.randomize() with { mosi_bits[10:8] == 3'b001; };
finish_item(seq_item);
start_item(seq_item);
 seq_item.randomize() with { mosi_bits[10:8] == 3'b110; };
finish_item(seq_item);
start_item(seq_item);
 seq_item.randomize() with { mosi_bits[10:8] == 3'b111; };
finish_item(seq_item);
endtask
endclass
endpackage