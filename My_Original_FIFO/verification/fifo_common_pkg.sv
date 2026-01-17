package fifo_common_pkg;
    // Global verification signals
    bit test_finished;
    
    // Error and Correct Counters
    int err_data_out = 0,   corr_data_out = 0;
    int err_ack = 0,        corr_ack = 0;
    int err_overflow = 0,   corr_overflow = 0;
    int err_full = 0,       corr_full = 0;
    int err_empty = 0,      corr_empty = 0;
    int err_almost_full = 0, corr_almost_full = 0;
    int err_almost_empty = 0, corr_almost_empty = 0;
    int err_underflow = 0,  corr_underflow = 0;
endpackage
