package WRAPPER_test_pkg;
    import uvm_pkg::*;
    import WRAPPER_environment_pkg::*;
    import ram_env_pkg::*;
    import SPI_enviroment_pkg::*;
    import WRAPPER_config_pkg::*;
    import WRAPPER_reset_sequence_pkg::*;
    import WRAPPER_write_only_sequence_pkg::*;
    import WRAPPER_read_only_sequence_pkg::*;
    import WRAPPER_write_read_sequence_pkg::*;
    import WRAPPER_directed_sequence_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_test extends uvm_test;
        `uvm_component_utils(WRAPPER_test)

        WRAPPER_config cfg;
        WRAPPER_environment WRAPPER_env;
        ram_env ram_environment;
        SPI_enviroment SPI_env;
        WRAPPER_reset_sequence reset_seq;
        WRAPPER_write_only_sequence write_seq;
        WRAPPER_read_only_sequence read_seq;
        WRAPPER_write_read_sequence write_read_seq;
        WRAPPER_directed_sequence directed_seq;

        function  new(string name = "WRAPPER_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            WRAPPER_env = WRAPPER_environment :: type_id::create("WRAPPER_env",this);
            ram_environment = ram_env ::type_id::create("ram_environment", this);
            SPI_env         = SPI_enviroment ::type_id::create("SPI_env", this);
            cfg = WRAPPER_config :: type_id:: create("cfg");
            reset_seq = WRAPPER_reset_sequence ::type_id::create("reset_seq");
            write_seq = WRAPPER_write_only_sequence ::type_id::create("write_seq");
            read_seq = WRAPPER_read_only_sequence ::type_id::create("read_seq");
            write_read_seq = WRAPPER_write_read_sequence ::type_id::create("write_read_seq");
            directed_seq = WRAPPER_directed_sequence ::type_id::create("directed_seq");

            if (!uvm_config_db #(virtual WRAPPER_interface) :: get(this,"","WRAPPER_V_IF",cfg.WRAPPER_vif)) begin
                `uvm_fatal("build_phase","TEST- Unable to get virtual interface");
            end

            if (!uvm_config_db #(virtual SPI_interface) :: get(this,"","SPI_VIF",cfg.spiif)) begin
                `uvm_fatal("build_phase","TEST- Unable to get virtual interface");
            end

            if (!uvm_config_db #(virtual ram_interface) :: get(this,"","RAM_VIF",cfg.ram_config_vif)) begin
                `uvm_fatal("build_phase","TEST- Unable to get virtual interface");
            end

            cfg.active_ram = UVM_PASSIVE;
            cfg.active_spi = UVM_PASSIVE;

            uvm_config_db #(WRAPPER_config) ::set(this,"*","CFG",cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            phase.raise_objection(this);

            `uvm_info("run_phase","reset asserted",UVM_LOW)
            reset_seq.start(WRAPPER_env.agt.WRAPPER_sqr);
            `uvm_info("run_phase","reset deasserted",UVM_LOW)

            `uvm_info("run_phase","Write only started",UVM_LOW)
            write_seq.start(WRAPPER_env.agt.WRAPPER_sqr);
            `uvm_info("run_phase","Write only stopped",UVM_LOW)

            `uvm_info("run_phase","Read only started",UVM_LOW)
            read_seq.start(WRAPPER_env.agt.WRAPPER_sqr);
            `uvm_info("run_phase","Read only stopped",UVM_LOW)

            `uvm_info("run_phase","Write Read started",UVM_LOW)
            write_read_seq.start(WRAPPER_env.agt.WRAPPER_sqr);
            `uvm_info("run_phase","Write Read stopped",UVM_LOW)
            
            `uvm_info("run_phase","Write Read started",UVM_LOW)
            directed_seq.start(WRAPPER_env.agt.WRAPPER_sqr);
            `uvm_info("run_phase","Write Read stopped",UVM_LOW)

            phase.drop_objection(this);
        endtask        
    endclass //WRAPPER_test extends uvm_tet
endpackage