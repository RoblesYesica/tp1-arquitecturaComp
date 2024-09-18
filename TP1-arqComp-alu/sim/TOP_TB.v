`timescale 1ns / 1ps

module TOP_TB;

    // Parámetros
    parameter NB_DATA = 8;
    parameter NB_OP = 6;
    parameter N_TEST = 3;

    // Entradas
    reg [NB_DATA - 1 : 0] i_dataSw;
    reg [NB_OP - 1 : 0] i_opSw;
    reg i_btnA;
    reg i_btnB;
    reg i_btnO;
    reg i_clk;
    reg i_reset;

    // Salidas
    wire [NB_DATA - 1 : 0] o_resultLed;
    wire o_overflowLed;

    // Operaciones
    localparam ADD = 6'b100000;
    localparam SUB = 6'b100010;
    localparam AND = 6'b100100;
    localparam OR  = 6'b100101;
    localparam XOR = 6'b100110;
    localparam NOR = 6'b100111;
    localparam SRA = 6'b000011;
    localparam SRL = 6'b000010;
    
        reg [NB_OP-1 : 0] operation [7:0];
        integer op_cont;
        integer tests_cont;
        reg [NB_DATA-1 : 0] i_dataA;
        reg [NB_DATA-1 : 0] i_dataB;

        

    // Instancia del módulo TOP
    TOP #(
        .NB_DATA(NB_DATA),
        .NB_OP(NB_OP)
    ) uut (
        .i_dataSw(i_dataSw),
        .i_opSw(i_opSw),
        .i_btnA(i_btnA),
        .i_btnB(i_btnB),
        .i_btnO(i_btnO),
        .i_clk(i_clk),
        .i_reset(i_reset),
        .o_resultLed(o_resultLed),
        .o_overflowLed(o_overflowLed)
    );

    // Generación de reloj
always #5 i_clk = ~i_clk;


initial begin
        operation[0] = ADD;
        operation[1] = SUB;
        operation[2] = AND;
        operation[3] = OR;
        operation[4] = XOR;
        operation[5] = SRA;
        operation[6] = SRL;
        operation[7] = NOR;
        // Inicialización de señales
        i_clk = 0;
        i_reset = 0;
        i_btnA = 0;
        i_btnB = 0;
        i_btnO = 0;
        i_dataSw = 0;
        i_opSw = 0;
       // Cargar operaciones
       
        
        $display("--------------------------------------");
        $display("----------Initiating Tests------------");

        // Reset
 
        i_reset = 1;
        #5;
        i_reset = 0;
        #5;

        for (op_cont = 0; op_cont < 8; op_cont = op_cont + 1) begin
            for (tests_cont = 0; tests_cont < N_TEST; tests_cont = tests_cont + 1) begin
                
                // Generación de números aleatorios
                i_dataA = $random % 256 - 128; // Números entre -128 y 127
                i_dataB = $random % 256 - 128; // Números entre -128 y 127
                
                //Cargar los valores y operación
                i_dataSw = i_dataA;
                i_btnA = 1; 
                #10; // Espera para asegurar la lectura
                i_btnA = 0;

                i_dataSw = i_dataB;
                i_btnB = 1; 
                #10; // Espera para asegurar la lectura
                i_btnB = 0;

                i_opSw = operation[op_cont];
                i_btnO = 1; 
                #10; // Espera para asegurar que la operación se procesede
                i_btnO = 0;

                #10; // Esperar el resultado

                 //Comprobar resultados según operación
                case (i_opSw)
                    ADD: if ((i_dataA + i_dataB) != $signed(o_resultLed)) begin
                            $display("Test FAILED: ADD | %d + %d = %d (expected %d) | Overflow: %b (expected %b)", 
                                      $signed(i_dataA), $signed(i_dataB), $signed(o_resultLed), $signed(i_dataA + i_dataB), o_overflowLed, ((i_dataA + i_dataB) > 127 || (i_dataA + i_dataB) < -128));
                         end else begin
                            $display("Test PASSED: ADD | %d + %d = %d | Overflow: %b", 
                                      $signed(i_dataA), $signed(i_dataB), $signed(o_resultLed), o_overflowLed);
                         end
                    SUB: if ((i_dataA - i_dataB) != $signed(o_resultLed) ) begin
                            $display("Test FAILED: SUB | %d - %d = %d (expected %d) | Overflow: %b (expected %b)", 
                                      $signed(i_dataA), $signed(i_dataB), $signed(o_resultLed), $signed(i_dataA - i_dataB), o_overflowLed, ((i_dataA - i_dataB) > 127 || (i_dataA - i_dataB) < -128));
                         end else begin
                            $display("Test PASSED: SUB | %d - %d = %d | Overflow: %b", 
                                      $signed(i_dataA), $signed(i_dataB), $signed(o_resultLed), o_overflowLed);
                         end
                    AND: if ((i_dataA & i_dataB) != o_resultLed) begin
                            $display("Test FAILED: AND | %b & %b = %b (expected %b)", i_dataA, i_dataB, o_resultLed, (i_dataA & i_dataB));
                         end else begin
                            $display("Test PASSED: AND | %b & %b = %b", i_dataA, i_dataB, o_resultLed);
                         end
                    OR: if ((i_dataA | i_dataB) != o_resultLed) begin
                            $display("Test FAILED: OR | %b | %b = %b (expected %b)", i_dataA, i_dataB, o_resultLed, (i_dataA | i_dataB));
                        end else begin
                            $display("Test PASSED: OR | %b | %b = %b", i_dataA, i_dataB, o_resultLed);
                        end
                    XOR: if ((i_dataA ^ i_dataB) != o_resultLed) begin
                            $display("Test FAILED: XOR | %b ^ %b = %b (expected %b)", i_dataA, i_dataB, o_resultLed, (i_dataA ^ i_dataB));
                         end else begin
                            $display("Test PASSED: XOR | %b ^ %b = %b", i_dataA, i_dataB, o_resultLed);
                         end
                    NOR: if ((~(i_dataA | i_dataB)) != o_resultLed) begin
                            $display("Test FAILED: NOR | ~(%b | %b) = %b (expected %b)", i_dataA, i_dataB, o_resultLed, ~(i_dataA | i_dataB));
                         end else begin
                            $display("Test PASSED: NOR | ~(%b | %b) = %b", i_dataA, i_dataB, o_resultLed);
                         end
                    SRA: if ((i_dataA >>> i_dataB) != o_resultLed) begin
                            $display("Test FAILED: SRA | %b >>> %b = %b (expected %b)", i_dataA, i_dataB, o_resultLed, (i_dataA >>> i_dataB));
                         end else begin
                            $display("Test PASSED: SRA | %b >>> %b = %b", i_dataA, i_dataB, o_resultLed);
                         end
                    SRL: if ((i_dataA >> i_dataB) != o_resultLed) begin
                            $display("Test FAILED: SRL | %b >> %b = %b (expected %b)", i_dataA, i_dataB, o_resultLed, (i_dataA >> i_dataB));
                         end else begin
                            $display("Test PASSED: SRL | %b >> %b = %b", i_dataA, i_dataB, o_resultLed);
                         end
                    default: $display("Invalid Operation Code: %b", operation[op_cont]);
                endcase
              //   i_reset = 1;
                // #5;
                // i_reset = 0;
            end
            $display("------------Test for Operation %b Finished---------------", operation[op_cont]);
        end

       $finish;
    end
    
    
endmodule


