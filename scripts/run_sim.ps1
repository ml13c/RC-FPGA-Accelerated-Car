# requires Icarus Verilog (iverilog.exe and vvp.exe) on PATH
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$build = Join-Path $root "build"
New-Item -ItemType Directory -Force -Path $build | Out-Null
& iverilog -g2012 -s tb_motor_channel -o (Join-Path $build "motor_channel_sim.vvp") `
    (Join-Path $root "rtl/motor/motor_channel.v") `
    (Join-Path $root "tb/tb_motor_channel.v")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& vvp (Join-Path $build "motor_channel_sim.vvp")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
