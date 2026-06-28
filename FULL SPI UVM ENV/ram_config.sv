package ram_config_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    class ram_config_obj extends uvm_object;
        `uvm_object_utils(ram_config_obj)
        
        virtual ram_interface ram_config_vif;

        function new(string name = "ram_config_obj");
            super.new(name);
        endfunction
    endclass
endpackage
