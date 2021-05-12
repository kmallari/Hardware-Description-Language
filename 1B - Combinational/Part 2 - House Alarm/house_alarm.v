module house_alarm(A, E, D, W);

input E, D, W; // enable, door, window
output A; // alarm

assign A = (E & ~D) | (E & ~W);

endmodule