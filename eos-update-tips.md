# Tips for `eos-update`

`eos-update` updates the software packages of your system using
programs `pacman` and optionally `yay` or `paru`.<br>
This document gives a few tips about some lesser known features of `eos-update`.

Some more or less obvious notes:
- The *bash command completion* feature is supported to help writing a command.
- The options explained below can be combined with other options as usual.

## Show available options

`eos-update --help`

There are many more options available than explained here.

## Update AUR packages too

`eos-update --aur`

This assumes either `yay` or `paru` is installed.

## Update other packages (e.g. flatpak)

Edit file `/bin/eos-update-other.bash` and add proper commands to update *other* than native or AUR packages.
Then run `eos-update` with option `--other-updates`, and your commands will be executed after native (and optionally AUR) updates.<br>
Example:

`eos-update --aur --other-updates`

## See the descriptions of the updated packages

`eos-update --descriptions`

Note: only descriptions of the *native* packages will be listed.

## Use the fast mode

`eos-update --fast`<br><br>
Note: this option saves the latest update level *each time* you run with it,
which may cause undetected updates.<br>
For example:
1. Run `eos-update --fast` *and* decline updating.
2. *Immediately* run `eos-update --fast` the second time, the fast mode
thinks there are no updates. In that case
run `eos-update` without option `--fast`.

## Check the validity of the lists of mirrors

`eos-update --check-mirrors`

## Nvidia GPU drivers

`eos-update --nvidia`

This will check that the updates of the kernel (`linux` or `linux-lts`)
and the Nvidia driver (`nvidia` or `nvidia-lts`) are in proper sync.
A warning is displayed if not.

This warning means it is better not to update until
the updates for the mentioned packages are in sync,
and `eos-update --nvidia` gives no warning.
Usually the wait is not long.

Note that there have been cases they weren't in sync, causing a problem
at system restart.

## Aliases

Here's some potentially useful aliases for `eos-update`:
```
alias u='eos-update --fast --descriptions'           # without Nvidia GPU
alias u='eos-update --fast --descriptions --nvidia'  # with Nvidia GPU
```
Note that option `--nvidia` works even if the system has *no* Nvidia GPU.
