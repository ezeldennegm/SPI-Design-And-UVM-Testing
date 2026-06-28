package ram_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import ram_sequencer_pkg::*;
    import ram_sequence_item_pkg::*;
    import ram_driver_pkg::*;
    import ram_monitor_pkg::*;
    import WRAPPER_config_pkg::*;

    class ram_agent extends uvm_agent;
        `uvm_component_utils(ram_agent)

        ram_sequencer agt_sqr;
        ram_driver agt_drv;
        ram_monitor agt_mon;
        WRAPPER_config ram_config_obj_agt;

        uvm_analysis_port #(ram_sequence_item) agt_ap;

        function new(string name = "ram_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(WRAPPER_config)::get(this, "", "CFG", ram_config_obj_agt))begin
            `uvm_fatal("RAM_AGENT", "RAM_VIF_CONFIG not found in uvm")
            end

            if (ram_config_obj_agt.active_ram==UVM_ACTIVE) begin
                agt_sqr = ram_sequencer::type_id::create("agt_sqr", this);
                agt_drv = ram_driver::type_id::create("agt_drv", this);                
            end

            agt_mon = ram_monitor::type_id::create("agt_mon", this);
            agt_ap = new("agt_ap", this);
    endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if (ram_config_obj_agt.active_ram==UVM_ACTIVE) begin
                agt_drv.drv_vif = ram_config_obj_agt.ram_config_vif;
                agt_drv.seq_item_port.connect(agt_sqr.seq_item_export);              
            end
            
            agt_mon.mon_vif = ram_config_obj_agt.ram_config_vif;
            agt_mon.mon_ap.connect(agt_ap);
        endfunction
    endclass
endpackage
