module shift_register_74194(d, clk, en, rst, ql, qr);

parameter N = 4; // number of bits the output will be

input d, clk, en, rst;          	
output reg [N-1:0] qr, ql;

initial ql = 0;
always @(posedge clk)
  if (!rst) ql <= 0;
  else
  if (en)
    ql <= {ql[N-2:0], d};

initial qr = 0;
always @(posedge clk)
  if(!rst) qr <= 0;
  else
    if (en)
      qr <= {d, qr[N-1:1]};
    
endmodule 


module testbench();
parameter N = 4;
reg d, clk, en, rst;
wire [N-1:0] qr, ql;

shift_register_74194 device_under_test(d, clk, en, rst, ql, qr);

always #10 clk = ~clk;

initial begin
  d = 1; clk = 0; en = 0; rst = 1;
end

initial begin
  #1 rst = 0;
  #1 en = 0;
  #20 en = 1;
  #20 rst = 1;
  #100 rst = 0;
  #110 rst = 1;
  #110 d = 0;
  #50 en = 0;
  repeat(20) @ (posedge clk)
    d <= ~d;
   
  repeat(20) @ (posedge clk);
  
  #1000 $stop; // stop the simulation
end

endmodule
