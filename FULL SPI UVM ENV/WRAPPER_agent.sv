package WRAPPER_agent_pkg;
    import uvm_pkg::*;
    import WRAPPER_config_pkg::*;
    import WRAPPER_driver_pkg::*;
    import WRAPPER_monitor_pkg::*;
    import WRAPPER_sequencer_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_agent extends uvm_agent;
        `uvm_component_utils(WRAPPER_agent)

        WRAPPER_config cfg;
        WRAPPER_driver WRAPPER_drv;
        WRAPPER_monitor WRAPPER_mon;
        WRAPPER_sequencer WRAPPER_sqr;
        uvm_analysis_port #(WRAPPER_sequence_item) WRAPPER_agt_ap;

        function new(string name = "WRAPPER_agent",uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            if (!uvm_config_db#(WRAPPER_config)::get(this,"","CFG",cfg)) begin
                `uvm_fatal("build_phase","unable to get configuration object");
            end
            
            WRAPPER_mon = WRAPPER_monitor ::type_id::create("WRAPPER_mon",this);
            WRAPPER_sqr = WRAPPER_sequencer ::type_id::create("WRAPPER_sqr",this);
            WRAPPER_drv = WRAPPER_driver ::type_id::create("WRAPPER_drv",this);
            WRAPPER_agt_ap = new("WRAPPER_agt_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            WRAPPER_drv.WRAPPER_vif = cfg.WRAPPER_vif;
            WRAPPER_mon.WRAPPER_vif = cfg.WRAPPER_vif;
            WRAPPER_drv.seq_item_port.connect(WRAPPER_sqr.seq_item_export);
            WRAPPER_mon.WRAPPER_mon_ap.connect(WRAPPER_agt_ap);
        endfunction
    endclass //WRAPPER_agent extends uvm_agent
endpackage