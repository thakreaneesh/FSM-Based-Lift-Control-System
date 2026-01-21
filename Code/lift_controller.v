`timescale 1ns / 1ps

module lift_controller(
    input clk,
    input reset,
    input call0,
    input call1,
    input call2,
    input bottom_sensor,
    input middle_minus_sensor,
    input middle_plus_sensor,
    input top_sensor,
    output reg motor_up,
    output reg motor_down,
    output reg indicator0,
    output reg indicator1,
    output reg indicator2
);

    // Floor encoding
    parameter FLOOR0 = 2'b00;
    parameter FLOOR1 = 2'b01;
    parameter FLOOR2 = 2'b10;

    reg [1:0] state;         // current floor (latched when sensor triggers)
    reg [1:0] target_floor;  // desired floor to move to
    reg move;

    wire at_floor0 = bottom_sensor;
    wire at_floor1 = middle_minus_sensor & middle_plus_sensor;
    wire at_floor2 = top_sensor;

    // FSM Sequential Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= FLOOR0;
            move <= 1;
            target_floor <= FLOOR0;
            motor_up <= 0;
            motor_down <= 1; // move down till bottom_sensor
        end else begin
            // Check and update current floor
            if (at_floor0) begin
                state <= FLOOR0;
                if (target_floor == FLOOR0)
                    move <= 0;
            end else if (at_floor1) begin
                state <= FLOOR1;
                if (target_floor == FLOOR1)
                    move <= 0;
            end else if (at_floor2) begin
                state <= FLOOR2;
                if (target_floor == FLOOR2)
                    move <= 0;
            end

            // Handle new call if not already moving
            if (!move) begin
                if (call0 && state != FLOOR0) begin
                    target_floor <= FLOOR0;
                    move <= 1;
                end else if (call1 && state != FLOOR1) begin
                    target_floor <= FLOOR1;
                    move <= 1;
                end else if (call2 && state != FLOOR2) begin
                    target_floor <= FLOOR2;
                    move <= 1;
                end
            end

            // Motor control
            if (move) begin
                case (target_floor)
                    FLOOR0: begin
                        motor_up <= 0;
                        motor_down <= 1;
                    end
                    FLOOR1: begin
                        if (state < FLOOR1) begin
                            motor_up <= 1;
                            motor_down <= 0;
                        end else if (state > FLOOR1) begin
                            motor_up <= 0;
                            motor_down <= 1;
                        end
                    end
                    FLOOR2: begin
                        motor_up <= 1;
                        motor_down <= 0;
                    end
                endcase
            end else begin
                motor_up <= 0;
                motor_down <= 0;
            end
        end
    end

    // Floor indicators
    always @(*) begin
        indicator0 = (state == FLOOR0);
        indicator1 = (state == FLOOR1);
        indicator2 = (state == FLOOR2);
    end

endmodule
