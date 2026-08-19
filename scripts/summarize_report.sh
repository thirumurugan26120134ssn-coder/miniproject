#!/bin/bash

# ============================================
# Linux Health Report Summarizer
# ============================================

INPUT="reports/health_report.txt"
OUTPUT="reports/summary_report.txt"

# Check whether health report exists
if [ ! -f "$INPUT" ]; then
    echo "ERROR: Health report not found."
    echo "ACTION: Run health_monitor.sh first."
    exit 1
fi

# Start summary report
{
    echo "========================================"
    echo "       LINUX HEALTH SUMMARY REPORT"
    echo "========================================"
    echo
    echo "Generated at: $(date)"
    echo

    echo "---------- SYSTEM STATUS ----------"

    # ----------------------------------------
    # DISK ANALYSIS
    # ----------------------------------------

    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

    echo
    echo "Disk Usage: ${DISK_USAGE}%"

    if [ "$DISK_USAGE" -ge 80 ]; then
        echo "Status: WARNING - Disk usage is high."
        echo "Action: Remove unnecessary files or increase storage."
    else
        echo "Status: OK - Disk usage is within acceptable limits."
    fi

    # ----------------------------------------
    # MEMORY ANALYSIS
    # ----------------------------------------

    MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

    echo
    echo "Memory Usage: ${MEMORY_USAGE}%"

    if [ "$MEMORY_USAGE" -ge 80 ]; then
        echo "Status: WARNING - Memory usage is high."
        echo "Action: Check applications consuming large amounts of memory."
    else
        echo "Status: OK - Memory usage is within acceptable limits."
    fi

    # ----------------------------------------
    # CPU LOAD
    # ----------------------------------------

    LOAD=$(awk '{print $1}' /proc/loadavg)

    echo
    echo "CPU Load (1 minute): $LOAD"
    echo "Status: CPU load recorded successfully."

    # ----------------------------------------
    # REPORT VALIDATION
    # ----------------------------------------

    echo
    echo "---------- REPORT VALIDATION ----------"

    if grep -q "Health report generated successfully" "$INPUT"; then
        echo "Health report generation: SUCCESS"
    else
        echo "Health report generation: ERROR"
    fi

    # ----------------------------------------
    # ACTIONABLE SUMMARY
    # ----------------------------------------

    echo
    echo "---------- ACTIONABLE SUMMARY ----------"

    if [ "$DISK_USAGE" -ge 80 ] || [ "$MEMORY_USAGE" -ge 80 ]; then
        echo "Overall Status: ATTENTION REQUIRED"
        echo "Recommended Action: Investigate system resource usage."
    else
        echo "Overall Status: HEALTHY"
        echo "Recommended Action: No immediate action required."
    fi

    echo
    echo "========================================"
    echo "Summary generation completed."
    echo "========================================"

} > "$OUTPUT"

echo "Summary report created: $OUTPUT"
