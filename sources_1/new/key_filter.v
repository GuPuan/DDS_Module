
module key_filter(
    Clk,
    Reset_n,
    Key,
    Key_P_Flag,
    Key_R_Flag
    );
    
    input Clk;
    input Reset_n;
    input Key;
    output reg Key_P_Flag;
    output reg Key_R_Flag;
    
    reg [2:0] state;
    reg [1:0] uart_rx_r;
   
   always@(posedge Clk)begin
        uart_rx_r[0] <= Key;
        uart_rx_r[1] <= uart_rx_r[0] ;
   end
   
   wire pedge_uart_rx;
    assign pedge_uart_rx = (uart_rx_r == 2'b01);
    wire nedge_uart_rx;
    assign nedge_uart_rx = (uart_rx_r == 2'b10);  
   
    reg [9:0]div_cnt;
    
    always@(posedge Clk or negedge Reset_n) begin
    if(!Reset_n)    
        div_cnt <=  0;
    else if (state == 0 || state == 1 || state == 2 || state == 3)
        div_cnt <=  div_cnt + 1'b1;
    else
        div_cnt <=  0;
    end
        
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n) begin
        state <= 0;
        Key_R_Flag <= 0;
        Key_P_Flag <= 0;    
    end
    else begin
        case(state)
            0:
                begin
                    Key_R_Flag <= 0;
                    if(nedge_uart_rx)begin                
                        state <= 1;
                        div_cnt <= 0;
                    end
                end
                
            1:
                if((div_cnt>=1000)&&(!pedge_uart_rx))begin
                    state <= 2;                    
                    Key_P_Flag <= 1;
                    div_cnt <= 0;
                end
                else if((div_cnt<1000)&&pedge_uart_rx)begin
                    state <= 0;
                    div_cnt <= 0;
                end
               
            2:
                begin
                    Key_P_Flag <= 0;
                    if(pedge_uart_rx)begin                    
                        state <= 3;
                        div_cnt <= 0;
                    end
                end
                
            3:
                if((div_cnt>=1000)&&(!nedge_uart_rx))begin
                    state <= 0;                   
                    Key_R_Flag <= 1;
                    div_cnt <= 0;
                end
                else if((div_cnt<1000)&&nedge_uart_rx)begin
                    state <= 2;
                    div_cnt <= 0;
                end
                
          default:
                state <= 0;
                
         endcase
    end
endmodule
