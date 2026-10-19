# RC FPGA Accelerated Car

Autonomous RC car project built around a **Digilent Nexys 4 DDR (Artix-7 FPGA)** and a **Raspberry Pi 4B**.

The FPGA is responsible for real-time sensing, motor PWM, and the eventual safety controller. The Pi handles camera-based object detection using the Sony IMX500 AI Camera and sends motion requests to the FPGA. This project is **separate from ARES** and from the FPGA video dashboard.

## Architecture

See [docs/architecture.md](docs/architecture.md) for the block diagram and design decisions.

## Current progress

**Stage 1 (starter):** a bidirectional PWM module, simulation testbench, and an onboard LED demonstration. Source files are included but have **not** been tested on your physical FPGA in this package.

The UART receiver, sensor decoders, safety FSM, Pi software and physical motor interface are planned next—not implemented yet.

## Repository layout

```text
rtl/motor/                Reusable motor PWM module
rtl/top/                  Nexys 4 DDR LED demo top level
tb/                       Verilog simulation testbench
constraints/              Nexys 4 DDR board constraints
docs/                     Architecture, setup and hardware notes
software/raspberry_pi/    Pi-side software (future)
scripts/                 Optional simulation commands
```

## First test: FPGA-only motor PWM

1. In **Vivado**, create a new RTL project and select the device for your **Nexys 4 DDR, XC7A100T** (confirm the part marking / board revision).
2. Add `rtl/motor/motor_channel.v` and `rtl/top/motor_demo_top.v` as design sources.
3. Add `tb/tb_motor_channel.v` as a simulation source, with `tb_motor_channel` as the simulation top.
4. Run **Behavioral Simulation**. Look for `all motor pwm tests passed`.
5. Add `constraints/nexys4ddr.xdc` and set `motor_demo_top` as the synthesis top.
6. Generate the bitstream and program the FPGA. No external motors or driver should be connected yet.
7. Turn on **SW0** to enable. **SW1** selects direction, **SW2–SW7** select duty, **BTNC** resets. **LED0/LED1** display the two PWM directions.

Alternatively, with Icarus Verilog installed, run `bash scripts/run_sim.sh` (or `scripts/run_sim.ps1` in PowerShell).

### Why begin here?

We can verify PWM generation, command latching, direction exclusivity and output disabling with hardware already on hand. Later, the same channel module can control both left and right motor channels through a motor-driver board.

## Roadmap

1. [x] Starter PWM RTL, demonstration top and testbench added
2. [ ] Run simulation and FPGA LED demonstration
3. [ ] Pi ↔ FPGA UART command interface
4. [ ] Safety/obstacle controller and communication watchdog
5. [ ] Dual-motor integration, ultrasonic ranging and low-speed tests
6. [ ] Integrate IMX500 detections into driving decisions

See [docs/hardware-notes.md](docs/hardware-notes.md) before connecting any external hardware.
