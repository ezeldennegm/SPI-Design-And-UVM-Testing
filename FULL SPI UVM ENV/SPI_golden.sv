module SPI_slave ( clk, rst_n, SS_n, MOSI, tx_valid, tx_data, MISO, rx_valid, rx_data);


input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg   rx_valid, MISO;

    typedef enum logic [2:0] {
        IDLE       = 3'b000,
        CHK_CMD    = 3'b001,
        WRITE      = 3'b010,
        READ_ADDR  = 3'b011,
        READ_DATA  = 3'b100
    } state_t;

    state_t cs, ns;

    //===============================
    // Internal signals
    //===============================
    reg [3:0] bit_counter;
    reg       read_addr_done;

    //===============================
    // State register
    //===============================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cs <= IDLE;
        else if (SS_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    //===============================
    // Next-state logic
    //===============================
    always @(*) begin
        ns = cs; // default stay
        case (cs)
            IDLE: begin
                if (!SS_n)
                    ns = CHK_CMD;
            end

            CHK_CMD: begin
                if (MOSI == 1'b0)
                    ns = WRITE;
                else
                    ns = (read_addr_done) ? READ_DATA : READ_ADDR;
            end

            WRITE:      ns = WRITE;
            READ_ADDR:  ns = READ_ADDR;
            READ_DATA:  ns = READ_DATA;

            default:    ns = IDLE;
        endcase
    end

    //===============================
    // Data handling (datapath)
    //===============================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_data        <= 10'd0;
            rx_valid       <= 1'b0;
            bit_counter    <= 4'd0;
            read_addr_done <= 1'b0;
            MISO           <= 1'b0;
        end else begin
            rx_valid <= 1'b0; // default

            case (cs)
                IDLE: begin
                    rx_valid <= 1'b0;
                end

                CHK_CMD: begin
                    bit_counter <= 4'd10;
                end

                WRITE: begin
                    if (bit_counter > 0) begin
                        rx_data[bit_counter-1] <= MOSI;
                        bit_counter <= bit_counter - 1;
                    end else begin
                        rx_valid <= 1'b1;
                    end
                end

                READ_ADDR: begin
                    if (bit_counter > 0) begin
                        rx_data[bit_counter-1] <= MOSI;
                        bit_counter <= bit_counter - 1;
                    end else begin
                        rx_valid       <= 1'b1;
                        read_addr_done <= 1'b1;
                    end
                end

                READ_DATA: begin
                    if (tx_valid) begin
                        // Transmit path
                        rx_valid <= 1'b0;
                        if (bit_counter > 0) begin
                            MISO <= tx_data[bit_counter-1];
                            bit_counter <= bit_counter - 1;
                        end else begin
                            read_addr_done <= 1'b0;
                        end
                    end else begin
                        // Receive path
                        if (bit_counter > 0) begin
                            rx_data[bit_counter-1] <= MOSI;
                            bit_counter <= bit_counter - 1;
                        end else begin
                            rx_valid    <= 1'b1;
                            bit_counter <= 4'd8;
                        end
                    end
                end
            endcase
        end
    end
endmodule
