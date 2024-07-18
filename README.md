# bash.backup
Backup tool (Snapper|Timeshift) installer & configuration.
```bash
git clone https://github.com/Querzion/bash.backup.git $HOME
```
```bash
chmod +x -r $HOME/bash.backup
```
```bash
sh $HOME/bash.backup/installer.sh
```
# Main Logic
  -  Updates GRUB and Btrfs to the latest versions.
  -  Backs up GRUB configuration.
  -  Manages the backup tool selection and installs the required packages.
  -  Configures Snapper or Timeshift based on the selection.
  -  Updates GRUB configuration to reflect any changes.
