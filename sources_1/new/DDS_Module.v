module DDS_Module(
    Clk,
    Reset_n,
    Mode_Sel,
    Fword,
    Pword,
    Data
);
    input Clk;
    input Reset_n;
    input [1:0]Mode_Sel;
    input [31:0]Fword;
    input [11:0]Pword;
    output reg[13:0]Data;
    
    reg [31:0]Fword_r;
    always@(posedge Clk)
        Fword_r <= Fword;
    
    reg [11:0]Pword_r;
    always@(posedge Clk)
        Pword_r <= Pword; 
    
    reg [31:0]Freq_ACC;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Freq_ACC <= 0;
    else
        Freq_ACC <= Fword_r + Freq_ACC;
 
    wire [11:0]Rom_Addr;      
    assign Rom_Addr = Freq_ACC[31:20] + Pword_r;
    
    wire [13:0]Data_sine,Data_square,Data_triangular;
    rom_sine rom_sine(
      .clka(Clk),
      .addra(Rom_Addr),
      .douta(Data_sine)
    );
    
    rom_square rom_square(
      .clka(Clk),
      .addra(Rom_Addr),
      .douta(Data_square)
    ); 
     
    rom_triangular rom_triangular(
      .clka(Clk),
      .addra(Rom_Addr),
      .douta(Data_triangular)
    );  
    
    always@(*)
        case(Mode_Sel)
            0:Data = Data_sine;
            1:Data = Data_square;
            2:Data = Data_triangular;
            3:Data = 8192;
        endcase
        
endmodule