// ============================================================================
// Module Name: ola_speed_controller
// Description: Educational Hardware Logic Unit for Electric Scooter Speed Control.
// Features: Priority Brake Override, Multi-Mode Speed Limiting, Digital PWM Out.
// ============================================================================

module ola_speed_controller (
    input  logic       clk,             // System Clock (50 MHz)
    input  logic       reset_n,         // Active-Low Asynchronous Reset
    input  logic [7:0] throttle_in,     // Digital Throttle Input (0 - 255)
    input  logic       brake_in,        // Mechanical/Regen Brake Button Active High
    input  logic [1:0] mode_in,         // Ride Mode: 2'b00=ECO, 2'b01=NORMAL, 2'b10=SPORT
    output logic [7:0] target_speed,    // Calculated Target Speed Command
    output logic       pwm_out,         // Motor Drive PWM Pulse Output
    output logic       brake_override   // Safety High Signal when Brake Overrides Throttle
);

    // Speed Limit Register Constants (8-bit quantized values)
    localparam logic [7:0] LIMIT_ECO    = 8'd100; // Quantized limit for Eco Mode
    localparam logic [7:0] LIMIT_NORMAL = 8'd180; // Quantized limit for Normal Mode
    localparam logic [7:0] LIMIT_SPORT  = 8'd255; // Quantized limit for Sport Mode

    // Combinational Logic for Emergency Safety Override
    assign brake_override = brake_in;

    // Sequential Target Speed & Drive Logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            target_speed <= 8'd0;
            pwm_out      <= 1'b0;
        end else if (brake_in) begin
            // Safety Priority Rule: Mechanical brake immediately clears motor command
            target_speed <= 8'd0;
            pwm_out      <= 1'b0;
        end else begin
            // Ride-Mode Dependent Speed Capping Logic
            case (mode_in)
                2'b00: begin // ECO MODE
                    target_speed <= (throttle_in > LIMIT_ECO) ? LIMIT_ECO : throttle_in;
                end
                2'b01: begin // NORMAL MODE
                    target_speed <= (throttle_in > LIMIT_NORMAL) ? LIMIT_NORMAL : throttle_in;
                end
                2'b10: begin // SPORT MODE
                    target_speed <= throttle_in;
                end
                default: begin // SAFE DEFAULT FOR UNKNOWN MODES
                    target_speed <= 8'd0;
                end
            endcase

            // Motor Drive Activation Signal
            pwm_out <= (throttle_in > 8'd0) ? 1'b1 : 1'b0;
        end
    end

endmodule
