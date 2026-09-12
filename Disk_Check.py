#!/usr/bin/env python3

import shutil

# Disk usage warning threshold
THRESHOLD = 80

def check_disk_usage():
    print("Disk Usage Check")
    print("=" * 40)

    # Get all mounted filesystems
    with open("/proc/mounts", "r") as mounts:
        partitions = set(line.split()[1] for line in mounts)

    for partition in sorted(partitions):
        try:
            usage = shutil.disk_usage(partition)

            # Skip filesystems with no usable storage size
            if usage.total == 0:
                print(f"\nSkipping {partition} (no storage size reported)")
                continue

            total_gb = usage.total / (1024 ** 3)
            used_gb = usage.used / (1024 ** 3)
            percent_used = (usage.used / usage.total) * 100

            print(f"\nPartition: {partition}")
            print(f"Used: {used_gb:.1f} GB / {total_gb:.1f} GB ({percent_used:.1f}%)")

            if percent_used > THRESHOLD:
                print(f"WARNING: {partition} is more than {THRESHOLD}% full!")

        except PermissionError:
            print(f"WARNING: Permission denied checking {partition}")
        except OSError:
            print(f"WARNING: Unable to check {partition}")



if __name__ == "__main__":
    check_disk_usage()