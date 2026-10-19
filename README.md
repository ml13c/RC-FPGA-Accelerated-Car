# RC FPGA Accelerated Car

Autonomous RC car project built around a **Digilent Nexys 4 DDR (Artix-7 FPGA)** and a **Raspberry Pi 4B**.

The FPGA is responsible for real-time sensing, motor PWM, and the eventual safety controller. The Pi handles camera-based object detection using the Sony IMX500 AI Camera and sends motion requests to the FPGA. This project is **separate from ARES** and from the FPGA video dashboard.

## Architecture

See [docs/architecture.md](docs/architecture.md) for the block diagram and design decisions.