package ram_test_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import ram_config_pkg::*;
    import ram_env_pkg::*;
    import ram_sequence_pkg::*;

    class ram_test extends uvm_test;
        `uvm_component_utils(ram_test)

        ram_env env;
        ram_config_obj ram_config_obj_test;

        ram_reset_sequence ram_reset_seq;
        ram_writeOnly_sequence ram_writeOnly_seq;
        ram_readOnly_sequence ram_readOnly_seq;
        ram_readWrite_sequence ram_readWrite_seq;

        virtual ram_interface ram_vif;
        
        function new(string name = "ram_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            env = ram_env::type_id::create("env", this);

            ram_config_obj_test = ram_config_obj::type_id::create("ram_config_obj_test", this);

            ram_reset_seq       = ram_reset_sequence::type_id::create("ram_reset_sequence", this);
            ram_writeOnly_seq   = ram_writeOnly_sequence::type_id::create("ram_writeOnly_sequence", this);
            ram_readOnly_seq    = ram_readOnly_sequence::type_id::create("ram_readOnly_sequence", this);
            ram_readWrite_seq   = ram_readWrite_sequence::type_id::create("ram_readWrite_sequence", this);

            
            if(!uvm_config_db #(virtual ram_interface)::get(this, "", "RAM_VIF", ram_config_obj_test.ram_config_vif))
                `uvm_fatal("build_phase", "TEST- ERROR in the virtual interface in ram_config_vif")

            
            uvm_config_db #(ram_config_obj)::set(this, "*", "RAM_VIF_CONFIG", ram_config_obj_test);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            `uvm_info("run_phase", "RESET asserted", UVM_LOW)
            ram_reset_seq.start(env.agt.agt_sqr);
            `uvm_info("run_phase", "RESET deasserted", UVM_LOW)

            `uvm_info("run_phase", "WR Only sequence started", UVM_LOW)
            ram_writeOnly_seq.start(env.agt.agt_sqr);
            `uvm_info("run_phase", "WR Only sequence ended", UVM_LOW)

            `uvm_info("run_phase", "RD Only sequence started", UVM_LOW)
            ram_readOnly_seq.start(env.agt.agt_sqr);
            `uvm_info("run_phase", "RD Only sequence ended", UVM_LOW)

            `uvm_info("run_phase", "WR RD sequence started", UVM_LOW)
            ram_readWrite_seq.start(env.agt.agt_sqr);
            `uvm_info("run_phase", "WR RD sequence ended", UVM_LOW)

            phase.drop_objection(this);
        endtask

    endclass
    
endpackage