# bash.backup
Backup tool that install either Snapper or Timeshift & configures snapshots to be made on a daily basis.
```bash
git clone https://github.com/Querzion/bash.backup.git $HOME
```
```bash
chmod +x -r $HOME/bash.backup
```
```bash
sh $HOME/bash.backup/installer.sh
```
### Main Logic
  -  Updates GRUB and Btrfs to the latest versions.
  -  Backs up GRUB configuration.
  -  Manages the backup tool selection and installs the required packages.
  -  Configures Snapper or Timeshift based on the selection.
  -  Updates GRUB configuration to reflect any changes.
## SNAPPER SETTING
#### Snapshot Configuration and Impact with Adjusted Settings
  1. TIMELINE_CREATE:
      -  Enabling timeline snapshots will create snapshots at regular intervals.
  2. TIMELINE_MIN_AGE:
      -  Minimum age (in seconds) between snapshots. Set to 3600 seconds (1 hour).
  3. TIMELINE_LIMIT_HOURLY:
      -  Limit of hourly snapshots. With this setting, up to 2 hourly snapshots will be kept.
  4. TIMELINE_LIMIT_DAILY:
      -  Limit of daily snapshots. This setting keeps up to 7 daily snapshots.
  5. TIMELINE_LIMIT_WEEKLY:
      -  Limit of weekly snapshots. Up to 4 weekly snapshots will be kept.
  6. TIMELINE_LIMIT_MONTHLY:
      -  Limit of monthly snapshots. Up to 5 monthly snapshots will be kept.
  7. TIMELINE_LIMIT_YEARLY:
      -  Limit of yearly snapshots. Up to 4 yearly snapshot will be kept.

## Estimating Snapshot Size
  -  Hourly Snapshots: 2 snapshots, each potentially including all changes within the hour.
  -  Daily Snapshots: 7 snapshots, each potentially including all changes within the day.
  -  Weekly Snapshots: 4 snapshots, each potentially including all changes within the week.
  -  Monthly Snapshots: 3 snapshots, each potentially including all changes within the month.
  -  Yearly Snapshots: 1 snapshot, each potentially including all changes within the year.

### To get a rough estimate of the snapshot size:
  -  Monitor Disk Usage: After setting up Snapper, monitor the disk usage over time to see how much space snapshots are         consuming.
  -  Adjust Snapshot Limits: Based on your observations, you might want to adjust the snapshot limits to better fit your storage capacity.

## Adjusted Configuration for Snapper
The script below configures Snapper with the adjusted settings:

```
sudo snapper -c root set-config "NUMBER_CLEANUP=yes"
sudo snapper -c root set-config "TIMELINE_CREATE=yes"
sudo snapper -c root set-config "TIMELINE_MIN_AGE=3600"       # 1 hour
sudo snapper -c root set-config "TIMELINE_LIMIT_HOURLY=2"     # 2 hourly snapshots
sudo snapper -c root set-config "TIMELINE_LIMIT_DAILY=7"      # 7 daily snapshots
sudo snapper -c root set-config "TIMELINE_LIMIT_WEEKLY=4"     # 4 weekly snapshots
sudo snapper -c root set-config "TIMELINE_LIMIT_MONTHLY=5"    # 5 monthly snapshots
sudo snapper -c root set-config "TIMELINE_LIMIT_YEARLY=4"     # 4 yearly snapshot
```
## Summary
The exact size of snapshots will depend on your system's usage and the amount of data change. By monitoring disk usage and adjusting the snapshot configuration, you can find a balance that works for your storage capacity. The adjusted settings aim to reduce the number of snapshots and thus the space they consume while still maintaining sufficient backup intervals.
