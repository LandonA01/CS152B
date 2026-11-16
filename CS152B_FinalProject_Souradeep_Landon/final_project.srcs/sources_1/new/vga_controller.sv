`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2026 10:37:12 AM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller
(
    input logic clk_div,
    input logic button, //for testing --> not debounced because this is just for testing
    output logic HSync, VSync,
    output logic [3:0] R, G, B
    );
    logic [9:0] H_count, V_count = 0;
    
    
    
    //HSync, VSync, v_count, h_count, clk, rst, 25MHz_clk
    //640 x 480 Display
    //60 HZ --> 25 MHz clock (need to divide the 100MHz clock) 
    
    
    //Horizontal
    //Active Region: 640 pixels
    //Front Porch: 16 pixels
    //Sync Pulse: 96 pixels
    //Back Porch: 48 pixels
    //TOTAL: 800 pixels / line
    //bits: 10 bits
    
    //Vertical
    //Active Region: 480 lines
    //Front Porch: 10 lines
    //Sync Pulse: 2 lines
    //Back Porch: 33 lines
    //TOTAL: 525 lines
    //bits: 10 bits
    
    
    
    //Parameterization --> Can I parameterize this somehow, without having a million parameters?
    
    
    //H_count and V_count
    
       always_ff @(posedge clk_div) begin
        //H_count
        if(H_count > 799) begin
            H_count <= '0;
            HSync <= 1'b1;
            HSync <= 1'b0;
            end
        else begin
            HSync <= 1'b0; 
            H_count <= H_count + 1;
        end
        
        
        
        //V_count
        if (V_count > 524) begin
            V_count <= '0;
            VSync <= 1'b1;
            end
        else begin
            VSync <= 1'b0;
            V_count <= V_count + 1;
        end
    
        
    end

    logic [11:0] color_storage_testing [2:0];
    logic [1:0] test_num;
    
    assign color_storage_testing[0] = 12'b111100000000; //RED
    assign color_storage_testing[1] = 12'b000011110000; // GREEN
    assign color_storage_testing[2] = 12'b000000001111; //BLUE
    
    always_ff @(posedge clk_div) begin
        if (button) begin
            if (test_num == 2) test_num <= '0;
            else test_num <= test_num + 1;
        end
        
        if(H_count < 640  && V_count < 480) begin
            R <= color_storage_testing[test_num][11:8];
            G <= color_storage_testing[test_num][7:4];
            B <= color_storage_testing[test_num][3:0];
        end
        
    
    end
    
    
    
    
    
    //Color Assignment
    //note: can't directly assign the color cuz it's in the module declaration, can make this a clocked registered and then assign the outputs
    
    
    
    
endmodule
