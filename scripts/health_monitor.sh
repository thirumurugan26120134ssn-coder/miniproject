#!/bin/bash

# ============================================
# Automated Linux System Health Monitor
# ============================================

REPORT_DIR="reports"
REPORT_FILE="$REPORT_DIR/health_report.txt"

# Create reports directory if it doesn't exist
mkdir -p "$REPORT_DIR"

# Start the report
{
    echo "========================================"
    echo "       LINUX SYSTEM HEALTH REPORT"
    echo "========================================"
    echo
    echo "Generated at: $(date)"
    echo

    # ----------------------------------------
    # HOST INFORMATION
    # ----------------------------------------
    echo "---------- HOST INFORMATION ----------"
    echo "Hostname: $(hostname)"

    echo "Operating System:"
    grep PRETTY_NAME /etc/os-release

    echo

    # ----------------------------------------
    # DISK USAGE
    # ----------------------------------------
    echo "---------- DISK USAGE ----------"
    df -h

    echo

    # ----------------------------------------
    # MEMORY USAGE
    # ----------------------------------------
    echo "---------- MEMORY USAGE ----------"
    free -h

    echo

    # ----------------------------------------
    # CPU LOAD
    # ----------------------------------------
    echo "---------- CPU LOAD ----------"
    uptime

    echo

    # ----------------------------------------
    # TOP CPU PROCESSES
    # ----------------------------------------
    echo "---------- TOP CPU PROCESSES ----------"
    ps aux --sort=-%cpu | head -n 6

    echo

    # ----------------------------------------
    # TOP MEMORY PROCESSES
    # ----------------------------------------
    echo "---------- TOP MEMORY PROCESSES ----------"
    ps aux --sort=-%mem | head -n 6

    echo

    echo "========================================"
    echo "Health report generated successfully."
    echo "========================================"

} > "$REPORT_FILE"

echo "Health report created: $REPORT_FILE"
