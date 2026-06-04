#!/usr/bin/env bash

INTERFACE="enp2s0"

PATH_RX="/sys/class/net/$INTERFACE/statistics/rx_bytes"
PATH_TX="/sys/class/net/$INTERFACE/statistics/tx_bytes"

# Temporary file to store the previous values
CACHE_FILE="/tmp/net_speed_${INTERFACE}.cache"

if [ ! -f "$PATH_RX" ]; then
    echo "<txt><span color='#ff3333'>Err</span></txt>"
    exit 1
fi

# Read current bytes
R2=$(cat "$PATH_RX")
T2=$(cat "$PATH_TX")

# Get current timestamp
NOW=$(date +%s)

# Read previous bytes and time if cache exists
if [ -f "$CACHE_FILE" ]; then
    source "$CACHE_FILE"
    
    # Calculate time difference
    INTERVAL=$((NOW - PREV_TIME))
    [ "$INTERVAL" -le 0 ] && INTERVAL=1

    # Calculate actual bytes per second
    RBPS=$(((R2 - R1) / INTERVAL))
    TBPS=$(((T2 - T1) / INTERVAL))
else
    RBPS=0
    TBPS=0
fi

# Save current stats for the next loop run
echo "R1=$R2" > "$CACHE_FILE"
echo "T1=$T2" >> "$CACHE_FILE"
echo "PREV_TIME=$NOW" >> "$CACHE_FILE"

# Function to format bytes into human-readable speeds
format_speed() {
    local bytes=$1
    if [ "$bytes" -lt 1024 ]; then
        echo "${bytes} B/s"
    elif [ "$bytes" -lt 1048576 ]; then
        echo "$(awk "BEGIN {printf \"%.1f\", $bytes/1024}") KiB/s"
    else
        echo "$(awk "BEGIN {printf \"%.1f\", $bytes/1048576}") MiB/s"
    fi
}

DOWN_SPEED=$(format_speed $RBPS)
UP_SPEED=$(format_speed $TBPS)

# Print output instantly without lagging the panel
echo "<txt><span font='Cascadia Code 10' weight='bold'><span color='#0077ff'>↓</span> $DOWN_SPEED  <span color='#ff007f'>↑</span> $UP_SPEED</span></txt>"
echo "<tool>Interface: $INTERFACE
Total Down: $(format_speed $R2)
Total Up: $(format_speed $T2)</tool>"
