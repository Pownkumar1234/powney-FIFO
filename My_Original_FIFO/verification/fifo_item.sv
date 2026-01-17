package fifo_item_pkg;
    import fifo_common_pkg::*;
    
    class fifo_item;
        parameter DATA_WIDTH = 16;
        
        // Randomized Inputs
        rand bit [DATA_WIDTH-1:0] data_in;
        rand bit                  rst_n;
        rand bit                  write_enable;
        rand bit                  read_enable;
        
        // Outputs (to be captured)
        logic [DATA_WIDTH-1:0]    data_out;
        logic                     write_ack;
        logic                     overflow;
        logic                     full;
        logic                     empty;
        logic                     almost_full;
        logic                     almost_empty;
        logic                     underflow;

        // Constraint control knobs
        int WR_PROB;
        int RD_PROB;

        function new(int wr_prob = 70, int rd_prob = 30);
            this.WR_PROB = wr_prob;
            this.RD_PROB = rd_prob;
        endfunction

        // Constraints
        constraint reset_dist {
            rst_n dist {0:/2, 1:/98}; // Mostly active high (not reset)
        }

        constraint wr_dist {
            write_enable dist {1:=WR_PROB, 0:=(100 - WR_PROB)};
        }

        constraint rd_dist {
            read_enable dist {1:=RD_PROB, 0:=(100 - RD_PROB)};
        }
    endclass
endpackage
