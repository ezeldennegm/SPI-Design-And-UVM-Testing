package ram_monitor_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import ram_sequence_item_pkg::*;
    import ram_driver_pkg::*;
    
    class ram_monitor extends uvm_monitor;
        `uvm_component_utils(ram_monitor)

        virtual ram_interface mon_vif;
        ram_sequence_item rsp_seq_item;
        uvm_analysis_port #(ram_sequence_item) mon_ap;

        logic [9:0] prev_din;
        logic prev_rst_n;
        logic prev_rx_valid;

        function new(string name = "ram_monitor", uvm_component parent = null);
            super.new(name, parent);
            prev_din = 0;
            prev_rst_n = 0;
            prev_rx_valid = 0;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            @(negedge mon_vif.clk);
            
            forever begin
                rsp_seq_item = ram_sequence_item::type_id::create("rsp_seq_item");
                
                @(negedge mon_vif.clk);
                
                rsp_seq_item.rst_n       = prev_rst_n;
                rsp_seq_item.din         = prev_din;
                rsp_seq_item.rx_valid    = prev_rx_valid;

                rsp_seq_item.dout        = mon_vif.dout;
                rsp_seq_item.tx_valid    = mon_vif.tx_valid;

                rsp_seq_item.dout_GM        = mon_vif.dout_GM;
                rsp_seq_item.tx_valid_GM    = mon_vif.tx_valid_GM;    

                prev_rst_n   = mon_vif.rst_n;
                prev_din     = mon_vif.din;
                prev_rx_valid = mon_vif.rx_valid;

                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
            end
        endtask

    endclass
    
endpackage