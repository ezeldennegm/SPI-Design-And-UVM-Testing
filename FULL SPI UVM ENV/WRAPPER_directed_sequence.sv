package WRAPPER_directed_sequence_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_directed_sequence extends uvm_sequence #(WRAPPER_sequence_item);
        `uvm_object_utils(WRAPPER_directed_sequence)

        WRAPPER_sequence_item seq_item;
        
        function new(string name = "WRAPPER_directed_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = WRAPPER_sequence_item::type_id::create("seq_item");

            // ------------------------------------------------------------
            // SPI bit = 0 for command phase
            // [9:8] = 00 -> Write Address
            // ------------------------------------------------------------
            seq_item.rst_n = 1;
            `uvm_info("WRAPPER_SEQ", "WRITE ADDR started", UVM_LOW)
            start_item(seq_item);
            seq_item.MOSI_bits = 11'b0_00_00000000; // SPI=0, cmd=00, addr=0x02
            finish_item(seq_item);
            `uvm_info("WRAPPER_SEQ", "WRITE ADDR completed", UVM_LOW)

            // ------------------------------------------------------------
            // SPI bit = 0
            // [9:8] = 01 -> Write Data
            // ------------------------------------------------------------
            `uvm_info("WRAPPER_SEQ", "WRITE DATA started", UVM_LOW)
            start_item(seq_item);
            seq_item.MOSI_bits = 11'b0_01_11110110; // SPI=0, cmd=01, data=0xAA
            finish_item(seq_item);
            `uvm_info("WRAPPER_SEQ", "WRITE DATA completed", UVM_LOW)

            // ------------------------------------------------------------
            // SPI bit = 0
            // [9:8] = 10 -> Read Address
            // ------------------------------------------------------------
            `uvm_info("WRAPPER_SEQ", "READ ADDR started", UVM_LOW)
            start_item(seq_item);
            seq_item.MOSI_bits = 11'b1_10_00000000; // SPI=1, cmd=10, addr=0x02
            finish_item(seq_item);
            `uvm_info("WRAPPER_SEQ", "READ ADDR completed", UVM_LOW)

            // ------------------------------------------------------------
            // SPI bit = 0
            // [9:8] = 11 -> Read Data
            // ------------------------------------------------------------
            `uvm_info("WRAPPER_SEQ", "READ DATA started", UVM_LOW)
            start_item(seq_item);
            seq_item.MOSI_bits = 11'b1_11_00000000; // SPI=1, cmd=11, dummy payload
            finish_item(seq_item);
            `uvm_info("WRAPPER_SEQ", "READ DATA completed", UVM_LOW)
        endtask
    endclass
endpackage