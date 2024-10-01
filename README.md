# Power-Saver
Ubuntu Server Automatic Shutdown Service 
This script monitors CPU and GPU utilization and automatically shuts down the system after a prolonged period of inactivity.

## Features

* Monitors both CPU and GPU utilization.
* Configurable thresholds for CPU and GPU inactivity.
* Automatically shuts down the system after a specified period of inactivity.
* Provides a visual indication of the inactivity timer.

## Requirements

* Linux system with `systemd`
* `nvidia-smi` (if monitoring Nvidia GPUs)
* `bc` (for floating-point calculations)

## Installation

1. Copy `power_control.sh` to `/usr/bin/` and make it executable:
   ```bash
   sudo cp power_control.sh /usr/bin/
   sudo chmod +x /usr/bin/power_control.sh
2. `Copy power_control.service` to `/etc/systemd/system/`:
   ```bash
   sudo cp power_control.service /etc/systemd/system/
3. Enable and start the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable power_control.service
   sudo systemctl start power_control.service

## Configuration
Adjust the CPU_THRESHOLD and GPU_THRESHOLD values in power_control.sh to your desired levels.
Modify the inactivity_timer value in power_control.sh to change the shutdown delay (in seconds).

## Usage
Once installed and configured, the script will run in the background and automatically shut down the system when the CPU and GPU utilization remain below the defined thresholds for the specified duration.
