vlib work
vlog  ram.v SPI_slave.v wrapper.v SPI_tb.v
vsim -voptargs=+acc work.SPI_tb
add wave -position insertpoint  \
sim:/SPI_tb/DUT/clk \
sim:/SPI_tb/DUT/rst_n \
sim:/SPI_tb/DUT/MOSI \
sim:/SPI_tb/DUT/SS_n \
sim:/SPI_tb/DUT/MISO \
sim:/SPI_tb/DUT/ram_data_in \
sim:/SPI_tb/DUT/ram_rx_valid \
sim:/SPI_tb/DUT/ram_data_out \
sim:/SPI_tb/DUT/ram_tx_valid
run -all