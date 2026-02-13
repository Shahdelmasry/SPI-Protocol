 module spi_top (
    
    input clk,
    input reset,
    input start,
    input [31:0] input_data,
    input [6:0] control,
    output [31:0] output_data,
    output [3:0] done
    );
    wire mosi,sclk,cpha,cpol,i;
    wire [3:0] miso,cs,dvsr;
    
    // Control signal assignments
    assign i = control[0];
    assign cpha = control[1];
    assign cpol = control[2];
    assign dvsr = control[6:3];
 
    // Master Interface
    master  master0 (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_out(output_data),
        .data_in(input_data),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso[i]),  
        .cs(cs),
        .cpha(cpha),
        .cpol(cpol),
        .done(done[i]),
        .i(i),
        .dvsr(dvsr)
    );
    // Slave 0
    slave slave0 (
        .reset(reset),
        .clk(clk),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso[0]),
        .cs(cs[0]), 
        .done(done[0])           
    );

    // Slave 1
    slave slave1 (
        .reset(reset),
        .clk(clk),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso[1]),
        .done(done[1]),
        .cs(cs[1])
        
    );

    // Slave 2
    slave slave2 (
        .reset(reset),
        .done(done[2]),
        .clk(clk),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso[2]),
        .cs(cs[2])      
    );
    slave slave3 (
        .reset(reset),
        .done(done[3]),
        .clk(clk),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso[3]),
        .cs(cs[3])
    );
endmodule
