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
eos-pkg-changelog | (Unavailable) Show the changelog of (most) EndeavourOS packages.<br>Usage: `eos-pkg-changelog <package-name>`
eos-pkginfo | (Unavailable) Show usage and/or developer information about an EndeavourOS/Arch/AUR package.<br>Package can be identified by its name, included program, or file path.<br>Usage: `eos-pkginfo {<package-name> \| <program-name> \| <file path>`}
eos-pkginfo.completion | (Unavailable) Bash completion for eos-pkginfo.<br>Note: does not support completion for AUR packages because of performance.
eos-reboot-required.hook | Runs `eos-reboot-required2` after any of the listed essential system packages have been updated.
eos-reboot-required2 | Filters packages that may need a notificication about a recommended reboot and signals eos-reboot-required3 by using the systemd service.
eos-reboot-required3 | Waits for all pacman-like processes to finish, then notifies about needed reboot when called by eos-reboot-required.service.
eos-reboot-required.service | Calls eos-reboot-required3 when a reboot is recommended.
eos-reboot-required.timer | Calls eos-reboot-required.service periodically.
eos-script-lib-yad | Common bash code for various EOS apps.
eos-script-lib-yad.conf | Configuration file for eos-script-lib-yad.
eos-sendlog | Send a text file to pastebin, and save the returned URL to ~/.config/eos-sendlog.txt.<br>Example: `cat log.txt \| eos-sendlog`
eos-wallpaper-set | Sets the wallpaper according to the current DE, given file, or from given folder.
ksetwallpaper.py | KDE wallpaper installer, forked from https://github.com/pashazz/ksetwallpaper.
paccache-service-manager | Tool to manage paccache service (prevents package cache size growing too much).
RunInTerminal | Run one or many commands in a new terminal. Useful for Welcome and related apps.
su-c_wrapper | A small utility to perform command "su -c". Useful e.g. for users without sudoers rights.<br> Tip: make a short alias, for example: `alias root=su-c_wrapper`
UpdateInTerminal | Simple system updater using only terminal. | deprecated
UpdateInTerminal.desktop | Launcher & icon for UpdateInTerminal. | deprecated

