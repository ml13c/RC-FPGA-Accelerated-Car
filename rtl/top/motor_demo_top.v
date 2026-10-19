// nexys 4 ddr stage 1: drive onboard leds with the pwm channel
module motor_demo_top (
    input  wire       CLK100MHZ,
    input  wire       BTNC,
    input  wire [7:0] SW,
    output wire [1:0] LED
);
    motor_channel #(
        .CLK_HZ(100_000_000),
        .PWM_HZ(10_000)
    ) motor_test (
        .clk(CLK100MHZ),
        .rst(BTNC),
        .enable(SW[0]),
        .reverse(SW[1]),
        .duty({SW[7:2], 2'b00}),
        .pwm_a(LED[0]),
        .pwm_b(LED[1])
    );
endmodule
