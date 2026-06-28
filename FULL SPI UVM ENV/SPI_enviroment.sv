package SPI_enviroment_pkg;
import uvm_pkg::*;
`include"uvm_macros.svh"
import SPI_agent_pkg::*;
import SPI_score_board_pkg::*;
import SPI_coverage1_pkg::*;
class SPI_enviroment extends uvm_env;
`uvm_component_utils(SPI_enviroment)
SPI_score_board sb;
SPI_coverage1 cov;
SPI_agent agt;
function new (string name=" SPI_enviroment",uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
agt=SPI_agent::type_id::create("agt",this);
sb=SPI_score_board::type_id::create("sb",this);
cov=SPI_coverage1::type_id::create("cov",this);
endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
agt.agt_ap.connect(sb.sb_export);
agt.agt_ap.connect(cov.cov_export);
endfunction

endclass
endpackage