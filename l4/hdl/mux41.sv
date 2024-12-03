module mux41 (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,
    input  logic [31:0] d,
    input  logic [1:0]  s,
    output logic [31:0] o
);

    assign o = (s == 2'b00) ? a :
               (s == 2'b01) ? b :
               (s == 2'b10) ? c :
               (s == 2'b11) ? d : 32'h00000000;
endmodule
