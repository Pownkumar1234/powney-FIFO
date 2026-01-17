package fifo_cov_pkg;
    import fifo_item_pkg::*;
    import fifo_common_pkg::*;
    
    class fifo_cov_group;
        fifo_item cov_item = new;

        covergroup fifo_cg;
            // Basic Coverpoints
            cp_wr_en:      coverpoint cov_item.write_enable;
            cp_rd_en:      coverpoint cov_item.read_enable;
            cp_full:       coverpoint cov_item.full;
            cp_empty:      coverpoint cov_item.empty;
            cp_underflow:  coverpoint cov_item.underflow;
            cp_overflow:   coverpoint cov_item.overflow;
            
            // Cross Coverage [NEW FEATURE]
            // Did we try to write when it was full?
            cross_full_write: cross cp_full, cp_wr_en {
                ignore_bins no_write = binsof(cp_wr_en) intersect {0};
            }
            
            // Did we try to read when it was empty?
            cross_empty_read: cross cp_empty, cp_rd_en {
                ignore_bins no_read = binsof(cp_rd_en) intersect {0};
            }
            
            // Did we have Simultaneous Read and Write?
            cross_wr_rd: cross cp_wr_en, cp_rd_en;
            
        endgroup

        function new();
            fifo_cg = new();
        endfunction

        function void sample_data(fifo_item item);
            this.cov_item = item;
            fifo_cg.sample();
        endfunction
    endclass
endpackage
