`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////////////////////
// Trabajo Practico Nro. 4. MIPS.
// Memoria de programa.
// Integrantes: Kleiner Matias, Lopez Gaston.
// Materia: Arquitectura de Computadoras.
// FCEFyN. UNC.
// Anio 2018.
//////////////////////////////////////////////////////////////////////////////////////////////////



  //  Xilinx Single Port No Change RAM
  //  This code implements a parameterizable single-port no-change memory where when data is written
  //  to the memory, the output remains unchanged.  This is the most power efficient write mode.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.
module memoria_programa
    (
    i_addr,           // Address bus, width determined from RAM_DEPTH
    i_data,           // RAM input data
    i_clk,            // Clock
    i_wea,              // Write enable
    i_ena,              // RAM Enable, for additional power savings, disable port when not in use (1)
    i_rsta,             // Output reset (does not affect memory contents) (0)
    i_regcea,           // Output register enable (0)
    i_soft_reset,       // Reset via software for MIPS
    o_data,           // RAM output data
    o_reset_ack,       // Ack from memories when they complete their resets.
    o_led
    );
  
  
  parameter RAM_WIDTH = 32;                       // Specify RAM data width
  parameter RAM_DEPTH = 2048;                     // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY"
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)  
  
  localparam CANT_BIT_RAM_DEPTH = clogb2(RAM_DEPTH);  
  
  
  input [CANT_BIT_RAM_DEPTH-2:0] i_addr;  // Address bus, width determined from RAM_DEPTH
  input [RAM_WIDTH-1:0] i_data;           // RAM input data
  input i_clk;                            // Clock
  input i_wea;                              // Write enable
  input i_ena;                              // RAM Enable, for additional power savings, disable port when not in use (1)
  input i_rsta;                             // Output reset (does not affect memory contents) (0)
  input i_regcea;                           // Output register enable (0)
  input i_soft_reset;                       // Reset via software for MIPS
  output [RAM_WIDTH-1:0] o_data;          // RAM output data
  output reg o_reset_ack;                 // Ack from memories when they complete their resets.
  output reg o_led;
  
  
  reg [RAM_WIDTH - 1 : 0] BRAM [RAM_DEPTH - 1 : 0];
  reg [RAM_WIDTH - 1 : 0] ram_data = {RAM_WIDTH {1'b0}};
  reg [clogb2(RAM_DEPTH-1)-1 : 0] reg_contador;
  
  
  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
         $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH - 1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
           BRAM[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge i_clk) begin
    if (~i_soft_reset) begin
      ram_data <= 0;
      BRAM [reg_contador] <= {RAM_WIDTH{1'b0}};
      o_led <= 0;
      if ( reg_contador == (RAM_DEPTH-1) ||  (BRAM [reg_contador]=={RAM_WIDTH{1'b0}}) ) begin
        reg_contador <= reg_contador;
        o_reset_ack <= 0;
      end
      else begin
        reg_contador <= reg_contador + 1;
        o_reset_ack <= 1;
      end
    end
    else begin
      reg_contador <= 0;
      o_reset_ack <= 1;
      if (i_ena) begin
        if (i_wea)begin
          BRAM [i_addr] <= i_data;
          ram_data <= ram_data;
          if ( BRAM [i_addr] != 0) begin
            o_led <= 1;
          end
          else begin
            o_led <= o_led;
          end
        end
        else begin
          ram_data <= BRAM [i_addr];
          BRAM [i_addr] <= BRAM [i_addr];
          o_led <= o_led;
         end
     end
     else begin
        o_led <= 0;
        reg_contador <= 0;
        o_reset_ack <= 1;
        ram_data <= ram_data;
        BRAM [i_addr] <= BRAM [i_addr];
     end
    end
  end
  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign o_data = ram_data;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] reg_data_out = {RAM_WIDTH{1'b0}};

      always @(posedge i_clk)
        if (i_rsta)
          reg_data_out <= {RAM_WIDTH {1'b0}};
        else if (i_regcea)
          reg_data_out <= ram_data;

      assign o_data = reg_data_out;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
endmodule
