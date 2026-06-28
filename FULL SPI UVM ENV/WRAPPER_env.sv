package WRAPPER_environment_pkg;
    import uvm_pkg::*;
    import WRAPPER_agent_pkg::*;
    import WRAPPER_scoreboard_pkg::*;
    import WRAPPER_coverage_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_environment extends uvm_env;
        `uvm_component_utils(WRAPPER_environment)

        WRAPPER_agent agt;
        WRAPPER_scoreboard sb;
        WRAPPER_coverage cov;

        function new(string name = "WRAPPER_environment", uvm_component parent = null);
            super.new(name,parent);
        endfunction
            
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            agt = WRAPPER_agent :: type_id::create("agt",this);
            sb = WRAPPER_scoreboard :: type_id::create("sb",this);
            cov = WRAPPER_coverage :: type_id::create("cov",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.WRAPPER_agt_ap.connect(sb.WRAPPER_sb_export);
            agt.WRAPPER_agt_ap.connect(cov.WRAPPER_cov_export);
        endfunction
    endclass //WRAPPER_environment extends superClass
endpackage