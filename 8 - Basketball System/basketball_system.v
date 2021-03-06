`timescale 1ms/1ms  
module basketball_system(
    score1, score2,
    clock, PB0, PB1, PB2, PB3, PB4, SW1, SW2, SW3, SW4,
    seconds, minutes, shotclock);

    output reg[7:0] score1, score2; // 8-bit for a score up to 255
    input clock;
    input PB0; // master reset switch
    input PB1, PB2; // up-down buttons for first team
    input PB3, PB4; // up-down butons for the second team
    
    // variables for minutes and seconds
    output reg [5:0] seconds; // = d59
    output reg [3:0] minutes; // = d12
    output reg [4:0] shotclock; // = d24 
    
    input SW1; // resets general timer to 12 mins if on
               // also resets shot clock to 24 secs
    input SW2; // if on, counts down time. if off, pauses timer
    input SW3; // if on, resets shot clock to 24 secs
    input SW4; // if on, coutns down shot clock
               // if off, pauses shot clock

    always @(posedge clock or posedge PB0) begin
        if (PB0 == 1) begin
            // master reset. resets original value of shotclock,
            // seconds, minutes, and scores
            shotclock = 5'b11000;
            seconds = 8'b00111011;
            minutes = 4'b1100;
            score1 = 8'b0000_0000;
            score2 = 8'b0000_0000; // resets scores
        end else begin
            // if both buttons are pressed or not pressed,
            // nothing will happen.
            if (PB1 == 1 && PB2 == 0) score1 <= score1 + 1;
            else if (PB1 == 0 && PB2 == 1) begin
                if (score1 != 8'b0000_0000) score1 <= score1 - 1; // prevents overflow
            end
            // if both buttons are pressed or not pressed,
            // nothing will happen.
            if (PB3 == 1 && PB4 == 0) score2 <= score2 + 1;
            else if (PB3 == 0 && PB4 == 1) begin
                if (score2 != 8'b0000_0000) score2 <= score2 - 1; // prevents overflow
                
            end
            // resets timer values
            if (SW1 == 1) begin
                minutes <= 4'b1100; // sets game minutes to 12
                seconds = 6'b111011; // sets the game seconds back to 59
                shotclock = 5'b11000; // sets shotclock to 24
            end

            // starts the countdown timer
            if (SW2 == 1) begin
                // when seconds == 0, that means that a minute has passed.
                // therefore, the value of seconds is reset and the value
                // of minutes is decremented by 1.
                if (seconds == 0) begin
                    seconds = 8'b00111011;
                    if (minutes != 0) minutes <= minutes - 1;
                end 
                // decrements the value of seconds. decrements the value of
                // the shotclock if SW4 is on.
                if (SW4 == 1 && shotclock != 0) shotclock = shotclock - 1;
                seconds = seconds - 1;
            end
            // resets the value of the shotclock
            if (SW3 == 1) shotclock <= 5'b11000;
        end
    end   
endmodule

module tb_basketball();

    reg clock, PB0, PB1, PB2, PB3, PB4, SW1, SW2, SW3, SW4;
    wire [7:0] score1, score2;
    wire [5:0] seconds;
    wire [4:0] shotclock;
    wire [3:0] minutes;

    basketball_system dut(
        score1, score2,
        clock, PB0, PB1, PB2, PB3, PB4, SW1, SW2, SW3, SW4,
        seconds, minutes, shotclock);

    always #10 clock = ~clock;

    initial begin
        #1 clock = 0; #0 PB0 = 1; PB1 = 0; PB2 = 0; PB3 = 0; PB4 = 0; SW1 = 0; SW2 = 0; SW3 = 0; SW4 = 0;

        #5 PB0 = 0;

        #50 PB1 = 1; // adds to the score of team 1
        #100 PB2 = 1; #100 PB1 = 0; // removes a score from team 1
        #150 PB2 = 0;

        #150 PB3 = 1; // adds to the score of team 2
        #200 PB4 = 1; #100 PB3 = 0; // removes a score from team 2
        #250 PB4 = 0;

        #300 SW2 = 1; // turns on the game timer
        #300 SW4 = 1; // turns on the shotclock
        #800 SW3 = 1; // resets shot slock to 24s
        #900 SW3 = 0; // allows shot clock to work
        #1000 SW2 = 0; // pauses the timer
        #1000 SW4 = 0; // pauses the shotclock        

        #1050 SW1 = 1; // resets timer to 12 mins and shot clock to 24 secs
        #1100 SW1 = 0; // allows timer to start again

        #1200 $stop;
    end

endmodule
