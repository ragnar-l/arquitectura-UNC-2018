 
 `timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// Trabajo Practico Nro. 4. MIPS.
// Test bench del top write back.
// Integrantes: Kleiner Matias, Lopez Gaston.
// Materia: Arquitectura de Computadoras.
// FCEFyN. UNC.
// Anio 2019.
//////////////////////////////////////////////////////////////////////////////////

module test_bench_top_write_back();
		
	// Parametros
    
    parameter CANT_REGISTROS= 32;
    parameter CANT_BITS_REGISTROS = 32;
   
	
	//Todo puerto de salida del modulo es un cable.
	//Todo puerto de estimulo o generacion de entrada es un registro.
	//  The following function calculates the address width based on specified RAM depth
    function integer clogb2;
        input integer depth;
            for (clogb2=0; depth>0; clogb2=clogb2+1)
                depth = depth >> 1;
    endfunction
    
	// ENTRADAS.
    
    reg reg_RegWrite;
    reg reg_MemtoReg;
    reg [clogb2 (CANT_REGISTROS - 1) - 1 : 0] reg_registro_destino;
    reg [CANT_BITS_REGISTROS - 1 : 0] reg_data_mem;  
    reg [CANT_BITS_REGISTROS - 1 : 0] reg_data_alu;          
    
    //SALIDAS.
    wire wire_RegWrite;
    wire [clogb2 (CANT_REGISTROS - 1) - 1 : 0] wire_registro_destino;
    wire [CANT_BITS_REGISTROS - 1 : 0] wire_data_write;
    wire wire_o_led;
    
	
	
	initial	begin
        
        reg_RegWrite = 0;
        reg_MemtoReg = 0;
        reg_registro_destino = 0;
        reg_data_mem = 0;
		reg_data_alu = 0;


        #20 reg_registro_destino = 1;
        #20 reg_RegWrite = 1;
        #20 reg_data_mem = 2;
        #20 reg_data_alu = 1;
        #20 reg_MemtoReg = 1;
        
		
		#500000 $finish;
	end
	
	

// Modulo para pasarle los estimulos del banco de pruebas.
top_write_back
    #(
        .CANT_REGISTROS (CANT_REGISTROS),
        .CANT_BITS_REGISTROS (CANT_BITS_REGISTROS)
    )
    u_top_write_back_1
    (
        .i_registro_destino (reg_registro_destino),
        .i_data_mem (reg_data_mem),
        .i_data_alu (reg_data_alu),
        .i_RegWrite (reg_RegWrite),
        .i_MemtoReg (reg_MemtoReg),
        .o_registro_destino (wire_registro_destino),
        .o_RegWrite (wire_RegWrite),
        .o_data_write (wire_data_write),
        .o_led ()
    );
   
endmodule

 
 
