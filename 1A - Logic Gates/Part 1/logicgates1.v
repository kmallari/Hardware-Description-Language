module logicgates1(notOutput, andOutput, orOutput, norOutput, xorOutput, A, B); 

input A, B;
output notOutput, andOutput, orOutput, norOutput, xorOutput;

// Code for a. NOT
assign notOutput = ~A;

// Code for b. 2-input AND
assign andOutput = A & B;

// Code for c. 2-input OR
assign orOutput = A | B;

// Code for d. 2-input NOR
assign norOutput = ~(A | B);

// Code for e. 2-input XOR
xor(xorOutput, A, B);

endmodule 