package SPI_score_board_pkg;
import uvm_pkg::*;
import SPI_sequence_item_pkg::*;
`include"uvm_macros.svh"
class SPI_score_board extends uvm_scoreboard;
`uvm_component_utils(SPI_score_board)
uvm_analysis_export #(SPI_sequence_item) sb_export;
uvm_tlm_analysis_fifo #(SPI_sequence_item) sb_fifo;
SPI_sequence_item seq_item;
int correct_count,error_count;
bit [2:0] opcode;
function new(string name="SPI_score_board",uvm_component parent=null);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
sb_export=new("sb_export",this);
sb_fifo=new("sb_fifo",this);
endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
		sb_fifo.get(seq_item);
			if(seq_item.tx_valid) begin
			if(seq_item.MISO!==seq_item.MISO_ref) begin
				error_count++;
				//    `uvm_error("run phase inscore board",$sformatf("error1 comparison failed Miso_out=%d Miso_ref=%d",seq_item.MISO,seq_item.MISO_ref));
			end
			else begin
				correct_count++;
				//`uvm_info("run phase in score board",$sformatf("correct output1 %s",seq_item.convert2string()),UVM_MEDIUM);
			end
			end
			if(seq_item.rx_valid && seq_item.rx_valid_ref ) begin
			if(seq_item.rx_data!==seq_item.rx_data_ref)
				begin
						error_count++;
						//`uvm_error("run phase inscore board",$sformatf("error2 comparison failed  rx_data= %d  rx_data_ref=%d rx_valid=%d  rx_valid_ref=%d",seq_item.rx_data,seq_item.rx_data_ref,seq_item.rx_valid,seq_item.rx_valid_ref));
				end
				else begin
					correct_count++;
					//`uvm_info("run phase in score board",$sformatf("correct output2 %s",seq_item.convert2string()),UVM_MEDIUM);
				end
			end

			   end

endtask
function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info("report phase in score board",$sformatf("correct_count = %0d, error_count = %0d",correct_count,error_count),UVM_MEDIUM);
endfunction
endclass
endpackage

//||seq_item.rx_valid!=seq_item.rx_valid_ref