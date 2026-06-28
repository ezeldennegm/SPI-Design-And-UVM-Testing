vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.WRAPPER_top -classdebug -uvmcontrol=all
add wave /WRAPPER_top/WRAPPER_top_if/*
add wave /WRAPPER_top/spiif/*
add wave /WRAPPER_top/ram_if/*
run -all
coverage save -onexit coverage.ucdb
coverage report -details -annotate -all -output coverage_rpt.txt