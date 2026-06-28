package WRAPPER_reset_sequence_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_reset_sequence extends uvm_sequence #(WRAPPER_sequence_item);
        `uvm_object_utils(WRAPPER_reset_sequence)
        
        WRAPPER_sequence_item seq_item;

        function new(string name = "WRAPPER_reset_sequence");
            super.new(name);
        endfunction //new()

        task body();
            seq_item = WRAPPER_sequence_item :: type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            finish_item(seq_item);
        endtask
    endclass //WRAPPER_reset_sequence extends uvm_sequence #(WRAPPER_sequence_item)
endpackage