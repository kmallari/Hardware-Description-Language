// Code your design here

module Clock(input clk);

localparam N = 26;
reg [N-1:0] slow_clk = 0;
reg [7:0] countsec = 0;
  
wire enable;

always @ (posedge clk)
  if (slow_clk == 26'd49) slow_clk <= 8'b0;
    else  slow_clk <= slow_clk + 8'b1;

assign enable = (slow_clk == 26'd49);

always @ (posedge clk)
  if (enable == 1'b1)
    if (countsec == 8'b00111011) countsec <= 8'b0;
    else  countsec <= countsec + 8'b1;

endmodule

module digital_clock_tb;
  
  reg clk = 1'b0;
  
  always #10 clk = ~clk;
  
  digital_clock digital_clock0 (.clk(clk));
  
  initial #100000 $finish;
  
  always begin 
    #10000 $display("tick");
    #10000 $display("tock");
  end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
                           
endmodule
