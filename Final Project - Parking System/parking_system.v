`timescale 1ns / 1ps
module parking_system( 
                    input clk, reset,
                    input sensor_entrance, sensor_exit, 
                    input [1:0] password_1, password_2,
                    output wire GREEN_LED, RED_LED
                    );
parameter IDLE = 3'b000, WAIT_PASSWORD = 3'b001, WRONG_PASS = 3'b010, RIGHT_PASS = 3'b011,PARKED = 3'b100; // states

reg[2:0] current_state, next_state;
reg[31:0] counter_wait;
reg red_temp,green_temp;

// Next state
always @(posedge clk or negedge reset) begin
    if (~reset) current_state = IDLE;
    else current_state = next_state;
end

// counter_wait
always @(posedge clk or negedge reset) begin
    if (~reset) counter_wait <= 0;
    else if (current_state == WAIT_PASSWORD) counter_wait <= counter_wait + 1;
    else counter_wait <= 0;
end

// change state
always @(*) begin
    case(current_state)
        IDLE: begin
            if (sensor_entrance == 1) next_state = WAIT_PASSWORD;
            else next_state = IDLE;
        end
        WAIT_PASSWORD: begin
            if(counter_wait <= 3) next_state = WAIT_PASSWORD;
            else begin
                if ((password_1 == 2'b01) && (password_2 == 2'b10)) next_state = RIGHT_PASS;
                else next_state = WRONG_PASS;
            end
        end
        WRONG_PASS: begin
            if ((password_1 == 2'b01) && (password_2 == 2'b10)) next_state = RIGHT_PASS;
            else next_state = WRONG_PASS;
        end
        RIGHT_PASS: begin
            if (sensor_entrance == 1 && sensor_exit == 1) next_state = PARKED;
            else if (sensor_exit == 1) next_state = IDLE;
            else next_state = RIGHT_PASS;
        end
        PARKED: begin
            if ((password_1 == 2'b01) && (password_2 == 2'b10)) next_state = RIGHT_PASS;
            else next_state = PARKED;
        end
        default: next_state = IDLE;
    endcase
end

// LEDs and output, change the period of blinking LEDs here
always @(posedge clk) begin 
    case (current_state)
        IDLE: begin
            green_temp = 1'b0;
            red_temp = 1'b0;
        end
        WAIT_PASSWORD: begin
            green_temp = 1'b0;
            red_temp = 1'b1;
        end
        WRONG_PASS: begin
            green_temp = 1'b0;
            red_temp = ~red_temp; // blink the LED
        end
        RIGHT_PASS: begin
            green_temp = ~green_temp;
            red_temp = 1'b0;
        end
        PARKED: begin
            green_temp = 1'b0;
            red_temp = ~red_temp;
        end
    endcase
end
assign RED_LED = red_temp  ;
assign GREEN_LED = green_temp;

endmodule

// ===================================

`timescale 1ns / 1ps
module tb_parking_system;

// Inputs
    reg clk;
    reg reset;
    reg sensor_entrance;
    reg sensor_exit;
    reg [1:0] password_1;
    reg [1:0] password_2;

    // Outputs
    wire GREEN_LED;
    wire RED_LED;

    parking_system dut (
                    .clk(clk), 
                    .reset(reset), 
                    .sensor_entrance(sensor_entrance), 
                    .sensor_exit(sensor_exit), 
                    .password_1(password_1), 
                    .password_2(password_2), 
                    .GREEN_LED(GREEN_LED), 
                    .RED_LED(RED_LED) 
                    );
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    initial begin
    // Initialize Inputs
        reset = 0;
        sensor_entrance = 0;
        sensor_exit = 0;
        password_1 = 0;
        password_2 = 0;
        // Wait 100 ns for global reset to finish
        #100 reset = 1;

        #20 sensor_entrance = 1;

        #1000;
        sensor_entrance = 0;
        password_1 = 1;
        password_2 = 2;

        #2000;
        sensor_exit =1;

        #2100 $stop;
    end

endmodule