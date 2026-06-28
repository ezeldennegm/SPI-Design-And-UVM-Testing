package ram_coverage_collector_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import ram_sequence_item_pkg::*;
    import shared_pkg::*;

    class ram_coverage extends uvm_component;
        `uvm_component_utils(ram_coverage)
        uvm_analysis_export   #(ram_sequence_item) cov_export;
        uvm_tlm_analysis_fifo #(ram_sequence_item) cov_fifo;
        ram_sequence_item seq_item_cov;

        logic [1:0] prev_cmd;

        covergroup RAM_cg;
            //Checking din[9:8] takes 4 possible values
            CMD_cp : coverpoint seq_item_cov.din[9:8] {
                bins write_addr = {2'b00};
                bins write_data = {2'b01};
                bins read_addr  = {2'b10};
                bins read_data  = {2'b11};
            }

            CMD_TRANS_cp : coverpoint seq_item_cov.din[9:8] {
                bins write_addr_to_write_data = (2'b00 => 2'b01);
                bins write_addr_to_read_addr  = (2'b00 => 2'b10);
                bins write_data_to_write_addr = (2'b01 => 2'b00);
                bins write_data_to_read_addr  = (2'b01 => 2'b10);
                bins read_addr_to_write_addr  = (2'b10 => 2'b00);
                bins read_addr_to_read_data   = (2'b10 => 2'b11);
                bins read_data_to_write_addr  = (2'b11 => 2'b00);
                bins read_data_to_read_addr   = (2'b11 => 2'b10);
            }

            RX_VALID_cp : coverpoint seq_item_cov.rx_valid {
                bins rx_valid_0 = {0};
                bins rx_valid_1 = {1};
            }

            TX_VALID_cp : coverpoint seq_item_cov.tx_valid {
                bins tx_valid_0 = {0};
                bins tx_valid_1 = {1};
            }

            //Checking write data after write address
            WR_DATA_AFTER_WR_ADDR : coverpoint seq_item_cov.din[9:8] {
                bins wr_data_after_wr_addr = (2'b00 => 2'b01);
            }
            
            //Checking read data after read address
            RD_DATA_AFTER_RD_ADDR : coverpoint seq_item_cov.din[9:8] {
                bins rd_data_after_rd_addr = (2'b10 => 2'b11);
            }

            //Checking the sequence : write address => write data => read address => read data 
            FULL_SEQUENCE : coverpoint seq_item_cov.din[9:8] {
                bins full_seq = (2'b00 => 2'b01 => 2'b10 => 2'b11);
            }

            //CROSS COVERAGE:
    
            //Between all bins of din[9:8] and rx_valid signal when it is high
            CMD_RX_VALID_cross : cross CMD_cp, RX_VALID_cp {
                ignore_bins rx_not_valid = binsof(RX_VALID_cp.rx_valid_0);
            }

            //Between din[9:8] when it equals read data and tx_valid when it is high
            RD_DATA_TX_VALID_cross : cross CMD_cp, TX_VALID_cp {
                ignore_bins not_read_data = binsof(CMD_cp) intersect {2'b00, 2'b01, 2'b10};
                ignore_bins tx_not_valid = binsof(TX_VALID_cp.tx_valid_0);
            }

        endgroup

        function new(string name = "ram_coverage", uvm_component parent = null);
            super.new(name, parent);
            RAM_cg = new();
            prev_cmd = 2'b00;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                RAM_cg.sample();
                prev_cmd = seq_item_cov.din[9:8];
            end
        endtask
    endclass
endpackage