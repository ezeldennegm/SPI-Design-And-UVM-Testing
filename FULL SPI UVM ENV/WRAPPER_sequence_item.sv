package WRAPPER_sequence_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class WRAPPER_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(WRAPPER_sequence_item)

        //  Group: Variables
        rand bit rst_n;
        bit SS_n;
        logic MISO_DUT, MISO_GM;
        bit MOSI;
        rand bit [10:0] MOSI_bits;
        bit [2:0] op;
        rand bit [2:0] next_op;

        //  Group: Constraints
        constraint rst_n_con{
            rst_n dist{1:=99, 0:=1};
        }

        //constraint cmd_bits_con {
         //   MOSI_bits[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
        //}

        constraint next_op_con {
            if (!rst_n)
                next_op == 3'b000;

            else if (op == 3'b000)
                next_op inside {3'b000, 3'b001};

            else if (op == 3'b001)
                next_op dist {3'b110 := 60, 3'b000 := 40};

            else if (op == 3'b110)
                next_op == 3'b111;

            else if (op == 3'b111)
                next_op dist {3'b000 := 60, 3'b110 := 40};
        }

        constraint op_con {
            MOSI_bits[10:8] == op;
        }
        // New function
        function new(string name = "WRAPPER_sequence_item");
            super.new(name);
        endfunction //new()

        // UVM utility for printing item info
        function string convert2string();
            return $sformatf("rst_n = %0b SS_n = %0b op = %0b next_op = %0b, MOSI_bits = %0b, MOSI = %0b, MISO_GM = %0b, MISO_DUT = %0b",
                            rst_n, SS_n, op, next_op, MOSI_bits, MOSI, MISO_GM, MISO_DUT);
        endfunction

        // Optional: simplified print for stimuli debug
        function string convert2string_stimulus();
            return $sformatf("MOSI_bits=%b SS_n=%b rst_n=%b", MOSI_bits, SS_n, rst_n);
        endfunction
    endclass //WRAPPER_sequence_item extends uvm_sequence_item
endpackage