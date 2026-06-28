package WRAPPER_write_only_sequence_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_write_only_sequence extends uvm_sequence #(WRAPPER_sequence_item);
        `uvm_object_utils(WRAPPER_write_only_sequence)

        WRAPPER_sequence_item seq_item;
        
        function new(string name = "WRAPPER_write_only_sequence");
            super.new(name);
        endfunction //new()

        task body();
            seq_item = WRAPPER_sequence_item::type_id::create("seq_item");

            // Added: start with a known op (e.g., write address)
            seq_item.op = 3'b000;

            repeat (1000) begin
                start_item(seq_item);
                // Added: explicit with-constraint controlling transitions
                assert(seq_item.randomize() with {
                    if (op == 3'b000)
                        next_op inside {3'b000, 3'b001}; // stay write-related
                    else
                        next_op == 3'b000;
                });
                finish_item(seq_item);

                // Added: manually update op for next iteration
                seq_item.op = seq_item.next_op;
            end
        endtask

    endclass //WRAPPER_write_only_sequence extends uvm_sequence
endpackage