module majority(Out1, Out2, A, B, C, D);
// 3-bit Majority Circuit

input A, B, C;
output Out1;

assign Out1 = (A & B) | (A & C) | (B & C);

// 4-bit Majority Circuit

input D; // adding D as an input
output Out2;

assign Out2 = (A & B & C) | (A & C & D) | (B & C & D) | (A & B & D);

endmodule