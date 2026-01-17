import fifo_item_pkg::*;
import fifo_common_pkg::*;

module fifo_tester (fifo_intf.TEST intf);
    
    fifo_item tr;

    initial begin
        tr = new();
        
        // 1. Reset
        $display("[TEST] Applying Reset...");
        intf.rst_n = 0;
        intf.write_enable = 0;
        intf.read_enable = 0;
        #20;
        intf.rst_n = 1;
        $display("[TEST] Reset Released.");
        
        // 2. Directed Test: Burst Write (Fill FIFO)
        $display("[TEST] Starting Burst Write...");
        repeat(10) begin
            @(negedge intf.clk);
            intf.write_enable = 1;
            intf.read_enable = 0;
            intf.data_in = $random;
        end
        @(negedge intf.clk);
        intf.write_enable = 0; // Stop writing

        // 3. Directed Test: Burst Read (Empty FIFO)
        $display("[TEST] Starting Burst Read...");
        repeat(10) begin
            @(negedge intf.clk);
            intf.write_enable = 0;
            intf.read_enable = 1;
        end
        
        // 4. Random Test
        $display("[TEST] Starting Random Traffic...");
        repeat(2000) begin
            @(negedge intf.clk);
            assert(tr.randomize());
            intf.write_enable = tr.write_enable;
            intf.read_enable  = tr.read_enable;
            intf.data_in      = tr.data_in;
        end
        
        #100;
        test_finished = 1;
        $display("[TEST] Finished.");
    end

endmodule
