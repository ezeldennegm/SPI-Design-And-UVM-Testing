package WRAPPER_driver_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_driver extends uvm_driver #(WRAPPER_sequence_item);
        `uvm_component_utils(WRAPPER_driver)

        virtual WRAPPER_interface WRAPPER_vif;
        WRAPPER_sequence_item stim_seq_item;
        int SSn_cycle_count = 0;
        int period_cycles;
        int extra_idle;

        function new(string name ="WRAPPER_driver",uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                // Get new transaction
                seq_item_port.get_next_item(stim_seq_item);

                // Connect interface signals
                WRAPPER_vif.rst_n = stim_seq_item.rst_n;
                WRAPPER_vif.MOSI_bits = stim_seq_item.MOSI_bits;

                // Determine SS_n period (13 or 23 cycles)
                period_cycles = (stim_seq_item.MOSI_bits[10:8] == 3'b111) ? 23 : 13;

                // Start of SPI frame
                WRAPPER_vif.SS_n = 0;
                SSn_cycle_count = 0;
                //@(negedge WRAPPER_vif.clk);
                // ---- Drive 11 MOSI bits (MSB first) ----
                for (int i = 0; i < 11; i++) begin
                    @(negedge WRAPPER_vif.clk);
                    WRAPPER_vif.MOSI = stim_seq_item.MOSI_bits[10 - i];
                    SSn_cycle_count++;
                end

                // ---- For Read Data, wait extra 8 cycles ----
                if (stim_seq_item.MOSI_bits[10:8] == 3'b111) begin
                    for (int j = 0; j < 8; j++) begin
                        @(negedge WRAPPER_vif.clk);
                        SSn_cycle_count++;
                    end
                end

                // ---- Fill remaining cycles to complete the full period ----
                extra_idle = period_cycles - SSn_cycle_count;
                if (extra_idle > 0) begin
                    repeat (extra_idle) begin
                        @(negedge WRAPPER_vif.clk);
                        SSn_cycle_count++;
                    end
                end

                // ---- SS_n high for one cycle ----
                @(negedge WRAPPER_vif.clk);
                WRAPPER_vif.SS_n = 1;
                @(negedge WRAPPER_vif.clk);
                WRAPPER_vif.SS_n = 0;

                // Prepare for next operation
                stim_seq_item.op = stim_seq_item.next_op;

                // Done with item
                seq_item_port.item_done();
                `uvm_info("WRAPPER_DRIVER", stim_seq_item.convert2string(), UVM_HIGH);
            end
        endtask
    endclass //WRAPPER_driver extends uvm_driver #(WRAPPER_sequence_item)
endpackage