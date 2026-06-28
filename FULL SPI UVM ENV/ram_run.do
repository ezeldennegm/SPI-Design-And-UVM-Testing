vlib work

vlog -f src_files.list +cover -covercells

vsim -voptargs=+acc work.ram_top -cover -classdebug -uvmcontrol=all 

run 0

add wave /ram_top/ram_if/*

add wave -position insertpoint \
sim:/@ram_scoreboard@1.dout_GM \
sim:/@ram_scoreboard@1.tx_valid_GM \
sim:/@ram_scoreboard@1.Rd_Addr_GM \
sim:/@ram_scoreboard@1.Wr_Addr_GM \
sim:/@ram_scoreboard@1.error_count \
sim:/@ram_scoreboard@1.correct_count \
sim:/ram_top/DUT/din \
sim:/ram_top/DUT/rx_valid \
sim:/ram_top/DUT/dout \
sim:/ram_top/DUT/tx_valid

coverage save RAM.ucdb -onexit

run -all
# vcover report RAM.ucdb -details -annotate -all -output RAM.txt