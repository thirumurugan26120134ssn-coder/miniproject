#!/bin/bash

# ============================================
# Automated Linux Health Monitoring System
# ============================================

PROJECT_DIR="$HOME/Downloads/linux-automation-mini-project"
LOG_FILE="$PROJECT_DIR/logs/automation.log"

# Move to project directory
cd "$PROJECT_DIR" || {
    echo "ERROR: Project directory not found."
    exit 1
}

# Make sure log directory exists
mkdir -p logs

echo "========================================" >> "$LOG_FILE"
echo "Automation started: $(date)" >> "$LOG_FILE"

# ============================================
# STEP 1: Run Health Monitor
# ============================================

echo "Running health monitor..." >> "$LOG_FILE"

if ./scripts/health_monitor.sh >> "$LOG_FILE" 2>&1; then
    echo "Health monitor completed successfully." >> "$LOG_FILE"
else
    echo "ERROR: Health monitor failed." >> "$LOG_FILE"
    exit 1
fi

# ============================================
# STEP 2: Generate Health Summary
# ============================================

echo "Generating health summary..." >> "$LOG_FILE"

if ./scripts/summarize_report.sh >> "$LOG_FILE" 2>&1; then
    echo "Health summary generated successfully." >> "$LOG_FILE"
else
    echo "ERROR: Summary generation failed." >> "$LOG_FILE"
    exit 1
fi

# ============================================
# STEP 3: Check Generated Reports
# ============================================

if [ ! -f reports/health_report.txt ]; then
    echo "ERROR: Health report missing." >> "$LOG_FILE"
    exit 1
fi

if [ ! -f reports/summary_report.txt ]; then
    echo "ERROR: Summary report missing." >> "$LOG_FILE"
    exit 1
fi

echo "Reports verified successfully." >> "$LOG_FILE"

# ============================================
# STEP 4: Git Status
# ============================================

echo "Checking Git status..." >> "$LOG_FILE"

git status --short >> "$LOG_FILE"

# ============================================
# STEP 5: Add Reports to Git
# ============================================

git add reports/health_report.txt
git add reports/summary_report.txt

# ============================================
# STEP 6: Commit Changes
# ============================================

if git diff --cached --quiet; then

    echo "No report changes detected." >> "$LOG_FILE"

else

    git commit -m "Automated health monitoring report" >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "Git commit completed successfully." >> "$LOG_FILE"
    else
        echo "ERROR: Git commit failed." >> "$LOG_FILE"
        exit 1
    fi

    # ========================================
    # STEP 7: Push to GitHub
    # ========================================

    echo "Pushing reports to GitHub..." >> "$LOG_FILE"

    if git push origin main >> "$LOG_FILE" 2>&1; then
        echo "Changes pushed successfully to GitHub." >> "$LOG_FILE"
    else
        echo "ERROR: Git push failed." >> "$LOG_FILE"
        exit 1
    fi

fi

echo "Automation completed successfully: $(date)" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"

echo "========================================"
echo "Linux Health Automation Completed"
echo "========================================"
echo "Health report: reports/health_report.txt"
echo "Summary report: reports/summary_report.txt"
echo "Automation log: logs/automation.log"
echo "========================================"
