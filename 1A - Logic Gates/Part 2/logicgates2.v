module logicgates2(Out1, Out2, A, B, C); 

input A, B, C;
output Out1, Out2;

assign Out1 = (A & ~B) | (B & C);
assign Out2 = (A & B) | (B & C) | (A & C);

endmodule