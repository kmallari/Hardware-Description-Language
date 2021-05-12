/* 
--Alternate Code--
module simple_alu(result, A, B, operation);

input[1:0] A; // first input
input[1:0] B; // second input
input[2:0] operation; // input to determine the operation
output[2:0] result; // answer to the operation
reg[2:0] result;

always@(A or B or operation)
	begin
		case(operation)
			3'b000: result = A & B; // AND
			3'b001: result = A | B; // OR
			3'b010: result = A + B; // addition
			3'b011: result = A * B; // multiplication
			3'b100: result = A / B; // division
		endcase
	end
endmodule */

module simple_alu(andOutput, orOutput, addOutput, mulOutput, divOutput, A, B);

input[1:0] A; // first input
input[1:0] B; // second input
output[2:0] andOutput, orOutput, addOutput, mulOutput, divOutput; // answer to the operation

assign andOutput = A & B; // AND
assign orOutput = A | B; // OR
assign addOutput = A + B; // addition
assign mulOutput = A * B; // multiplication
assign divOutput = A / B; // division
	
endmodule 