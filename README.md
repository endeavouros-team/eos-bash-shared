# eos-bash-shared

Source code for the eos-bash-shared package

## Purpose of these apps and files

Code shared between EndeavourOS apps, and certain small but useful tools.

File name | Description | Extra
:---- | :------- | :----
ChangeDisplayResolution | Helps changing display resolution (with xrandr).
device-info | A helper app for finding info about devices.
eos-connection-checker | Checks that an internet connection is available.
eos-FindAppIcon | Find a suitable icon path for an app.
eos-reboot-required.hook | Runs `eos-reboot-required2` after any of the listed essential system packages have been updated.
eos-reboot-required2 | Filters packages that may need a notificication about a recommended reboot and signals eos-reboot-required3 with the help of the systemd service.
eos-reboot-required3 | When called by eos-reboot-required.service, waits for all pacman-like processes to finish, then notifies about needed reboot.
eos-reboot-required.service | Calls eos-reboot-required3 when a reboot is recommended.
eos-reboot-required.timer | Calls eos-reboot-required.service periodically.
eos-script-lib-yad | Common bash code for various EOS apps.
eos-script-lib-yad.conf | Configuration file for eos-script-lib-yad.
eos-sendlog | Send a text file to pastebin, and save the returned URL to ~/.config/eos-sendlog.txt.<br>Example: `cat log.txt \| eos-sendlog`
eos-update | Package updater with additional features for EndeavourOS and Arch. Uses pacman and optionally yay.
eos-update.desktop | Launcher for eos-update.
eos-wallpaper-set | Sets the wallpaper according to the current DE, given file, or from given folder.
ksetwallpaper.py | KDE wallpaper installer, forked from https://github.com/pashazz/ksetwallpaper.
paccache-service-manager | Tool to manage paccache service (prevents package cache size growing too much).
RunInTerminal | Run one or many commands in a new terminal. Useful for Welcome and related apps.
su-c_wrapper | A small utility to perform command "su -c". Useful e.g. for users without sudoers rights.<br> Tip: make a short alias, for example: `alias root=su-c_wrapper`

