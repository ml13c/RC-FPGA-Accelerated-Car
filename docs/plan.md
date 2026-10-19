# Build stages

| Stage | Deliverable | Hardware needed |
| --- | --- | --- |
| 1 | PWM motor channel + testbench + LED demo | Nexys 4 DDR |
| 2 | Command UART receiver + protocol testbench | Nexys 4 DDR + PC/Pi |
| 3 | Safety FSM, stale-command watchdog, simulated ranges | Nexys 4 DDR |
| 4 | Sensor decoders and a dual-channel motor top | Sensor hardware + motor driver |
| 5 | IMX500 detections to Pi command logic | Pi 4B + IMX500 |
| 6 | Controlled low-speed autonomous driving | Chassis, motors, battery, sensors |

Document completed measurements only once simulation/hardware checks have been run. This starter repo is not a claim of functioning autonomous driving.
