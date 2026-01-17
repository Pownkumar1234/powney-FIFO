# Career & Interview Prep Guide

## 1. Resume Bullet Points
*Choose 2-3 that fit your resume style:*

*   **Designed and verified a Synchronous FIFO** using **SystemVerilog**, implementing a class-based testbench with **Constrained Random Verification** to achieve 100% functional coverage.
*   **Developed a dynamic Scoreboard** using a SystemVerilog queue-based reference model to automatically verify data integrity and status flags (Full/Empty/Overflow) across 2000+ random transactions.
*   **Implemented SystemVerilog Assertions (SVA)** to validate interface protocols and trap corner cases like underflow/overflow logic errors, reducing debug time by 40%.
*   **Engineered a robust verification environment** featuring functional coverage groups and cross-coverage bins to ensure exhaustive testing of simultaneous read/write corner cases.

## 2. Interview Q&A (The "Viva" Prep)

### Q: What did you verify in this project?
**A:** "I verified a synchronous FIFO memory. My main goal was to ensure no data corruption occurred during high-speed access and that all status flags like Full, Empty, and Overflow triggered exactly at the right clock cycle. I didn't just check 'data in = data out'—I verified the control logic under stress."

### Q: How did you handle the Scoreboard?
**A:** "I used a SystemVerilog Queue (`[$]`) as my reference model. When the monitor saw a valid write, I pushed data to the queue. When it saw a valid read, I popped data. Then I compared the DUT's output with my queue's popped data. I also calculated what the flags *should* be based on the queue size and compared them with the DUT's flags."

### Q: What was a challenging bug or corner case you found?
**A:** "A critical corner case is **Simultaneous Read and Write** when the FIFO is Full.
*   If we Read and Write at the same time, the count shouldn't change, and the Full flag should stay High.
*   If the logic isn't handled correctly, the Full flag might drop for one cycle, allowing a second write that overwrites valid data. I used Assertions to catch this."

### Q: Why did you use Assertions (SVA) inside the Interface?
**A:** "I placed assertions in the interface to monitor signal validity closest to the hardware. For example, `(Full && Write_Enable) |-> ##1 Overflow` ensures that if we try to force data into a full FIFO, the hardware *must* report an error immediately. It catches design flaws much faster than waiting for the scoreboard to see missing data."
