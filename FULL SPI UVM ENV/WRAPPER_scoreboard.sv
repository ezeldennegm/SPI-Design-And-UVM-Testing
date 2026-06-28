package WRAPPER_scoreboard_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(WRAPPER_scoreboard)

        uvm_analysis_export #(WRAPPER_sequence_item) WRAPPER_sb_export;
        uvm_tlm_analysis_fifo #(WRAPPER_sequence_item) WRAPPER_sb_fifo;
        WRAPPER_sequence_item seq_item;
        // put reference variable here

        int error_count, correct_count;

        function new(string name = "WRAPPER_scoreboard",uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            WRAPPER_sb_export = new("WRAPPER_sb_export",this);
            WRAPPER_sb_fifo = new("WRAPPER_sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            WRAPPER_sb_export.connect(WRAPPER_sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            error_count = 0;
            correct_count = 0;
            forever begin
                WRAPPER_sb_fifo.get(seq_item);
                //if (seq_item.op == 3'b111)
                    if (seq_item.MISO_DUT != seq_item.MISO_GM) begin
                        //`uvm_error("run_phase",$sformatf("comparison failed, transaction received by dut :%s",seq_item.convert2string()));
                        error_count = error_count + 1;
                    end else begin
                        //`uvm_info ("run_phase",$sformatf("comparison Success, transaction received by dut :%s",seq_item.convert2string()),UVM_LOW);
                        correct_count = correct_count + 1;
                    end
                
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info ("report_phase",$sformatf("Correct Count = %0d, Error Count = %0d",correct_count, error_count),UVM_LOW);
        endfunction
        task ref_model(WRAPPER_sequence_item seq_item_chk);
            // reference model
        endtask
    endclass //WRAPPER_scoreboard extends uvm_scoreboard
endpackage