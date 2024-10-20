`timescale 1ns / 1ns

module DDS_AD9767_tb;
    // Inputs
    reg Clk;
    reg Reset_n;
    reg [1:0] Mode_SelA;
    reg [1:0] Mode_SelB;
    reg [3:0] Key;
    
    // Outputs
    wire [13:0] DataA;
    wire ClkA;
    wire WRTA;
    wire [13:0] DataB;
    wire ClkB;
    wire WRTB;
    
    // Instantiate the Unit Under Test (UUT)
    DDS_AD9767 uut (
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Mode_SelA(Mode_SelA),
        .Mode_SelB(Mode_SelB),
        .Key(Key),
        .DataA(DataA),
        .ClkA(ClkA),
        .WRTA(WRTA),
        .DataB(DataB),
        .ClkB(ClkB),
        .WRTB(WRTB)
    );
    
    // Clock generation
     initial Clk = 1;
    always#10 Clk = ~Clk;
    
    // Test stimulus
    initial begin
        // Initialize Inputs
        Reset_n = 0;
        Mode_SelA = 2'b00;
        Mode_SelB = 2'b00;
        Key = 4'b1111;
        
        #201;
        Reset_n = 1;
        
        Key = 4'b0111;
        #10000;
        
        Key = 4'b1111;
        #10000;
        
         Key = 4'b1101;
        #10000;
        
        Key = 4'b1111;
        #10000;
        
        #30000;
        
        Mode_SelA = 2'b10;
        Mode_SelB = 2'b10;       
        #30000;
               
        $stop;
    end
    
endmodule