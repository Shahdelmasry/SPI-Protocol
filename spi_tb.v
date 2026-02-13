module spi_tb;
    // Clock and reset
    reg clk ;
    reg reset ;
    reg start ;
   
   
    // Test data
    wire [31:0] data_out;
    reg [31:0] data_in;
    wire [3:0] done;
    
    // SPI signals
    
    
    
    // Instantiate DUT
    spi_top dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .input_data(data_in),
        .output_data(data_out),
        .control(7'b0001_000), // Example control signal (adjust as needed)
        .done(done)
        
    );
       initial clk = 0;
       always #1 clk = ~clk; // 500MHz clock
       
    initial begin
        // Initialize inputs
        reset = 0;
        start = 0;
        data_in = 32'hA5A5A5A5; // Example input data

        // Release reset after some time
        #10 reset = 1;

        // Start the SPI transaction
        #10 start = 1;

        // Wait for some time to observe the outputs
        #500;


       if (done) begin
            $display("SPI Transaction Completed");
            $display("Data Out: %h", data_out);
            $stop;
        end

        // Finish the simulation     
     
    end
endmodule