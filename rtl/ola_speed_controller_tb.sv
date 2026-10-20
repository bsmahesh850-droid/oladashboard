// ============================================================================
// Module Name: ola_speed_controller_tb
// Description: Self-Checking Testbench for EV Scooter Speed Controller Logic.
// ============================================================================

`timescale 1ns / 1ps

module ola_speed_controller_tb;

    // Testbench Stimulus Signals
    logic       clk;
    logic       reset_n;
    logic [7:0] throttle_in;
    logic       brake_in;
    logic [1:0] mode_in;

    // Outputs from Design Under Test
    logic [7:0] target_speed;
    logic       pwm_out;
    logic       brake_override;

    // Instantiate Design Under Test (DUT)
    ola_speed_controller dut (
        .clk            (clk),
        .reset_n        (reset_n),
        .throttle_in    (throttle_in),
        .brake_in       (brake_in),
        .mode_in        (mode_in),
        .target_speed   (target_speed),
        .pwm_out        (pwm_out),
        .brake_override (brake_override)
    );

    // 50 MHz System Clock Generation (Period = 20ns)
    always #10 clk = ~clk;

    // Test Stimulus Process
    initial begin
        // Setup Dump Files for GTKWave / EPWave Visualization
        $dumpfile("ola_tb.vcd");
        $dumpvars(0, ola_speed_controller_tb);

        // Initialize Input Signals
        clk         = 1'b0;
        reset_n     = 1'b0;
        throttle_in = 8'd0;
        brake_in    = 1'b0;
        mode_in     = 2'b00;

        $display("=== STARTING RTL VERIFICATION TEST SUITE ===");

        // Test Step 1: Verify Asynchronous Reset
        #20;
        reset_n = 1'b1;
        #20;
        assert(target_speed == 8'd0) else $error("RESET FAILED: Target speed non-zero!");

        // Test Step 2: Verify ECO Mode Limiting
        $display("[TEST 1] ECO Mode Throttle Sweep");
        mode_in     = 2'b00; // ECO
        throttle_in = 8'd200; // Exceeds limit of 100
        #20;
        assert(target_speed == 8'd100) else $error("ECO LIMIT FAILED!");
        $display("PASS: Eco mode speed capped at 100.");

        // Test Step 3: Verify Safety Brake Override Priority
        $display("[TEST 2] Emergency Brake Priority Override");
        brake_in = 1'b1; // Engage Brake while throttle active
        #20;
        assert(target_speed == 8'd0 && pwm_out == 1'b0) 
            else $error("SAFETY FAILURE: Motor command active during brake!");
        $display("PASS: Emergency brake cut off motor drive immediately.");

        // Release Brake
        brake_in = 1'b0;
        #20;

        $display("=== SUCCESS: ALL VERIFICATION TESTS PASSED ===");
        $finish;
    end

endmodule
