#!/bin/bash

# Define the thresholds for CPU/GPU utilization (adjust as needed)
CPU_THRESHOLD=5.0   # Adjust as needed (percentage)
GPU_THRESHOLD=0     # Adjust as needed (percentage)

# Function to check CPU utilization for all available CPUs
check_cpu_utilization() {
    cpu_utilization=$(top -b -n 1 | awk '/%Cpu\(s\):/ {print 100 - $8}')
}

# Function to check GPU utilization for all available GPUs (assuming Nvidia GPUs)
check_gpu_utilization() {
    greatest_utilization=0

    while read -r util; do
        if (( $(echo "$util > $greatest_utilization" | bc -l) )); then
            greatest_utilization=$util
        fi
    done < <(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

    gpu_utilization=$greatest_utilization
}

inactivity_timer=0
activity_timer=0

# Main loop
while true; do
    check_cpu_utilization
    check_gpu_utilization

    # If CPU/GPU utilization is below thresholds, increment the timer
    if [ $(echo "$cpu_utilization < $CPU_THRESHOLD" | bc -l) -eq 1 ] && [ $(echo "$gpu_utilization <= $GPU_THRESHOLD" | bc -l) -eq 1 ]; then
        ((inactivity_timer += 1))
        activity_timer=0
    else
        if [ "$activity_timer" -ge 3 ]; then
            inactivity_timer=0  # Reset the timer if there is activity
        else
            ((activity_timer += 1))
        fi
    fi

    # If the timer reaches 7200 (2 hours), schedule a server shutdown
    if [ "$inactivity_timer" -ge 3600 ]; then
        echo "Server will be shut down due to inactivity."
        sudo poweroff  # Schedule shutdown in 10 seconds
        inactivity_timer=0  # Reset the timer
    fi

    # Echo the inactivity timer value
    printf "\rCPU Utilization: %.2f%%   GPU Utilization: %.2f%%   Inactivity Timer: %d seconds" "$cpu_utilization" "$gpu_utilization" "$inactivity_timer"

    sleep 1  # Sleep for 1 second before checking again
done
