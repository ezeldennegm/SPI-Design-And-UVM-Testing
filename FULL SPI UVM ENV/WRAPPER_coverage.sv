package WRAPPER_coverage_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_coverage extends uvm_component;
        `uvm_component_utils(WRAPPER_coverage)

        uvm_analysis_export #(WRAPPER_sequence_item) WRAPPER_cov_export;
        uvm_tlm_analysis_fifo #(WRAPPER_sequence_item) WRAPPER_cov_fifo;
        WRAPPER_sequence_item cov_seq_item;

        // CoverGroups


        function new(string name = "WRAPPER_coverage", uvm_component parent = null);
            super.new(name,parent);
            // create CoverGroups here
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            WRAPPER_cov_export = new("WRAPPER_cov_export",this);
            WRAPPER_cov_fifo = new("WRAPPER_cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            WRAPPER_cov_export.connect(WRAPPER_cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                WRAPPER_cov_fifo.get(cov_seq_item);
                // call CoverGroup sample
            end
        endtask
    endclass //WRAPPER_coverage extends uvm_component
endpackage