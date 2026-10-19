`timescale 1ns / 1ps

module tb_motor_channel;
    reg clk = 0;
    reg rst = 1;
    reg enable = 0;
    reg reverse = 0;
    reg [7:0] duty = 0;
    wire pwm_a;
    wire pwm_b;

    // simulation-only 100 mhz clock
    always #5 clk = ~clk;

    // short period so simulation runs quickly
    motor_channel #(
        .CLK_HZ(160),
        .PWM_HZ(10)
    ) dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .reverse(reverse),
        .duty(duty),
        .pwm_a(pwm_a),
        .pwm_b(pwm_b)
    );

    task automatic check_pwm;
        input [7:0] requested_duty;
        input requested_reverse;
        input integer expected_a;
        input integer expected_b;
        integer i;
        integer count_a;
        integer count_b;
        begin
            @(negedge clk);
            duty = requested_duty;
            reverse = requested_reverse;
            enable = 1;

            // wait two entire pwm periods for the command to latch
            repeat (32) @(negedge clk);
            count_a = 0;
            count_b = 0;

            // any consecutive 16 samples cover one complete pwm period
            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                if (pwm_a) count_a = count_a + 1;
                if (pwm_b) count_b = count_b + 1;
                if (pwm_a && pwm_b)
                    $fatal(1, "both directions active");
            end

            if (count_a != expected_a || count_b != expected_b)
                $fatal(1, "wrong pwm duty: expected %0d/%0d, got %0d/%0d",
                       expected_a, expected_b, count_a, count_b);

            $display("passed: duty=%0d reverse=%b", requested_duty, requested_reverse);
        end
    endtask

    initial begin
        repeat (3) @(negedge clk);
        rst = 0;
        check_pwm(8'd0,   1'b0,  0,  0);
        check_pwm(8'd64,  1'b0,  4,  0);
        check_pwm(8'd128, 1'b0,  8,  0);
        check_pwm(8'd128, 1'b1,  0,  8);
        check_pwm(8'd255, 1'b1,  0, 16);

        // disabling the output must force both low immediately
        @(negedge clk);
        enable = 0;
        #1;
        if (pwm_a !== 1'b0 || pwm_b !== 1'b0)
            $fatal(1, "disable test failed");

        // reset must also force both outputs low immediately
        enable = 1;
        rst = 1;
        #1;
        if (pwm_a !== 1'b0 || pwm_b !== 1'b0)
            $fatal(1, "reset gating test failed");

        $display("all motor pwm tests passed");
        $finish;
    end
endmodule
