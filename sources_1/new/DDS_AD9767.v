`timescale 1ns / 1ps

module DDS_AD9767(
    Clk,
    Reset_n,
    Mode_SelA,
    Mode_SelB,
    DataA,
    ClkA,
    WRTA,
    DataB,
    WRTB,
    ClkB,
    Key
);
   input Clk;
   input Reset_n;
   input [1:0]Mode_SelA;
   input [1:0]Mode_SelB;
   input [3:0]Key;
   output [13:0]DataA;
   output ClkA;
   output WRTA;
   output [13:0]DataB;
   output ClkB;
   output WRTB;
   
   wire CLK125M;
   reg [31:0]FwordA,FwordB;
   reg [11:0]PwordA,PwordB;
   
   MMCM MMCM
   (
    .clk_out1(CLK125M),     // output clk_out1
    .resetn(Reset_n), // input resetn
    .locked(),       // output locked
    .clk_in1(Clk)
    );      
    
   assign ClkA = CLK125M;
   assign ClkB = CLK125M;
   assign WRTA = ClkA;
   assign WRTB = ClkB;
    
   
    
 wire [3:0]Key_Flag;
 
 key_filter key_filter0(
    .Clk(CLK125M),
    .Reset_n(Reset_n),
    .Key(Key[0]),
    .Key_P_Flag(Key_Flag[0]),
    .Key_R_Flag()
);   
    
 key_filter key_filter1(
    .Clk(CLK125M),
    .Reset_n(Reset_n),
    .Key(Key[1]),
     .Key_P_Flag(Key_Flag[1]),
    .Key_R_Flag()
); 

 key_filter key_filter2(
    .Clk(CLK125M),
    .Reset_n(Reset_n),
    .Key(Key[2]),
     .Key_P_Flag(Key_Flag[2]),
    .Key_R_Flag()
); 

 key_filter key_filter3(
    .Clk(CLK125M),
    .Reset_n(Reset_n),
    .Key(Key[3]),
     .Key_P_Flag(Key_Flag[3]),
    .Key_R_Flag()
);  

    reg [2:0]CHA_Fword_Sel;
    reg [2:0]CHB_Fword_Sel;

    reg [2:0]CHA_Pword_Sel;
    reg [2:0]CHB_Pword_Sel;

    always@(posedge CLK125M or negedge Reset_n)    
    if(!Reset_n)
        CHA_Fword_Sel <= 5;
    else if(Key_Flag[0])
        CHA_Fword_Sel <= CHA_Fword_Sel + 1'd1;
        
    always@(posedge CLK125M or negedge Reset_n)    
    if(!Reset_n)
        CHB_Fword_Sel <= 5;
    else if(Key_Flag[1])
        CHB_Fword_Sel <= CHB_Fword_Sel + 1'd1;     

    always@(posedge CLK125M or negedge Reset_n)    
    if(!Reset_n)
        CHA_Pword_Sel <= 0;
    else if(Key_Flag[2])
        CHA_Pword_Sel <= CHA_Pword_Sel + 1'd1;
        
    always@(posedge CLK125M or negedge Reset_n)    
    if(!Reset_n)
        CHB_Pword_Sel <= 0;
    else if(Key_Flag[3])
        CHB_Pword_Sel <= CHB_Pword_Sel + 1'd1;

    always@(*)
        case(CHA_Fword_Sel)
            0:FwordA = 86;//2**32 / 50000000;  85.89934592
            1:FwordA = 859;//2**32 / 5000000;
            2:FwordA = 8590;//2**32 / 500000;
            3:FwordA = 85899;//2**32 / 50000;
            4:FwordA = 858993;//2**32 / 5000;
            5:FwordA = 8589935;//2**32 / 500;
            6:FwordA = 85899346;//2**32 / 50;
            7:FwordA = 429496730;//2**32 / 10;
        endcase
        
    always@(*)
        case(CHB_Fword_Sel)
            0:FwordB = 86;//2**32 / 50000000;  85.89934592
            1:FwordB = 859;//2**32 / 5000000;
            2:FwordB = 8590;//2**32 / 500000;
            3:FwordB = 85899;//2**32 / 50000;
            4:FwordB = 858993;//2**32 / 5000;
            5:FwordB = 8589935;//2**32 / 500;
            6:FwordB = 85899346;//2**32 / 50;
            7:FwordB = 429496730;//2**32 / 10;
        endcase  
        
    always@(*)
        case(CHA_Pword_Sel)
            0:PwordA = 0;   //0
            1:PwordA = 341; //30
            2:PwordA = 683; //60
            3:PwordA = 1024;    //90
            4:PwordA = 1707;    //150
            5:PwordA = 2048;    //180
            6:PwordA = 3072;    //270
            7:PwordA = 3641;    //320
        endcase 

    always@(*)
        case(CHB_Pword_Sel)
            0:PwordB = 0;   //0
            1:PwordB = 341; //30
            2:PwordB = 683; //60
            3:PwordB = 1024;    //90
            4:PwordB = 1707;    //150
            5:PwordB = 2048;    //180
            6:PwordB = 3072;    //270
            7:PwordB = 3641;    //320
        endcase
        
     DDS_Module DDS_ModuleA(
        .Clk(CLK125M),
//        .Reset_n(Key_Flag[0] & Key_Flag[2]),
         .Reset_n(Reset_n),
        .Mode_Sel(Mode_SelA),
        .Fword(FwordA),
        .Pword(PwordA),
        .Data(DataA)
    );
    
   DDS_Module DDS_ModuleB(
        .Clk(CLK125M),
//        .Reset_n(Key_Flag[1] & Key_Flag[3] ),
        .Reset_n(Reset_n),
        .Mode_Sel(Mode_SelB),
        .Fword(FwordB),
        .Pword(PwordB),
        .Data(DataB)
    ); 
endmodule
