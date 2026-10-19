#!/usr/bin/env bash
set -euo pipefail

# requires iverilog and vvp to be installed
cd "$(dirname "$0")/.."
mkdir -p build
iverilog -g2012 -s tb_motor_channel -o build/motor_channel_sim \
    rtl/motor/motor_channel.v tb/tb_motor_channel.v
vvp build/motor_channel_sim
