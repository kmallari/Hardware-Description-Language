`timescale 1ns/1ns

module SM1 (
    clock,reset,coin,lid,double_wash,timer,
    state[2:0]);

    input clock;
    input reset;
    input coin;
    input lid;
    input double_wash;
    input timer;
    tri0 reset;
    tri0 coin;
    tri0 lid;
    tri0 double_wash;
    tri0 timer;
    output [2:0] state;
    reg [2:0] state;
    reg [2:0] reg_state;
    reg [7:0] fstate;
    reg [7:0] reg_fstate;
    parameter idle=0,soak=1,wash1=2,rinse2=3,wash2=4,rinse1=5,spin=6,stop=7;

    initial
    begin
        reg_state <= 3'b000;
    end

    always @(posedge clock or posedge reset)
    begin
        if (reset) begin
            fstate <= idle;
            state <= 3'b000;
        end
        else begin
            fstate <= reg_fstate;
            state <= reg_state;
        end
    end

    always @(fstate or coin or lid or double_wash or timer)
    begin
        reg_state <= 3'b000;
        case (fstate)
            idle: begin
                if (coin)
                    reg_fstate <= soak;
                else
                    reg_fstate <= idle;

                reg_state <= 3'b000;
            end
            soak: begin
                if (timer)
                    reg_fstate <= wash1;
                else
                    reg_fstate <= soak;

                reg_state <= 3'b001;
            end
            wash1: begin
                if (timer)
                    reg_fstate <= rinse2;
                else
                    reg_fstate <= wash1;

                reg_state <= 3'b010;
            end
            rinse2: begin
                if ((timer & double_wash))
                    reg_fstate <= wash2;
                else if ((timer & ~(double_wash)))
                    reg_fstate <= spin;
                else
                    reg_fstate <= rinse2;

                reg_state <= 3'b011;
            end
            wash2: begin
                if (timer)
                    reg_fstate <= rinse1;
                else
                    reg_fstate <= wash2;

                reg_state <= 3'b100;
            end
            rinse1: begin
                if ((timer & double_wash))
                    reg_fstate <= spin;
                else
                    reg_fstate <= rinse1;

                reg_state <= 3'b101;
            end
            spin: begin
                if (lid)
                    reg_fstate <= stop;
                else if ((timer & ~(lid)))
                    reg_fstate <= idle;
                else
                    reg_fstate <= spin;

                reg_state <= 3'b110;
            end
            stop: begin
                if (~(lid))
                    reg_fstate <= spin;
                else
                    reg_fstate <= stop;

                reg_state <= 3'b111;
            end
            default: begin
                reg_state <= 3'bxxx;
                $display ("Reach undefined state");
            end
        endcase
    end
endmodule // SM1

// --------------------------

module tb_washingmachine();

reg clock, reset, coin, lid, double_wash, timer;
wire [2:0] state;

SM1 dut(
    clock,reset,coin,lid,double_wash,timer,
    state);

always #10 clock = ~clock;
always #15 timer = ~timer;

initial begin
    clock = 0; reset = 0; coin = 0; lid = 0; #0 double_wash = 0; timer = 1;
    #2000 $stop;
end

endmodule