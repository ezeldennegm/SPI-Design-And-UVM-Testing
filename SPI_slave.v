module SPI_slave (
    input clk,
    input rst_n,
    input SS_n,
    input MOSI,
    input tx_valid,
    input [7:0] tx_data,
    output reg MISO,
    output reg rx_valid,
    output reg [9:0] rx_data
);

    // State definitions
    (* fsm_encoding = "one_hot" *) reg [2:0] cs, ns; // current state, next state
    parameter IDLE = 0;
    parameter CHK_CMD = 1; 
    parameter WRITE = 2;
    parameter READ_ADDR = 3;
    parameter READ_DATA = 4;

    reg [4:0] bit_counter;
    reg [9:0] shift_reg;
    reg [7:0] miso_shift_reg;
    reg read_addr_done;

    // Current state and counters
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cs <= IDLE;
            bit_counter <= 0;
            read_addr_done <= 0;
        end else if (SS_n) begin
            cs <= IDLE;
            bit_counter <= 0;
        end else begin
            cs <= ns;
            // Only increment bit_counter during operations
            if (cs == WRITE || cs == READ_ADDR || cs == READ_DATA)
                bit_counter <= bit_counter + 1;
            else
                bit_counter <= 0; // Reset when entering operations from CHK_CMD
                
            if (cs == READ_ADDR && bit_counter >= 9) // 10 bits counted (0-9)
                read_addr_done <= 1;
            else if (cs == READ_DATA) begin
                read_addr_done <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (cs)
            IDLE: ns = SS_n ? IDLE : CHK_CMD;
            CHK_CMD: begin
                if (bit_counter == 0) begin
                    if (MOSI == 0) ns = WRITE;
                    else ns = (read_addr_done) ? READ_DATA : READ_ADDR;
                end else ns = CHK_CMD;
            end
            WRITE: ns = WRITE;        // 10 bits (0-9)
            READ_ADDR: ns = READ_ADDR;  // 10 bits (0-9)
            READ_DATA: ns = READ_DATA;  // 18 total clocks (0-17): 10 bits in + 8 bits out
            default: ns = IDLE;
        endcase
    end

    // Data handling
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            shift_reg <= 0;
            rx_data <= 0;
            rx_valid <= 0;
            miso_shift_reg <= 0;
            MISO <= 0;
        end else begin
            rx_valid <= 0;
            case (cs)
                WRITE, READ_ADDR: begin
                    shift_reg <= {shift_reg[8:0], MOSI};
                    if (bit_counter == 9) begin // After 10 bits (0-9)
                        rx_valid <= 1;
                        rx_data <= {shift_reg[8:0], MOSI}; // Include the current MOSI bit
                    end
                end
                READ_DATA: begin
                    if (bit_counter <= 9) begin
                        // Phase 1: Receive 10 bits (same as other operations)
                        shift_reg <= {shift_reg[8:0], MOSI};
                        if (bit_counter == 9) begin
                            rx_data <= {shift_reg[8:0], MOSI}; // Send complete 10-bit data to RAM
                            rx_valid <= 1;
                        end
                    end else begin
                        // Phase 2: Transmit 8 bits via MISO
                        if (bit_counter == 11 ) begin
                            // Load MISO data when RAM responds
                            if (tx_valid) miso_shift_reg <= tx_data;
                        end else if (bit_counter >= 12 ) begin
                            {MISO, miso_shift_reg} <= {miso_shift_reg, 1'b0};
                        end
                    end
                end
            endcase
            
            // MISO handled in READ_DATA case above
            if (SS_n) 
                MISO <= 0;
            else if (cs != READ_DATA)
                MISO <= 0;
        end
    end
endmodule