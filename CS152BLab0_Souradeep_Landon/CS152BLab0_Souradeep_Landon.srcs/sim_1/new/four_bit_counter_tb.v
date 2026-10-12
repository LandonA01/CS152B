`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2026 11:11:52 AM
// Design Name: 
// Module Name: four_bit_counter_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module four_bit_counlater_tb;
    
    
    reg clk;
    reg rst;
    wire [3:0] count;
    
    four_bit_counter #(.CLOCK_DIV_FACTOR(10)) counter_dut
    (
    .clk(clk),
    .rst(rst),
    .count(count)
    );
    
    
    always begin
    #5 clk = ~clk;
    end
    
    
    initial begin
    clk = 0;
    rst = 1;
    #1;
    rst = 0;
    //delay until the 16th count
    repeat (16) begin
    @(posedge counter_dut.clk_div);
    #1;
    end
    if (count != 4'b0000)  
        $display("ERROR: expected count is 4'b0000, actual count = %04b", count);
    
    
    repeat(7) begin
    @(posedge counter_dut.clk_div);
    #1;
    end
    if (count != 4'b0111)  
        $display("ERROR: expected count is 4'b0111, actual count = %04b", count);
    
    
    rst = 1;
    #1;
    rst = 0;
    
    
    repeat(10) begin
    @(posedge counter_dut.clk_div);
    #1;
    end
    rst = 1;
      @(posedge counter_dut.clk_div);
      #1;
    if (count != 4'b0000)
        $display("ERROR: expected count is 4'b0000, actual count = %04b", count);
        
        
      rst = 0;
        //Asynchronous reset while clock is LOW
        //prove that reset doesn't need to wait for a clock edge
     repeat (5) begin
       @(posedge counter_dut.clk_div);
       #1;
     end
       @(negedge counter_dut.clk_div);
       rst = 1;
       #1;
       if (count != 4'b0000)
        $display("ERROR: expected count is 4'b0000, actual count = %04b", count);
       rst = 0;     
   
       // Verify counting resumes normally after reset is released
       
       #1;
       rst = 1;
       #1;
       rst = 0;
       
       if (count != 4'b0000)
        $display("ERROR: expected count is 4'b0000, actual count = %04b", count);
       
        @(posedge counter_dut.clk_div);
        #1;
        if (count != 4'b0001)
        $display("ERROR: expected count is 4'b0001, actual count = %04b", count);
        
        @(posedge counter_dut.clk_div);
        #1;
        if (count != 4'b0010)
        $display("ERROR: expected count is 4'b0010, actual count = %04b", count);
         
        @(posedge counter_dut.clk_div);
        #1;
        if (count != 4'b0011)
        $display("ERROR: expected count is 4'b0011, actual count = %04b", count);
        
        
    //multi-cycle reset
    rst = 1;
    #1;
    if (count != 4'b0000)
            $display("ERROR: expected count is 4'b0000, actual count = %04b", count);
    repeat(3) begin
    @(posedge counter_dut.clk_div);
    #1;
    if (count != 4'b0000)
            $display("ERROR: expected count is 4'b0000, actual count = %04b", count);
    end       


  
    $finish;
    end

    //TEST CASES
    
    //1. Overflow happens properly
    //2. The count is what we expec4t it to be at some given cycle
    //3. On a reset, we reset properly
   
    
endmodule
