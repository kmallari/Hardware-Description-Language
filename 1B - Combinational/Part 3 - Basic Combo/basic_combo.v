module basic_combo(f, W, X, Y, Z);

input W, X, Y, Z;
output f;

assign f = (~X & ~Z) | (X & Z) | (W & Y);

endmodule 