package ram_sequence_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import ram_sequence_item_pkg::*;
    import shared_pkg::*;
    
    class ram_reset_sequence extends uvm_sequence #(ram_sequence_item);
        `uvm_object_utils(ram_reset_sequence)

        ram_sequence_item ram_seq_item;

        function new(string name = "ram_reset_sequence");
            super.new(name);
        endfunction

        task body();
            ram_seq_item = ram_sequence_item::type_id::create("ram_seq_item");

            start_item(ram_seq_item);
                ram_seq_item.rst_n     = 0;
                ram_seq_item.rx_valid  = 0;
                ram_seq_item.din       = 0;
            finish_item(ram_seq_item);
        endtask
    endclass

    class ram_writeOnly_sequence extends uvm_sequence #(ram_sequence_item);
        `uvm_object_utils(ram_writeOnly_sequence)

        ram_sequence_item ram_seq_item;
        cmd_type_e prev_cmd;

        function new(string name = "ram_writeOnly_sequence");
            super.new(name);
        endfunction

        task body();
            prev_cmd = WRITE_ADDR;
            
            repeat(1000) begin
                ram_seq_item = ram_sequence_item::type_id::create("ram_seq_item");
                //enable constraint_3
                ram_seq_item.reset_c.constraint_mode(1);
                ram_seq_item.rx_valid_c.constraint_mode(1);
                ram_seq_item.WR_ONLY.constraint_mode(1);
                ram_seq_item.RD_ONLY.constraint_mode(0);

                start_item(ram_seq_item);
                    assert(ram_seq_item.randomize());
                finish_item(ram_seq_item);
                
                prev_cmd = ram_seq_item.cmd;
            end
        endtask
        
        function void post_randomize();
            if (prev_cmd == WRITE_ADDR) begin
                ram_seq_item.cmd = (ram_seq_item.cmd == WRITE_ADDR || ram_seq_item.cmd == WRITE_DATA) ? 
                                    ram_seq_item.cmd : WRITE_DATA;
            end
        endfunction
    endclass

    class ram_readOnly_sequence extends uvm_sequence #(ram_sequence_item);
        `uvm_object_utils(ram_readOnly_sequence)

        ram_sequence_item ram_seq_item;
        cmd_type_e prev_cmd;

        function new(string name = "ram_readOnly_sequence");
            super.new(name);
        endfunction

        task body();
            prev_cmd = READ_ADDR;
            
            repeat(1000) begin
                ram_seq_item = ram_sequence_item::type_id::create("ram_seq_item");

                ram_seq_item.reset_c.constraint_mode(1);
                ram_seq_item.rx_valid_c.constraint_mode(1);
                ram_seq_item.WR_ONLY.constraint_mode(0);
                ram_seq_item.RD_ONLY.constraint_mode(1);

                start_item(ram_seq_item);
                    assert(ram_seq_item.randomize());
                finish_item(ram_seq_item);
                
                prev_cmd = ram_seq_item.cmd;
            end
        endtask
    endclass

    class ram_readWrite_sequence extends uvm_sequence #(ram_sequence_item);
        `uvm_object_utils(ram_readWrite_sequence)

        ram_sequence_item ram_seq_item;
        cmd_type_e prev_cmd;
        int rand_val;

        function new(string name = "ram_readWrite_sequence");
            super.new(name);
        endfunction

        task body();
            prev_cmd = WRITE_ADDR;
            
            repeat(20000) begin
                ram_seq_item = ram_sequence_item::type_id::create("ram_seq_item");

                ram_seq_item.reset_c.constraint_mode(1);
                ram_seq_item.rx_valid_c.constraint_mode(1);
                ram_seq_item.WR_ONLY.constraint_mode(0);
                ram_seq_item.RD_ONLY.constraint_mode(0);

                start_item(ram_seq_item);
                    assert(ram_seq_item.randomize());
                    post_randomize();
                finish_item(ram_seq_item);
                
                prev_cmd = ram_seq_item.cmd;
            end
        endtask
        
        function void post_randomize();
            rand_val = $urandom_range(0, 99);
            
            case(prev_cmd)
                WRITE_ADDR: begin
                    if (!(ram_seq_item.cmd inside {WRITE_ADDR, WRITE_DATA}))
                        ram_seq_item.cmd = WRITE_DATA;
                end
                
                WRITE_DATA: begin
                    if (rand_val < 60)
                        ram_seq_item.cmd = READ_ADDR;
                    else
                        ram_seq_item.cmd = WRITE_ADDR;
                end
                
                READ_ADDR: begin
                    if (!(ram_seq_item.cmd inside {READ_ADDR, READ_DATA}))
                        ram_seq_item.cmd = READ_DATA;
                end
                
                READ_DATA: begin
                    if (rand_val < 60)
                        ram_seq_item.cmd = WRITE_ADDR;
                    else
                        ram_seq_item.cmd = READ_ADDR;
                end
            endcase
            
            ram_seq_item.din[9:8] = ram_seq_item.cmd;
        endfunction
    endclass
    
endpackage
