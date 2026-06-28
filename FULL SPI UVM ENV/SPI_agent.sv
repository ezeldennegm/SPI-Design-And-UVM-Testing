package SPI_agent_pkg;
import uvm_pkg::*;
`include"uvm_macros.svh"
import SPI_driver_pkg::*;
import SPI_monitor_pkg::*;
import SPI_sequencer_pkg::*;
import WRAPPER_config_pkg::*;
import SPI_sequence_item_pkg::*;
class SPI_agent extends uvm_agent;
`uvm_component_utils(SPI_agent)
SPI_driver drv;
SPI_monitor mon;
WRAPPER_config config1;
SPI_sequencer sqr;
uvm_analysis_port #(SPI_sequence_item) agt_ap;
function new(string name="SPI_agent",uvm_component parent=null);
super.new(name,parent);
endfunction
function void  build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(WRAPPER_config) ::get(this,"","CFG",config1))
`uvm_fatal("run phase in agent ","enable to get config in agent");
if(config1.active_spi==UVM_ACTIVE)begin
    drv=SPI_driver::type_id::create("drv",this);
    sqr=SPI_sequencer::type_id::create("sqr",this);
end
mon=SPI_monitor::type_id::create("mon",this);
agt_ap=new("agt_ap",this);
endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(config1.active_spi==UVM_ACTIVE)begin
    drv.seq_item_port.connect(sqr.seq_item_export);
    drv.SPIinterface=config1.spiif;
end
mon.SPIinterface=config1.spiif;
mon.mon_ap.connect(agt_ap);
endfunction
endclass
endpackage