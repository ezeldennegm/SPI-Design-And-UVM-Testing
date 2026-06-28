module SPI_tb();
    reg clk_tb, rst_n_tb, MOSI_tb, SS_n_tb;
    wire MISO_tb;

    wrapper DUT(clk_tb, rst_n_tb, MOSI_tb, SS_n_tb, MISO_tb);

    reg [7:0] counter;
    reg [7:0] expected_data;
    reg checking;
        
    // Clock generation
    initial begin
        clk_tb = 0;
        forever
        #1 clk_tb = ~clk_tb;
    end

    initial begin
        $readmemh("mem.dat", DUT.DUT1.mem);
        counter = 0;
        MOSI_tb = 0;
        SS_n_tb = 1;
        checking = 0;
        // Reset test
        rst_n_tb = 0;
        @(negedge clk_tb);
        if(MISO_tb != 0) begin
            $display("Error In Reset Test");
            $stop;
        end
        $display("Reset Test Passed");
        rst_n_tb = 1;
        @(negedge clk_tb);

        // Write Address and Write Data Tests
        repeat(256) begin
            // Write Address Operation (Command = 0, then 10 bits: 2'b00 + 8-bit address)
            SS_n_tb = 0;
            @(negedge clk_tb);
            MOSI_tb = 1'b0;  // Command bit = 0 (write)
            @(negedge clk_tb);
            MOSI_tb = 1'b0;  // bit 9 (command MSB)
            @(negedge clk_tb);
            MOSI_tb = 1'b0;  // bit 8 (command LSB) - 2'b00 = write address
            @(negedge clk_tb);
            MOSI_tb = counter[7]; // bit 7 (address MSB)
            @(negedge clk_tb);
            MOSI_tb = counter[6]; // bit 6
            @(negedge clk_tb);
            MOSI_tb = counter[5]; // bit 5
            @(negedge clk_tb);
            MOSI_tb = counter[4]; // bit 4
            @(negedge clk_tb);
            MOSI_tb = counter[3]; // bit 3
            @(negedge clk_tb);
            MOSI_tb = counter[2]; // bit 2
            @(negedge clk_tb);
            MOSI_tb = counter[1]; // bit 1
            @(negedge clk_tb);
            MOSI_tb = counter[0]; // bit 0 (address LSB)
            @(negedge clk_tb);
            SS_n_tb = 1;
            $display("End of Write Address Test - Address: %d", counter);
            @(negedge clk_tb);

            // Write Data Operation (Command = 0, then 10 bits: 2'b01 + 8-bit data)
            SS_n_tb = 0;
            @(negedge clk_tb);
            MOSI_tb = 1'b0;  // Command bit = 0 (write)
            @(negedge clk_tb);
            MOSI_tb = 1'b0;  // bit 9 (command MSB)
            @(negedge clk_tb);
            MOSI_tb = 1'b1;  // bit 8 (command LSB) - 2'b01 = write data
            @(negedge clk_tb);
            MOSI_tb = counter[7]; // bit 7 (data MSB)
            @(negedge clk_tb);
            MOSI_tb = counter[6]; // bit 6
            @(negedge clk_tb);
            MOSI_tb = counter[5]; // bit 5
            @(negedge clk_tb);
            MOSI_tb = counter[4]; // bit 4
            @(negedge clk_tb);
            MOSI_tb = counter[3]; // bit 3
            @(negedge clk_tb);
            MOSI_tb = counter[2]; // bit 2
            @(negedge clk_tb);
            MOSI_tb = counter[1]; // bit 1
            @(negedge clk_tb);
            MOSI_tb = counter[0]; // bit 0 (data LSB)
            @(negedge clk_tb);
            SS_n_tb = 1;
            $display("End of Write Data Test - Data: %d", counter);
            @(negedge clk_tb);
            
            counter = counter + 1;
        end

        counter = 0;
        
        // Read Address and Read Data Tests
        repeat(256) begin
            // Read Address Operation (Command = 1, then 10 bits: 2'b10 + 8-bit address)
            SS_n_tb = 0;
            @(negedge clk_tb);
            MOSI_tb = 1'b1;  // Command bit = 1 (read)
            @(negedge clk_tb);
            MOSI_tb = 1'b1;  // bit 9 (command MSB)
            @(negedge clk_tb);
            MOSI_tb = 1'b0;  // bit 8 (command LSB) - 2'b10 = read address
            @(negedge clk_tb);
            MOSI_tb = counter[7]; // bit 7 (address MSB)
            @(negedge clk_tb);
            MOSI_tb = counter[6]; // bit 6
            @(negedge clk_tb);
            MOSI_tb = counter[5]; // bit 5
            @(negedge clk_tb);
            MOSI_tb = counter[4]; // bit 4
            @(negedge clk_tb);
            MOSI_tb = counter[3]; // bit 3
            @(negedge clk_tb);
            MOSI_tb = counter[2]; // bit 2
            @(negedge clk_tb);
            MOSI_tb = counter[1]; // bit 1
            @(negedge clk_tb);
            MOSI_tb = counter[0]; // bit 0 (address LSB)
            @(negedge clk_tb);
            SS_n_tb = 1;
            $display("End of Read Address Test - Address: %d", counter);
            @(negedge clk_tb);

            // Read Data Operation (Command = 1, then receive 8 bits via MISO)
            SS_n_tb = 0;
            @(negedge clk_tb);
            MOSI_tb = 1'b1;  // Command bit = 1 (read)
            @(negedge clk_tb);
            MOSI_tb = 1'b1;  // bit 9 (command MSB)
            @(negedge clk_tb);
            MOSI_tb = 1'b1;  // bit 8 (command LSB) - 2'b11 = read data
            @(negedge clk_tb);
            MOSI_tb = counter[7]; // bit 7 (address MSB)
            @(negedge clk_tb);
            MOSI_tb = counter[6]; // bit 6
            @(negedge clk_tb);
            MOSI_tb = counter[5]; // bit 5
            @(negedge clk_tb);
            MOSI_tb = counter[4]; // bit 4
            @(negedge clk_tb);
            MOSI_tb = counter[3]; // bit 3
            @(negedge clk_tb);
            MOSI_tb = counter[2]; // bit 2
            @(negedge clk_tb);
            MOSI_tb = counter[1]; // bit 1
            @(negedge clk_tb);
            MOSI_tb = counter[0];
            repeat(3) @(negedge clk_tb);

            // Capture MISO data over 8 clock cycles
            expected_data = 0;
            repeat(8) begin
                @(negedge clk_tb);
                expected_data = {expected_data[6:0], MISO_tb};
                $display("MISO = %0b", MISO_tb);
            end
            
            SS_n_tb = 1;
            $display("End of Read Data Test - Address: %d, Data Read: %d", counter, expected_data);
            checking = ~checking;
            // Verify read data matches written data
            if(expected_data == counter) begin
                $display("PASS: Read data matches written data");
            end else begin
                $display("FAIL: Read data (%d) does not match written data (%d)", expected_data, counter);
            end
            
            @(negedge clk_tb);
            counter = counter + 1;
        end
        
        $display("All tests completed");
        $stop;
    end
endmodule