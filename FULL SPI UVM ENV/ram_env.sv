package ram_env_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import ram_agent_pkg::*;
    import ram_scoreboard_pkg::*;
    import ram_coverage_collector_pkg::*;
    import ram_sequence_item_pkg::*;

    class ram_env extends uvm_env;
        `uvm_component_utils(ram_env)

        ram_agent agt;
        ram_scoreboard sb;
        ram_coverage cov;
        
        uvm_analysis_port #(ram_sequence_item) agt_ap;

        function new(string name = "ram_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            agt = ram_agent::type_id::create("agt", this);
            sb  = ram_scoreboard::type_id::create("sb", this);
            cov = ram_coverage::type_id::create("cov", this);
            
            agt_ap = new("agt_ap", this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(sb.sb_export);
            agt.agt_ap.connect(cov.cov_export);
        endfunction
        
    endclass

endpackage