interface fifo_intf (input bit clk);
    parameter DATA_WIDTH = 16;
    
    // Signals connecting Testbench and DUT
    logic [DATA_WIDTH-1:0] data_in;
    logic                  rst_n;
    logic                  write_enable;
    logic                  read_enable;
    
    logic [DATA_WIDTH-1:0] data_out;
    logic                  write_ack;
    logic                  overflow;
    logic                  full;
    logic                  empty;
    logic                  almost_full;
    logic                  almost_empty;
    logic                  underflow;

    // Modports
    modport DUT (
        input  clk, data_in, rst_n, write_enable, read_enable,
        output data_out, write_ack, overflow, full, empty, almost_full, almost_empty, underflow
    );

    modport TEST (
        output data_in, rst_n, write_enable, read_enable,
        input  clk, data_out, write_ack, overflow, full, empty, almost_full, almost_empty, underflow
    );

    modport MONITOR (
        input clk, data_in, rst_n, write_enable, read_enable, 
              data_out, write_ack, overflow, full, empty, almost_full, almost_empty, underflow
    );

    // -------------------------------------------------------------------------
    // SYSTEMVERILOG ASSERTIONS (SVA) [NEW FEATURE]
    // -------------------------------------------------------------------------
    
    // 1. Safety: Overflow should assert if writing to a full FIFO
    property p_overflow_check;
        @(posedge clk) disable iff(!rst_n) 
        (full && write_enable) |-> ##1 overflow;
    endproperty
    
    assert_overflow: assert property(p_overflow_check) 
        else $error("Assertion Failed: Overflow signal missing!");

    // 2. Safety: Underflow should assert if reading from empty FIFO
    property p_underflow_check;
        @(posedge clk) disable iff(!rst_n)
        (empty && read_enable) |-> ##1 underflow;
    endproperty

    assert_underflow: assert property(p_underflow_check) 
        else $error("Assertion Failed: Underflow signal missing!");

    // 3. Functional: Write Acknowledge should rise if write is successful
    property p_ack_check;
        @(posedge clk) disable iff(!rst_n)
        (write_enable && !full) |-> ##1 write_ack;
    endproperty

    assert_ack: assert property(p_ack_check) 
        else $error("Assertion Failed: Write Acknowledge missing!");

endinterface
