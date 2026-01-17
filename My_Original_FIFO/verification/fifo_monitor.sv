module fifo_monitor (fifo_intf.MONITOR intf);
    import fifo_item_pkg::*;
    import fifo_cov_pkg::*;
    import fifo_checker_pkg::*;
    import fifo_common_pkg::*;

    fifo_item       mon_item = new;
    fifo_cov_group  mon_cov  = new;
    fifo_checker    mon_chk  = new;

    initial begin
        forever begin
            // Sample on negative edge to ensure stability or just after posedge
            @(negedge intf.clk);
            
            mon_item.data_in      = intf.data_in;
            mon_item.rst_n        = intf.rst_n;
            mon_item.write_enable = intf.write_enable;
            mon_item.read_enable  = intf.read_enable;
            mon_item.data_out     = intf.data_out;
            mon_item.write_ack    = intf.write_ack;
            mon_item.overflow     = intf.overflow;
            mon_item.full         = intf.full;
            mon_item.empty        = intf.empty;
            mon_item.almost_full  = intf.almost_full;
            mon_item.almost_empty = intf.almost_empty;
            mon_item.underflow    = intf.underflow;

            if (mon_item.rst_n) begin
                fork
                    mon_cov.sample_data(mon_item);
                    mon_chk.check_data(mon_item);
                join
            end

            if (test_finished) begin
               $display("----------------------------------------------------------------");
               $display("Verification Report:");
               $display("Data Match:     %0d | Errors: %0d", corr_data_out, err_data_out);
               $display("Overflow Match: %0d | Errors: %0d", corr_overflow, err_overflow);
               $display("Full Match:     %0d | Errors: %0d", corr_full, err_full);
               $display("Empty Match:    %0d | Errors: %0d", corr_empty, err_empty);
               $display("----------------------------------------------------------------");
               $stop;
            end
        end
    end
endmodule
