# Hardware and integration notes

## Hardware we can work with now

- Digilent Nexys 4 DDR / Xilinx Artix-7 XC7A100T FPGA board
- Raspberry Pi 4B
- Sony IMX500 AI Camera

**Not yet assumed purchased or installed:** chassis, DC motors, dual motor driver, additional ultrasonic sensors, LiDAR, and batteries. Exact part selection and wiring can be finalized after the parts arrive.

## Stage 1: no external motor connections

Only connect the Nexys board to your computer for simulation, programming and LEDs. Test the PWM using onboard LED0 and LED1.

## Later, before connecting components

- Verify the **exact Nexys board revision**. The packaged XDC is for the **Nexys 4 DDR Rev. C** (not a plain Nexys 4 Rev. B).
- FPGA Pmod I/O is **3.3 V**. Never feed 5 V sensor outputs directly into it. Verify every sensor's voltage level and use level shifting as needed.
- Share an appropriate **ground reference** between boards when interfacing; do not tie arbitrary supply rails together.
- Do not drive DC motors or their power supply from FPGA GPIO pins. Use a motor driver and independently rated motor power supply.
- The proposed MDD3A accepts two PWM-style directional controls for each motor channel; its actual wiring, logic and current ratings need to be checked against the specific driver board you obtain.
- Implement a watchdog, command validity checks, startup disabled state, and direction-change safety before operating physical motors.
- Start vehicle tests with the wheels off the ground and a means to disconnect motor power.

## Reference pin constraints

Digilent official board XDC: https://github.com/Digilent/digilent-xdc/blob/master/Nexys-4-DDR-Master.xdc

The starter constraints use E3 clock, N17 center button, SW0..SW7 and LED0..LED1 pins from the Nexys 4 DDR master XDC.
