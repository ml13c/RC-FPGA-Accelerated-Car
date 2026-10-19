// reusable single motor channel for a two-input pwm direction interface
module motor_channel #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer PWM_HZ = 10_000
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       enable,
    input  wire       reverse,
    input  wire [7:0] duty,
    output wire       pwm_a,
    output wire       pwm_b
);
    // one pwm period measured in FPGA clock cycles
    localparam integer PERIOD = CLK_HZ / PWM_HZ;
    localparam integer COUNT_WIDTH = (PERIOD > 1) ? $clog2(PERIOD) : 1;

    reg [COUNT_WIDTH-1:0] counter = 0;
    reg [7:0] active_duty = 0;
    reg active_reverse = 0;

    // update speed and direction at the beginning of a new pwm period
    always @(posedge clk) begin
        if (rst) begin
            counter        <= 0;
            active_duty    <= 0;
            active_reverse <= 0;
        end else if (counter == PERIOD - 1) begin
            counter        <= 0;
            active_duty    <= duty;
            active_reverse <= reverse;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    // for an 8-bit duty input, 255 means a continuously high period
    wire [31:0] high_cycles = (active_duty * PERIOD) >> 8;
    wire pwm_active = enable && !rst &&
                      ((active_duty == 8'hFF) || (counter < high_cycles));

    // never assert forward and reverse pwm at the same time
    assign pwm_a = pwm_active && !active_reverse;
    assign pwm_b = pwm_active &&  active_reverse;
endmodule
