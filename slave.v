module slave (
    input wire sclk,clk,reset,
    input wire mosi,
    output reg miso,done,
    input wire cs     
    );


    reg [5:0] bit_cnt;
    reg mosi_reg;
    reg [31:0] rx_reg;

    

 always @(posedge sclk ) begin
      if (!reset) rx_reg <= 0; // Clear receive register on reset
       else begin
      if (!cs) begin // Active low chip select 
        rx_reg <= {rx_reg[30:0], mosi}; // Shift in MOSI data
      end
       end
      
        
 end
 always@(negedge sclk) begin
    if (!reset) begin
        bit_cnt <= 0;
        miso <= 0;
        done <= 0; // Clear done on reset
    end 
     else begin
            miso <= rx_reg[0]; // Prepare MISO for next transaction 
             bit_cnt <= bit_cnt + 1; // Increment bit count
            if (bit_cnt > 32) begin
            done <= 1; // Indicate transaction complete after 32 bits
            bit_cnt <= 0; // Reset bit count for next transaction
            miso <= 0; // Clear MISO after transaction
        end
        end 
 end
   
endmodule


