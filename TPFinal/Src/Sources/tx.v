`timescale 1ns / 1ps


//////////////////////////////////////////////////////////////////////////////////////////////////
// Trabajo Practico Nro. 4. MIPS.
// Modulo tx.
// Integrantes: Kleiner Matias, Lopez Gaston.
// Materia: Arquitectura de Computadoras.
// FCEFyN. UNC.
// Anio 2018.
//////////////////////////////////////////////////////////////////////////////////////////////////



// Constantes.
`define WIDTH_WORD_TX           8              // Tamanio de palabra util enviada por trama UART.
`define CANT_BIT_STOP           2              // Cantidad de bits de parada de trama UART.


module tx(
    i_clock,
    i_rate,
    i_data_in,
    i_reset,
    i_tx_start,
    o_bit_tx,
    o_tx_done
    );

// Parametros.
parameter WIDTH_WORD_TX    = `WIDTH_WORD_TX;
parameter CANT_BIT_STOP  = `CANT_BIT_STOP;

// Local Param
localparam ESPERA = 4'b0001;
localparam START = 4'b0010;
localparam READ = 4'b0100;
localparam STOP = 4'b1000;


// Entradas - Salidas.
input i_clock;
input i_rate;
input [ WIDTH_WORD_TX - 1 : 0 ] i_data_in;       
input i_reset; 
input  i_tx_start;  
output reg o_bit_tx;  
output reg o_tx_done; 



// Registros.
reg [ 3 : 0 ] reg_state;
reg [ 3 : 0 ] reg_next_state;
reg [ 5 : 0] reg_contador_ticks;
reg [$clog2 (WIDTH_WORD_TX)  : 0] reg_contador_bits;
reg [$clog2 (CANT_BIT_STOP) : 0] reg_contador_bits_stop;




always@( posedge i_clock ) begin //Memory
     // Se resetean los registros.
    if (~ i_reset) begin
        reg_state <= 1;
        reg_contador_bits <= 0;
        reg_contador_ticks <= 0;
        reg_contador_bits_stop <= 0;
    end 

    else if (i_rate) begin
        reg_state <= reg_next_state;
       
        if (reg_state == START) begin
            // 16 ticks por bit transmitido.
            if (( (reg_contador_ticks % 15) == 0 ) && (reg_contador_ticks != 0)) begin
                reg_contador_bits <= 0;
                reg_contador_bits_stop <= 0;
                reg_contador_ticks <= 0;
            end
            else begin
                reg_contador_bits <= reg_contador_bits;
                reg_contador_bits_stop <= reg_contador_bits_stop;
                reg_contador_ticks <= reg_contador_ticks + 1;
            end
        end
        if (reg_state == READ) begin
            // 16 ticks por bit transmitido.
            // Primer bit a transmitir.
            if ((reg_contador_ticks != 0) && (reg_contador_bits == 0) && ((reg_contador_ticks % 31) == 0 )) begin
                reg_contador_bits <= reg_contador_bits + 1;
                reg_contador_bits_stop <= 0;
                reg_contador_ticks <= 0;
            end
            // Ultimo bit a transmitir.
            else if ((reg_contador_ticks != 0) && (reg_contador_bits == 7) && ((reg_contador_ticks % 14) == 0 )) begin
                reg_contador_bits <= reg_contador_bits + 1;
                reg_contador_bits_stop <= 0;
                reg_contador_ticks <= 0;
            end
            // Demas bits a transmitir.
            else if ((reg_contador_bits > 0) && (reg_contador_bits < 7) && ( (reg_contador_ticks % 15) == 0 ) && (reg_contador_ticks != 0)) begin
                reg_contador_bits <= reg_contador_bits + 1;
                reg_contador_bits_stop <= 0;
                reg_contador_ticks <= 0;
            end
            else begin
                reg_contador_bits <= reg_contador_bits;
                reg_contador_bits_stop <= 0;
                reg_contador_ticks <= reg_contador_ticks + 1;
            end
        end

        else if ( reg_state == STOP ) begin
            // 16 ticks por bit transmitido.
            if (( (reg_contador_ticks % 15) == 0 ) && (reg_contador_ticks != 0)) begin
                reg_contador_bits <= 0;
                reg_contador_bits_stop <= reg_contador_bits_stop + 1;
                reg_contador_ticks <= 0;  
            end
            else begin
                reg_contador_bits <= reg_contador_bits;
                reg_contador_bits_stop <= reg_contador_bits_stop;
                reg_contador_ticks <= reg_contador_ticks + 1;
               
            end
        end

        else begin
            reg_contador_bits <= 0;
            reg_contador_bits_stop <= 0;
            if ( reg_state == ESPERA) begin
                reg_contador_ticks <= 0;
            end
            else begin 
                reg_contador_ticks <= reg_contador_ticks + 1;
            end
        end
        
    end
    else begin
        reg_state <= reg_state;
        reg_contador_bits <= reg_contador_bits;
        reg_contador_ticks <= reg_contador_ticks;
        reg_contador_bits_stop <= reg_contador_bits_stop;
    end
end


always@( * ) begin //NEXT - STATE logic
    
    case (reg_state)
        
        ESPERA : begin
            if (i_tx_start == 1) begin
                reg_next_state = START;
            end
            else begin
                reg_next_state = ESPERA;
            end  
        end
        
        START : begin
            if (reg_contador_ticks == 15) begin
                reg_next_state = READ;             
            end
            else begin
                reg_next_state = START;
            end  
        end
        
        READ : begin
            if (reg_contador_bits == WIDTH_WORD_TX) begin
                reg_next_state = STOP;
                 
            end
            else begin
                reg_next_state = READ;
                
            end  
        end
        
        STOP : begin
            if ( reg_contador_bits_stop == CANT_BIT_STOP ) begin
                reg_next_state = ESPERA;
               
            end
            else begin
                reg_next_state = STOP;
               
            end              
        end
        
        default : begin
            reg_next_state = ESPERA;
        end
    
    endcase 
end


always@( * ) begin //Output logic
    
    case (reg_state)
        
        ESPERA : begin
            o_tx_done = 1;
            o_bit_tx = 1; 
        end
        
        START : begin
            o_tx_done = 0;
            o_bit_tx = 0;
        end
        
        READ : begin
            o_tx_done = 0;
            if (reg_contador_bits < WIDTH_WORD_TX) begin
                o_bit_tx = i_data_in [ (WIDTH_WORD_TX-1) - reg_contador_bits];
            end
            else begin
                o_bit_tx = o_bit_tx;
            end            
        end
        
        STOP : begin
            if ( reg_contador_bits_stop == CANT_BIT_STOP) begin
                o_tx_done = 1;
                o_bit_tx = 1;
            end
            else begin
                o_tx_done = 0;
                o_bit_tx = 1;
            end  
            
        end
        
        default : begin
                o_tx_done = 1;
                o_bit_tx = 1;
        end
    
    endcase 
end

endmodule