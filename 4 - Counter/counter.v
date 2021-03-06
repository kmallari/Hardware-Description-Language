module counter(clock, reset, direction, q);

input clock, reset, direction;
output [2:0] q;
reg [2:0] q;

always @(posedge clock)
	if (reset == 0) q <= 0;
	else
		if (direction == 1) q <= q + 1;
		else q <= q - 1;

endmodule 

module testbench();
reg clock, reset, direction;
wire [2:0] q;

mycount device_under_test(clock, reset, direction, q);

always #10 clock = ~clock; // creates clock

initial
begin
	clock = 0;
	reset = 1;
	direction = 1;
	#1 	reset = 0;
	#20	reset = 1;
	#1000 $stop; // stop simulation
end

endmodule