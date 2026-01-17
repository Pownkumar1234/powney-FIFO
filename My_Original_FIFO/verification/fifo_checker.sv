package fifo_checker_pkg;
    import fifo_item_pkg::*;
    import fifo_common_pkg::*;

    class fifo_checker;
        parameter FIFO_DEPTH = 8;
        parameter DATA_WIDTH = 16;
        
        // Reference Model State
        bit [DATA_WIDTH-1:0] ref_queue[$];
        int count;
        
        // Reference Output Signals
        bit [DATA_WIDTH-1:0] ref_data_out;
        bit                  ref_full, ref_empty;
        bit                  ref_almost_full, ref_almost_empty;
        bit                  ref_overflow, ref_underflow;
        bit                  ref_ack;

        function void check_data(fifo_item tr);
            run_reference_model(tr);
            compare_outputs(tr);
        endfunction

        function void run_reference_model(fifo_item tr);
            if (!tr.rst_n) begin
                ref_queue.delete();
                count = 0;
                ref_full = 0; ref_empty = 1;
                ref_almost_full = 0; ref_almost_empty = 0;
                ref_overflow = 0; ref_underflow = 0;
                ref_ack = 0;
                return;
            end
            
            // Default transient flags
            ref_ack = 0;
            ref_overflow = 0;
            ref_underflow = 0;

            // 1. Write Operation
            if (tr.write_enable) begin
                if (count < FIFO_DEPTH) begin
                    ref_queue.push_back(tr.data_in);
                    ref_ack = 1;
                end else begin
                    ref_overflow = 1;
                end
            end

            // 2. Read Operation
            if (tr.read_enable) begin
                if (count > 0) begin
                    ref_data_out = ref_queue.pop_front();
                end else begin
                    ref_underflow = 1;
                end
            end

            // 3. Update Count and Status Flags
            count = ref_queue.size();
            
            ref_full         = (count == FIFO_DEPTH);
            ref_empty        = (count == 0);
            ref_almost_full  = (count == FIFO_DEPTH - 2);
            ref_almost_empty = (count == 1);
        endfunction

        function void compare_outputs(fifo_item tr);
            if (tr.rst_n) begin // Only check during active operation
                if (tr.full !== ref_full) begin
                    $error("Mismatch: FULL. DUT=%b Ref=%b", tr.full, ref_full);
                    err_full++;
                end else corr_full++;

                if (tr.empty !== ref_empty) begin 
                    $error("Mismatch: EMPTY. DUT=%b Ref=%b", tr.empty, ref_empty);
                    err_empty++;
                end else corr_empty++;

                if (tr.overflow !== ref_overflow) begin
                    $error("Mismatch: OVERFLOW. DUT=%b Ref=%b", tr.overflow, ref_overflow);
                    err_overflow++;
                end else corr_overflow++;

                if (tr.underflow !== ref_underflow) begin
                    $error("Mismatch: UNDERFLOW. DUT=%b Ref=%b", tr.underflow, ref_underflow);
                    err_underflow++;
                end 
                
                // Compare data only if read happened and was valid
                if (tr.read_enable && !tr.empty) begin
                     if (tr.data_out !== ref_data_out) begin
                        $error("Mismatch: DATA_OUT. DUT=%h Ref=%h", tr.data_out, ref_data_out);
                        err_data_out++;
                     end else corr_data_out++;
                end
            end
        endfunction
    endclass
endpackage
