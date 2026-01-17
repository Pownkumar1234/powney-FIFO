////////////////////////////////////////////////////////////////////////////////
// Project: Synchronous FIFO Verification
// Description: RTL Design for a Synchronous First-In-First-Out Memory
// Author: pownkumar A
////////////////////////////////////////////////////////////////////////////////
module sync_fifo_dut #(parameter DATA_WIDTH = 16, parameter MEM_DEPTH = 8) (
    input  wire                  clk,
    input  wire                  rst_n,      // Active low reset
    input  wire [DATA_WIDTH-1:0] data_in,    // Data input
    input  wire                  write_enable,
    input  wire                  read_enable,
    output reg  [DATA_WIDTH-1:0] data_out,   // Data output
    output wire                  full,
    output wire                  empty,
    output wire                  almost_full,
    output wire                  almost_empty,
    output reg                   write_ack,  // Write Acknowledge
    output reg                   overflow,
    output wire                  underflow
);

    // Calculate address width based on depth
    localparam ADDR_WIDTH = $clog2(MEM_DEPTH);

    // Memory Array
    reg [DATA_WIDTH-1:0] fifo_mem [MEM_DEPTH-1:0];

    // Pointers and Counter
    reg [ADDR_WIDTH-1:0] write_ptr;
    reg [ADDR_WIDTH-1:0] read_ptr;
    reg [ADDR_WIDTH:0]   count;      // Extra bit to distinguish full/empty

    // Write Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_ptr <= 0;
            write_ack <= 0;
            overflow  <= 0;
        end
        else begin
            write_ack <= 0;
            overflow  <= 0;
            // Write operation
            if (write_enable && count < MEM_DEPTH) begin
                fifo_mem[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
                write_ack <= 1;
            end
            else if (write_enable && full) begin
                overflow <= 1;
            end
        end
    end

    // Read Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_ptr <= 0;
            data_out <= 0;
        end
        else begin
            // Read operation
            if (read_enable && count != 0) begin
                data_out <= fifo_mem[read_ptr];
                read_ptr <= read_ptr + 1;
            end
        end
    end

    // Counter Logic (Track usage)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end
        else begin
            case ({write_enable, read_enable})
                2'b10: if (!full)  count <= count + 1; // Write only
                2'b01: if (!empty) count <= count - 1; // Read only
                2'b11: begin 
                       // Simultaneous Read/Write (if not empty or full)
                       // If full: can't write, but can read -> count decrements
                       // If empty: can't read, but can write -> count increments
                       // If normal: count stays same
                       if (full) count <= count - 1;
                       else if (empty) count <= count + 1;
                end
                default: count <= count;
            endcase
        end
    end

    // Status Signal Assignments
    assign full         = (count == MEM_DEPTH);
    assign empty        = (count == 0);
    assign almost_full  = (count == MEM_DEPTH - 2); // Customized threshold
    assign almost_empty = (count == 1);
    assign underflow    = (empty && read_enable);

endmodule
