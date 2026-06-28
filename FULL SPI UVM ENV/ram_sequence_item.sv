package ram_sequence_item_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import shared_pkg::*;
    
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;

    typedef enum logic [1:0] {
        WRITE_ADDR = 2'b00,
        WRITE_DATA = 2'b01,
        READ_ADDR  = 2'b10,
        READ_DATA  = 2'b11
    } cmd_type_e;

    class ram_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(ram_sequence_item)

        rand logic [9:0] din;
        rand logic rst_n, rx_valid;

        logic [7:0] dout;
        logic tx_valid;

        logic [7:0] dout_GM;
        logic tx_valid_GM;

        rand cmd_type_e cmd;
        rand logic [7:0] addr_data;
        
        
        //Constrains
        //constraint_1
        constraint reset_c {
            rst_n dist { 0 := 2, 1 := 98};
        }
        //constraint_2
        constraint rx_valid_c {
            rx_valid dist { 1 := 95, 0 := 5};
        }
        
        constraint din_c {
            din[9:8] == cmd;
            din[7:0] == addr_data;
        }
        //constraint_3
        constraint WR_ONLY {
            cmd inside {WRITE_ADDR, WRITE_DATA};
        }
        //constraint_4
        constraint RD_ONLY {
            cmd inside {READ_ADDR, READ_DATA};
        }

        function new(string name = "ram_sequence_item");
            super.new(name);
        endfunction

        function string convert2string();
             return $sformatf("%s rst_n = %0b, din = 10'b%b [cmd=%s, addr_data=0x%0h], rx_valid = %0b, dout = 0x%0h, tx_valid = %0b",
                    super.convert2string(), rst_n, din, cmd.name(), addr_data, rx_valid, dout, tx_valid);
        endfunction

        function string convert2string_stimulus();
             return $sformatf("%s rst_n = %0b, din = 10'b%b [cmd=%s, addr_data=0x%0h], rx_valid = %0b", 
                    super.convert2string(), rst_n, din, cmd.name(), addr_data, rx_valid);
        endfunction

    endclass
endpackage
