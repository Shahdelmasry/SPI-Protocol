module master_tb;
    
    reg miso;
    reg clk;
    reg reset;
    reg start,cpol,cpha;
    reg [31:0] data_in;
    reg [3:0] dvsr;
    wire  [31:0] data_out;
    wire done;
    wire sclk;
    wire mosi;
    wire [3:0] cs;

    master uut (
        .miso(miso),
        .clk(clk),
        .reset(reset),
        .start(start),
        .cpol(cpol),
        .cpha(cpha),
        .data_in(data_in),
        .dvsr(dvsr),
        .data_out(data_out),
        .done(done),
        .sclk(sclk),
        .mosi(mosi),
        .cs(cs),
        .i(0) // Assuming a single slave for testing
    );

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        start = 0;
        cpol = 0;
        cpha = 0;
        data_in = 32'hA5A5A5A5; // Example data
        dvsr = 4'b0001; // Example divisor

        // Release reset after some time
        #10 reset = 0;

        // Start the SPI transaction
        #10 start = 1;
        miso = 1; // Simulate MISO line (can be toggled to test different scenarios)
        @(negedge sclk);
        miso = 0; // Simulate MISO line change
        @(negedge sclk);
        miso = 1; // Simulate MISO line change

        // Wait for some time to observe the outputs
        #200;

        // Finish the simulation
        $stop;
    end

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock
endmodule