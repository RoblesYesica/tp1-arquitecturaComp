`timescale 1ns / 1ps

module TOP#(
    parameter NB_DATA = 8,
    parameter NB_OP = 6
    )
    (
     input wire [NB_DATA - 1 : 0] i_dataSw,   // Input switches for data
     input wire [NB_OP - 1 : 0] i_opSw,       // Input switches for operation
     input wire i_btnA,                       // Button to load dataA
     input wire i_btnB,                       // Button to load dataB
     input wire i_btnO,                       // Button to load operation
     input wire i_clk,                        // Clock signal
     input wire i_reset,                      // Reset signal
     
     output wire [NB_DATA - 1 : 0] o_resultLed, // Output result to LEDs
     output wire o_overflowLed                // Output overflow to LED
    );
    
    // Internal registers for holding the inputs and operation
    reg [NB_DATA - 1 : 0] dataA;
    reg [NB_DATA - 1 : 0] dataB;
    reg [NB_OP - 1 : 0] op;
    
    // Wires for ALU results
    wire [NB_DATA - 1 : 0] result;
    wire overflow;
    
    // ALU instance
    ALU #(
          .NB_DATA(NB_DATA),
          .NB_OP(NB_OP)
          )
     alu1 (
          .i_dataA(dataA),
          .i_dataB(dataB),
          .i_op(op),
          .o_result(result),
          .o_overflow(overflow)
         );
         
    // Sequential block for registering the inputs based on button presses
    always @(posedge i_clk) begin
        if (i_reset) begin
            dataA <= {NB_DATA{1'b0}}; // Reset dataA to 0
            dataB <= {NB_DATA{1'b0}}; // Reset dataB to 0
            op <= {NB_OP{1'b0}};      // Reset operation to 0
        end
        else begin
            if (i_btnA) begin
                dataA <= i_dataSw;     // Load dataA from switches when button A is pressed
            end
            if (i_btnB) begin
                dataB <= i_dataSw;     // Load dataB from switches when button B is pressed
            end
            if (i_btnO) begin
                op <= i_opSw;          // Load operation from switches when button O is pressed
            end
        end
    end

    // Assign ALU outputs to module outputs
    assign o_resultLed = result;
    assign o_overflowLed = overflow;

endmodule

