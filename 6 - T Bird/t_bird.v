module t_bird(switch, prev_switch, clock, one, zero, zeros, ones, zeros_temp, ones_temp, t_output);

input [2:0] switch;
output reg [2:0] prev_switch;
input clock, one, zero;
output reg [3:0] zeros, ones, zeros_temp, ones_temp;
output reg [7:0] t_output;

initial begin
	zeros = 4'b0000;
	ones = 4'b1111;
	zeros_temp = 4'b0000;
	ones_temp = 4'b1111;
end

always @(posedge clock) begin
	if (switch != prev_switch) begin // detects if there is a change with the switch value
									 // if there is a change, the it resets to default values
		zeros = 4'b0000;
		ones = 4'b1111;
		zeros_temp = 4'b0000;
		ones_temp = 4'b1111;
	end
	prev_switch = switch;
	if (switch == 3'b000) t_output = 0;
	else if (switch == 3'b001) begin
		t_output <= {zeros, zeros_temp};
		zeros_temp <= {one, zeros_temp[3:1]};
		if (zeros_temp == 4'b1111) begin
			t_output <= {zeros, zeros_temp};
			zeros_temp = 0;
		end
	end else if (switch == 3'b010) begin
		t_output <= {zeros_temp, zeros};
		zeros_temp <= {zeros_temp[2:0], one};
		if (zeros_temp == 4'b1111) begin
			t_output <= {zeros_temp, zeros};
			zeros_temp = 0;
		end
	end else if (switch == 3'b011) begin
		t_output = {zeros, zeros_temp};
		zeros_temp = {one, zeros_temp[3:1]};
		zeros = {zeros[2:0], one}
		if (zeros_temp == 4'b1111) begin
			t_output <= {zeros_temp, zeros};
			zeros_temp = 0;
			zeros = 0;
		end
	end else if (switch == 3'b100) begin
		t_output <= 8'b11111111;
	end else if (switch == 3'b101) begin
		t_output <= {ones, zeros_temp};
		zeros_temp <= {one, zeros_temp[3:1]};
		if (zeros_temp == 4'b1111) begin
			t_output <= {ones, zeros_temp};
			zeros_temp = 0;
		end
	end else if (switch == 3'b110) begin
		t_output <= {};
	end else if (switch == 3'b111) begin
		// code here
	end
end

endmodule

// --------------------------------------

module tb_tbird();

reg [2:0] switch;
reg clock, one, zero;
wire [2:0] prev_switch;
wire [3:0] zeros, ones, zeros_temp, ones_temp;
wire [7:0] t_output;

t_bird dut(switch, prev_switch, clock, one, zero, zeros, ones, zeros_temp, ones_temp, t_output);

always #10 clock = ~clock;
always #200 switch = switch + 1;

initial begin
	one = 1; zero = 0; clock = 0; switch = 0;
end

endmodule
