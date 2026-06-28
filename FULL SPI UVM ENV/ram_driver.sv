package ram_driver_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import ram_sequencer_pkg::*;
    import ram_sequence_item_pkg::*;

    class ram_driver extends uvm_driver #(ram_sequence_item);
        `uvm_component_utils(ram_driver)

        virtual ram_interface drv_vif;
        ram_sequence_item stim_seq_item;

        function new(string name = "ram_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                stim_seq_item = ram_sequence_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);

                @(negedge drv_vif.clk);
                
                drv_vif.rst_n       = stim_seq_item.rst_n;
                drv_vif.din         = stim_seq_item.din;
                drv_vif.rx_valid    = stim_seq_item.rx_valid;


                seq_item_port.item_done();

                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH);
            end
        endtask
    endclass
    
endpackage