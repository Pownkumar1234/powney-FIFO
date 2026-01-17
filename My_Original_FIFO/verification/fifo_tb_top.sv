module fifo_tb_top;
    
    // Clock Generation
    bit clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (10ns period)
    end
    
    // Interface Instance
    fifo_intf intf(clk);
    
    // DUT Instance
    sync_fifo_dut dut (
        .clk(intf.clk),
        .rst_n(intf.rst_n),
        .data_in(intf.data_in),
        .write_enable(intf.write_enable),
        .read_enable(intf.read_enable),
        .data_out(intf.data_out),
        .full(intf.full),
        .empty(intf.empty),
        .almost_full(intf.almost_full),
        .almost_empty(intf.almost_empty),
        .write_ack(intf.write_ack),
        .overflow(intf.overflow),
        .underflow(intf.underflow)
    );
    
    // Testbench Instance
    fifo_tester t1 (intf);
    
    // Monitor Instance
    fifo_monitor m1 (intf);
    
    // Dump Waveforms
    initial begin
        $dumpfile("fifo_wave.vcd");
        $dumpvars(0, fifo_tb_top);
    end

endmodule
