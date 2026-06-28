package SPI_test_pkg;
import uvm_pkg::*;
import SPI_enviroment_pkg::*;
import SPI_config_pkg::*;
import SPI_main_sequence_pkg::*;
import SPI_reset_sequence_pkg::*;
`include"uvm_macros.svh"
class SPI_test extends uvm_test ;
`uvm_component_utils(SPI_test)
SPI_enviroment env;
SPI_config config1;
SPI_main_sequence main_seq;
SPI_reset_sequence reset_seq;
virtual SPI_interface SPIinterface; 
function new (string name=" SPI_test",uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
env=SPI_enviroment::type_id::create("env",this);
config1=SPI_config::type_id::create("config1",this);
main_seq=SPI_main_sequence::type_id::create("main_seq",this);
reset_seq=SPI_reset_sequence::type_id::create("reset_seq",this);
if(!uvm_config_db #(virtual SPI_interface ) ::get(this,"","VIF",config1.spiif))
`uvm_fatal("run phase in test ","enable to get interface in test");
config1.is_active=UVM_ACTIVE;
uvm_config_db #(SPI_config)::set (this,"*","CFG",config1);
endfunction
task run_phase (uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
`uvm_info("run phase in test","Reseet Asserted",UVM_LOW);
reset_seq.start(env.agt.sqr);
`uvm_info("run phase in test","Reseet DEAsserted",UVM_LOW);
main_seq.start(env.agt.sqr);
`uvm_info("run phase in test","stimulus generation ended",UVM_LOW);
phase.drop_objection(this);
endtask
endclass
endpackage