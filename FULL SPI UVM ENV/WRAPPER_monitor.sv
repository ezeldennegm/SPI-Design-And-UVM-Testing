package WRAPPER_monitor_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_monitor extends uvm_monitor;
        `uvm_component_utils(WRAPPER_monitor)
        
        virtual WRAPPER_interface WRAPPER_vif;
        WRAPPER_sequence_item seq_item;
        uvm_analysis_port#(WRAPPER_sequence_item) WRAPPER_mon_ap;

        function new(string name = "WRAPPER_monitor", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            WRAPPER_mon_ap = new("WRAPPER_mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                seq_item = WRAPPER_sequence_item :: type_id::create("seq_item");
                @(negedge WRAPPER_vif.clk);
                seq_item.MISO_DUT = WRAPPER_vif.MISO_DUT;
                seq_item.MISO_GM = WRAPPER_vif.MISO_GM;
                seq_item.MOSI_bits = WRAPPER_vif.MOSI_bits;
                seq_item.rst_n = WRAPPER_vif.rst_n;
                seq_item.SS_n = WRAPPER_vif.SS_n;
                seq_item.op = WRAPPER_vif.MOSI_bits[10:8];
                WRAPPER_mon_ap.write(seq_item);
                `uvm_info("run_phase",seq_item.convert2string,UVM_HIGH);
            end
        endtask
    endclass //WRAPPER_monitor extends uvm_monitor
endpackage