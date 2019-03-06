 `timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// Trabajo Practico Nro. 4. MIPS.
// Test bench del top.
// Integrantes: Kleiner Matias, Lopez Gaston.
// Materia: Arquitectura de Computadoras.
// FCEFyN. UNC.
// Anio 2019.
//////////////////////////////////////////////////////////////////////////////////

`define WIDTH_WORD_TOP          8       // Tamanio de palabra.    
`define FREC_CLK_MHZ        100.0       // Frecuencia del clock en MHZ.
`define BAUD_RATE_TOP        9600       // Baud rate.
`define CANT_BIT_STOP_TOP       2       // Cantidad de bits de parada en trama uart.
`define HALT_OPCODE             0       //  Opcode de la instruccion HALT.
`define RAM_WIDTH_DATOS        32
`define RAM_WIDTH_PROGRAMA     32
`define RAM_PERFORMANCE_DATOS    "LOW_LATENCY"
`define RAM_PERFORMANCE_PROGRAMA "LOW_LATENCY"
`define INIT_FILE_DATOS        ""
`define INIT_FILE_PROGRAMA     ""
`define RAM_DEPTH_DATOS      2048
`define RAM_DEPTH_PROGRAMA   2048
`define CANT_ESTADOS_DEBUG_UNIT 16
`define ADDR_MEM_PROGRAMA_LENGTH 11
`define ADDR_MEM_DATOS_LENGTH    11
`define LONG_INSTRUCCION       32
`define CANT_BITS_CONTROL_DATABASE_TOP 3

module test_bench_top_arquitectura();
       
   
   // Parametros
    parameter WIDTH_WORD_TOP    = `WIDTH_WORD_TOP;
    parameter FREC_CLK_MHZ      = `FREC_CLK_MHZ;
    parameter BAUD_RATE_TOP     = `BAUD_RATE_TOP;
    parameter CANT_BIT_STOP_TOP = `CANT_BIT_STOP_TOP;
    parameter HALT_OPCODE       = `HALT_OPCODE;   
    parameter RAM_WIDTH_DATOS           = `RAM_WIDTH_DATOS;
    parameter RAM_WIDTH_PROGRAMA        =  `RAM_WIDTH_PROGRAMA;
    parameter RAM_PERFORMANCE_DATOS     =  `RAM_PERFORMANCE_DATOS;
    parameter RAM_PERFORMANCE_PROGRAMA  = `RAM_PERFORMANCE_PROGRAMA;
    parameter INIT_FILE_DATOS           =   `INIT_FILE_DATOS;
    parameter INIT_FILE_PROGRAMA        =  `INIT_FILE_PROGRAMA;     
    parameter RAM_DEPTH_DATOS           =  `RAM_DEPTH_DATOS;
    parameter RAM_DEPTH_PROGRAMA        =  `RAM_DEPTH_PROGRAMA;
    parameter CANT_ESTADOS_DEBUG_UNIT   =  `CANT_ESTADOS_DEBUG_UNIT;
    parameter ADDR_MEM_PROGRAMA_LENGTH  =  `ADDR_MEM_PROGRAMA_LENGTH;
    parameter ADDR_MEM_DATOS_LENGTH     =  `ADDR_MEM_DATOS_LENGTH;
    parameter LONG_INSTRUCCION          =  `LONG_INSTRUCCION;
    parameter CANT_BITS_CONTROL_DATABASE_TOP = `CANT_BITS_CONTROL_DATABASE_TOP;
   
   //Todo puerto de salida del modulo es un cable.
   //Todo puerto de estimulo o generacion de entrada es un registro.
   
   // Entradas.
   reg clock;                                  // Clock.
   reg hard_reset;                             // Reset.
   reg uart_txd_in_reg;                        // Tx de PC.
   wire uart_rxd_out_wire;                     // Rx de PC.
   wire [3:0] wire_leds;                       // Leds de la placa.
   
   
   initial    begin
		clock = 1'b0;
		hard_reset = 1'b0; // Reset en 0. (Normal cerrado el boton del reset).
		uart_txd_in_reg = 1'b1;

		#2000 hard_reset = 1'b1; // Desactivo la accion del reset.
		
         ///// SOFT RESET /////// 1
       
       //bit de inicio
       #52080 uart_txd_in_reg = 1'b0;
       
       //primer dato - soft reset //0000 0000
       #52080 uart_txd_in_reg = 1'b0;
       #52080 uart_txd_in_reg = 1'b0;
       #52080 uart_txd_in_reg = 1'b0;
       #52080 uart_txd_in_reg = 1'b0;
       
       #52080 uart_txd_in_reg = 1'b0;
       #52080 uart_txd_in_reg = 1'b0;
       #52080 uart_txd_in_reg = 1'b0;
       #52080 uart_txd_in_reg = 1'b0;
       
       //bits de stop
       #52080 uart_txd_in_reg = 1'b1;
       #52080 uart_txd_in_reg = 1'b1;
       
       
        ///// ESPERA_PC_ACK /////// 2
      
      //bit de inicio
      #52080 uart_txd_in_reg = 1'b0;
      
      //primer dato - soft reset //0000 0001
      #52080 uart_txd_in_reg = 1'b0;
      #52080 uart_txd_in_reg = 1'b0;
      #52080 uart_txd_in_reg = 1'b0;
      #52080 uart_txd_in_reg = 1'b0;
      
      #52080 uart_txd_in_reg = 1'b0;
      #52080 uart_txd_in_reg = 1'b0;
      #52080 uart_txd_in_reg = 1'b0;
      #52080 uart_txd_in_reg = 1'b1;
      
      //bits de stop
      #52080 uart_txd_in_reg = 1'b1;
      #52080 uart_txd_in_reg = 1'b1;



         ///// SEND INSTRUCCIONES /////// 3

        // Dejo un intervalo de tiempo.
		#520080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
        //segundo dato - send instrucciones //0000 0101
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;



        /////////////////////////
        // Primera instruccion (LWU R1,B{R2})
        /////////////////////////

        // Dejo un intervalo de tiempo.
		#520080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
        //tercer dato - primera instruccion //1001 1100
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        // Dejo un intervalo de tiempo.
		#520080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
        //tercer dato - primera instruccion //0100 0001
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        // Dejo un intervalo de tiempo.
		#520080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
        //tercer dato - primera instruccion //0000 0000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        // Dejo un intervalo de tiempo.
		#520080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
        //tercer dato - primera instruccion //0000 1000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;


        


         /////////////////////////
        // Segunda instruccion (HALT)
        /////////////////////////
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;


        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;







        ///// START MIPS ///////


        // Dejo un intervalo de tiempo.
		#520080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        
        //quinto dato - start MIPS //0000 0111
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;




        // Dejo un intervalo de tiempo.
		#520080 uart_txd_in_reg = 1'b1;

        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;

        
        //quinto dato - start MIPS //0000 0111
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;
        
        
        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0001 0000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;



        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0001 1000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;


        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0010 0000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;



        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0010 1000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;


        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0011 0000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;





        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0011 1000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;
        
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;




        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0100 0000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;





        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0100 1000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;


        // Dejo un intervalo de tiempo.
        #520080 uart_txd_in_reg = 1'b1;
    
        //bit de inicio
        #52080 uart_txd_in_reg = 1'b0;
        
                
        //quinto dato - start MIPS //0100 1000
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        #52080 uart_txd_in_reg = 1'b0;
        
        //bits de stop
        #52080 uart_txd_in_reg = 1'b1;
        #52080 uart_txd_in_reg = 1'b1;





		// Prueba reset.
		#3000000 hard_reset = 1'b0; // Reset.
		#3000000 hard_reset = 1'b1; // Desactivo el reset.


		#5000000 $finish;
   end
   
   always #2.5 clock=~clock;  // Simulacion de clock.



//Modulo para pasarle los estimulos del banco de pruebas.
top_arquitectura
   #(
       .WIDTH_WORD_TOP             (WIDTH_WORD_TOP),
       .FREC_CLK_MHZ               (FREC_CLK_MHZ),
       .BAUD_RATE_TOP              (BAUD_RATE_TOP),
       .CANT_BIT_STOP_TOP          (CANT_BIT_STOP_TOP),
       .HALT_OPCODE                (HALT_OPCODE),    
       .RAM_WIDTH_DATOS            (RAM_WIDTH_DATOS),
       .RAM_WIDTH_PROGRAMA         (RAM_WIDTH_PROGRAMA),
       .RAM_PERFORMANCE_DATOS      (RAM_PERFORMANCE_DATOS),
       .RAM_PERFORMANCE_PROGRAMA   (RAM_PERFORMANCE_PROGRAMA),
       .INIT_FILE_DATOS            (INIT_FILE_DATOS),
       .INIT_FILE_PROGRAMA         (INIT_FILE_PROGRAMA),  
       .RAM_DEPTH_DATOS            (RAM_DEPTH_DATOS),
       .RAM_DEPTH_PROGRAMA         (RAM_DEPTH_PROGRAMA),
       .CANT_ESTADOS_DEBUG_UNIT    (CANT_ESTADOS_DEBUG_UNIT),
       .ADDR_MEM_PROGRAMA_LENGTH   (ADDR_MEM_PROGRAMA_LENGTH),
       .ADDR_MEM_DATOS_LENGTH      (ADDR_MEM_DATOS_LENGTH),
       .LONG_INSTRUCCION           (LONG_INSTRUCCION),
       .CANT_BITS_CONTROL_DATABASE_TOP (CANT_BITS_CONTROL_DATABASE_TOP)
    ) 
   u_top_arquitectura_1
   (
     .i_clock (clock),
     .i_reset (hard_reset),
     .uart_txd_in (uart_txd_in_reg),
     .uart_rxd_out (uart_rxd_out_wire),
     .o_leds (wire_leds)
   );
  
endmodule