package WRAPPER_sequencer_pkg;
    import uvm_pkg::*;
    import WRAPPER_sequence_item_pkg::*;
    `include "uvm_macros.svh"
    
    class WRAPPER_sequencer extends uvm_sequencer #(WRAPPER_sequence_item);
        `uvm_component_utils(WRAPPER_sequencer)

        function new(string name = "WRAPPER_sequencer", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()
    endclass //WRAPPER_sequencer extends uvm_sequencer
endpackage