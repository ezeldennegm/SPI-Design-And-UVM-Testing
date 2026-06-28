package WRAPPER_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class WRAPPER_config extends uvm_object;
        `uvm_object_utils(WRAPPER_config)

        virtual WRAPPER_interface WRAPPER_vif;
        virtual SPI_interface spiif;
        virtual ram_interface ram_config_vif;

        uvm_active_passive_enum active_ram;
        uvm_active_passive_enum active_spi;
        
        function new(string name = "WRAPPER_config");
            super.new(name);
        endfunction //new()
    endclass //WRAPPER_config extends uvm_object
endpackage