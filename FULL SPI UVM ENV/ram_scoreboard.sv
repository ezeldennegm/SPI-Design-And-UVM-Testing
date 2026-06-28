package ram_scoreboard_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import ram_sequence_item_pkg::*;

    class ram_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ram_scoreboard)

        uvm_analysis_export #(ram_sequence_item) sb_export;
        uvm_tlm_analysis_fifo #(ram_sequence_item) sb_fifo;
        ram_sequence_item seq_item_sb;

        logic [7:0] MEM_GM [255:0];
        logic [7:0] dout_GM;
        logic tx_valid_GM;
        logic [7:0] Rd_Addr_GM, Wr_Addr_GM;

        int error_count = 0;
        int correct_count = 0;
        
        function new(string name = "ram_scoreboard", uvm_component parent = null);
            super.new(name, parent);
            dout_GM = 0;
            tx_valid_GM = 0;
            Rd_Addr_GM = 0;
            Wr_Addr_GM = 0;
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                sb_fifo.get(seq_item_sb);
                //reference_model(seq_item_sb);
                
                if (seq_item_sb.dout != seq_item_sb.dout_GM) begin
                    `uvm_error("run_phase", $sformatf("DATA OUT Comparison failed! Expected: 0x%0h, Got: 0x%0h, transaction: %s",
                    dout_GM, seq_item_sb.dout, seq_item_sb.convert2string()));
                    error_count++;
                end else if (seq_item_sb.tx_valid != seq_item_sb.tx_valid_GM) begin
                    `uvm_error("run_phase", $sformatf("TX_VALID Comparison failed! Expected: %0b, Got: %0b, transaction: %s",
                    tx_valid_GM, seq_item_sb.tx_valid, seq_item_sb.convert2string()));
                    error_count++;
                end else begin
                    `uvm_info("run_phase", $sformatf("Correct output: %s", seq_item_sb.convert2string()), UVM_HIGH);
                    correct_count++;
                end
            end
        endtask

        
        task reference_model(input ram_sequence_item ram_seq_ref);
            if (~ram_seq_ref.rst_n) begin
                dout_GM = 0;
                tx_valid_GM = 0;
                Rd_Addr_GM = 0;
                Wr_Addr_GM = 0;
            end
            else begin
                
                if (ram_seq_ref.rx_valid) begin
                    case (ram_seq_ref.din[9:8])
                        2'b00 : begin Wr_Addr_GM = ram_seq_ref.din[7:0]; tx_valid_GM = 0; end       
                        2'b01 : begin MEM_GM[Wr_Addr_GM] = ram_seq_ref.din[7:0]; tx_valid_GM = 0; end
                        2'b10 : begin Rd_Addr_GM = ram_seq_ref.din[7:0]; tx_valid_GM = 0; end
                        2'b11 : begin                                         
                            dout_GM = MEM_GM[Rd_Addr_GM];
                            tx_valid_GM = 1'b1;
                        end
                    endcase
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful counts: %0d", correct_count), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("Total failed counts: %0d", error_count), UVM_MEDIUM);
        endfunction
        
    endclass
endpackage