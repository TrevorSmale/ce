#!/bin/bash
     
     # Monitor CPU, memory, and disk usage
     CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
     MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
     DISK_USAGE=$(df -h | grep '/dev/sda1' | awk '{print $5}' | cut -d '%' -f1)
     
     # Send alert if usage exceeds thresholds
     if [ $(echo "$CPU_USAGE > 90" | bc) -eq 1 ]; then
         echo "High CPU usage: $CPU_USAGE%" | mail -s "Alert: High CPU Usage" admin@example.com
     fi
     
     if [ $(echo "$MEMORY_USAGE > 90" | bc) -eq 1 ]; then
         echo "High memory usage: $MEMORY_USAGE%" | mail -s "Alert: High Memory Usage" admin@example.com
     fi
     
     if [ "$DISK_USAGE" -gt 90 ]; then
         echo "High disk usage: $DISK_USAGE%" | mail -s "Alert: High Disk Usage" admin@example.com
     fi