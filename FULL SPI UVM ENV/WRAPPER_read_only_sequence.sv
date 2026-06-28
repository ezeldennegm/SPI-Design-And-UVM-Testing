package WRAPPER_read_only_sequence_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_read_only_sequence extends uvm_sequence #(WRAPPER_sequence_item);
        `uvm_object_utils(WRAPPER_read_only_sequence)

        WRAPPER_sequence_item seq_item;
        
        function new(string name = "WRAPPER_read_only_sequence");
            super.new(name);
        endfunction //new()

        task body();
            seq_item = WRAPPER_sequence_item::type_id::create("seq_item");

            // Added: start with a read operation
            seq_item.op = 3'b110;

            repeat (1000) begin
                start_item(seq_item);
                // Added: explicit alternation constraint
                assert(seq_item.randomize() with {
                    if (!rst_n)
                        next_op == 3'b110;
                    else if (op == 3'b110)
                        next_op == 3'b111;
                    else if (op == 3'b111)
                        next_op == 3'b110;
                });
                finish_item(seq_item);

                // Added: update for next iteration
                seq_item.op = seq_item.next_op;
            end
        endtask

    endclass //WRAPPER_read_only_sequence extends uvm_sequence
endpackage