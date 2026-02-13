module master (
    input miso,
    input clk,
    input reset,
    input start,cpol,cpha,
    input [31:0] data_in,
    input [3:0] dvsr,
    output  [31:0] data_out,
    input done,
    output reg sclk,
    output reg mosi=0,
    output reg [3:0] cs=4'b1111, // Assuming 4 slaves, active low
    input i);


    reg [4:0] c_reg, c_next;     
    reg [31:0] si_reg,si_next;      
    reg [31:0] so_reg,so_next;          
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [4:0] n_reg, n_next;
          
       

 // Parameters for state machine
 parameter IDLE = 2'b00;
 parameter p0 = 2'b01;
 parameter p1 = 2'b10;
 wire pclk,sclk_c;
//sclock generation
  assign pclk = (next_state == p1 && ~cpha) || (next_state == p0 && cpha);
  assign sclk_c = cpol ? ~pclk : pclk;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            sclk <= cpol; // Idle state of SCLK based on CPOL
        end else begin
            sclk <= sclk_c;
        end
    end
  
  assign data_out = si_reg;
// State register update
 always @(posedge clk or negedge reset) begin

    if (!reset) begin 
        current_state<=IDLE;
        so_reg <= 0;
        si_reg <= 0;
        n_reg <= 0;
        c_reg <= 0;
        
    end 
    else if (start) begin 
        current_state <= next_state;
        so_reg <= so_next;
        si_reg <= si_next;
        n_reg <= n_next;
        c_reg <= c_next;
    end
   
 end
 always@(posedge sclk) begin 
    if (start) 
        begin mosi <= so_reg[31];
    end
 end
 // State transition logic    
 always @(*) begin
    if(!reset) begin
        next_state = IDLE;
            so_next = 0;
            si_next = 0;
            n_next = 0;
            c_next = 0;
    end
    else begin
    case (current_state)
        IDLE: begin
        if (start) begin
           cs[i]= 0;
           n_next = 0;
           c_next = 0;
           so_next = data_in;
           next_state = p0;
        end
        else begin
           next_state = IDLE;
        end
        end
        p0: begin
        if (c_reg == dvsr) begin // posedge of sclk
            c_next = 0;
            cs[i]= 0;
            next_state = p1;
            si_next = {si_reg[30:0], miso}; // Shift in MISO
        end
        else begin
            c_next = c_reg + 1;
            si_next = si_reg;
            next_state = p0;
        end
        end
        p1: begin
              cs[i]= 0;
            if (c_reg == dvsr) begin // negedge of sclk
                if (n_reg == 31) begin
                    next_state = IDLE;    
                end
                else if (!done) begin
                    so_next = {so_reg[30:0], 1'b0}; // Shift out MOSI
                    n_next = n_reg + 1;
                    c_next = 0;
                    next_state = p0;
                end
                else begin
                        next_state = p1; // Wait for done signal
                    end  
            end
            else begin
                c_next = c_reg + 1;
                next_state = p1;
              end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
    end
 end

endmodule
