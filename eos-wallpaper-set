#!/bin/bash

#################################################################################
EOS_SCRIPTS_YAD=/usr/share/endeavouros/scripts/eos-script-lib-yad
if [ -e $EOS_SCRIPTS_YAD ] ; then
    source $EOS_SCRIPTS_YAD
    unset EOS_SCRIPTS_YAD

    export -f eos_yad
    export -f eos_yad_terminal
    export -f eos_yad_check_internet_connection
    export -f eos_yad_GetArgVal
    export -f eos_yad_RunCmdTermBash
    export -f eos_yad_problem
    export -f eos_yad_DIE
    export -f eos_yad_WARN
    export -f eos_yad__detectDE
    export -f eos_yad_GetDesktopName
    export -f eos_GetArch
fi
#################################################################################

Monospaced() { printf "<tt>%s</tt>" "$1" ; }
Untagged()   { echo "$1" | sed -e 's|<[/]*[ib]>||g' ; }

eos_yad_infomsg() {
    local msg="$1"
    Untagged "$msg"  >&2
    which yad &>/dev/null && \
    eos_yad --form --text="$(Monospaced "$msg")" --title="Message" --tail --wrap --image=info \
            --button=yad-quit:0 "$@"
}

DIE() {
    Untagged "$1" >&2
    which yad &>/dev/null && \
    eos_yad --form --text="$(Monospaced "$1")\n" --title="$progname: error" \
            --width=400 \
            --image=error --button=yad-ok:0
    exit 1
}

FzfInFolders() {
    cd "$picfolder"
    local item="$PWD"

    local header
    local header_lines=(
        "Navigation keys: Up/Down/PgUp/PgDn; ENTER=accept, ESC=quit"
    )
    header_lines=("" "${header_lines[@]}" "")        # add empty extra lines to separate header
    printf -v header "%s\n" "${header_lines[@]}"
    local fzf=(
        fzf --tac --header="$header" --footer="Select wallpaper"
    )

    while true ; do
        item="$(/bin/ls -1a --ignore=.[a-z]* --ignore=. --group-directories-first -F --color=auto "$item" | "${fzf[@]}")"
        case "$item" in
            "") exit 1 ;;
            */) item="${item:: -1}" ;;
        esac
        item="$PWD/$item"
        if [ -d "$item" ] ; then
            cd "$item"
            continue
        fi
        echo "$item"
        break
    done
}

WallpaperSelect() {
    local pic_count=$(/usr/bin/ls -l "$picfolder" | /usr/bin/wc -l)
    local height=$((pic_count * 36))
    local hmax=600 hmin=300

    if [ $height -gt $hmax ] ; then
        height=$hmax
    elif [ $height -lt $hmin ] ; then
        height=$hmin
    fi

    # eos_assert_deps $progname yad || exit 1
    if [ -x /bin/yad ] ; then
        pic="$(eos_yad --file --filename="$picfolder" --width=700 --height=$height --title="Choose wallpaper file")"
    else
        pic="$(FzfInFolders)" || exit 1
    fi
}

xfce4_set_wallpaper() {
    local wallpaper="" mime_type="" properties="" property

    # The rest of this function is copied from package 'xapp', script 'xfce4-set-wallpaper'
    # with minor modifications.

    # Author: Weitian Leung <weitianleung@gmail.com>
    # Version: 2.1
    # License: GPL-3.0
    # Description: set a picture as xfce4 wallpaper

    # xfce4-desktop requires an absolute path.
    wallpaper="$(realpath "${1//file:\/\//}")"

    # check image
    mime_type=`file --mime-type -b "$wallpaper"`
    if [[ ! "$mime_type" == image/* ]]; then
        DIE "Invalid image"                          # original: echo "Invalid image"
        exit 1
    fi

    # set to every monitor that contains image-path/last-image
    properties=$(xfconf-query -c xfce4-desktop -p /backdrop -l | grep -e "screen.*/monitor.*image-path$" -e "screen.*/monitor.*/last-image$")

    for property in $properties; do
        xfconf-query -c xfce4-desktop -p $property -s "$wallpaper"
    done
}

XfceSetWallpaper() {
    # Set all "last-image" values in file $conf to picture $pic

    local impl

    case "$(eos_GetArch)" in
        armv7h) impl=1 ;;
        *)      impl=3 ;;  # was 2
    esac

    case "$impl" in
        0)
            local conf="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
            test -r "$conf" || DIE "Config file '$conf' does not exist."
            sed -i "$conf" -e 's|name="last-image".*$|name="last-image" type="string" value="'"$pic"'"/>|'
            eos_yad_infomsg "Reboot is required for the changes to take effect."
            ;;
        1)
            local prop
            for prop in $(xfconf-query --channel xfce4-desktop --list | grep /last-image$) ; do
                xfconf-query --channel xfce4-desktop --property $prop --set "$pic"
            done
            #eos_yad_infomsg "Reboot is required for the changes to take effect."
            ;;
        2)
            local monitors=($(xrandr | grep -w connected | awk '{print $1}'))
            local monitor mon prop

            for monitor in "${monitors[@]}" ; do
                mon=monitor${monitor}
                prop=$(xfconf-query --channel xfce4-desktop --list | grep  /last-image$  | grep $mon)
                xfconf-query --channel xfce4-desktop --property $prop --set "$pic"
            done
            ;;
        3)
            xfce4_set_wallpaper "$pic"
            ;;
    esac
}

WallpaperSetCommon() {
    # Assume:
    #    - $pic is the picture file name
    #    - $DE is the desktop environment

    test -n "$pic" || DIE "no picture!"

    case "$DE" in
        BUDGIE)
            AssertPicture endeavouros_budgie.png
            gsettings set org.gnome.desktop.background picture-uri "$pic"
            ;;
        CINNAMON)
            AssertPicture endeavouros_cinnamon.png
            gsettings set org.cinnamon.desktop.background picture-uri "$pic"
            ;;
        DEEPIN)
            AssertPicture endeavouros_deepin.png
            dconf write /com/deepin/wrap/gnome/desktop/background/picture-uri "'$pic'"  # Note: extra quotes required!
            ;;
        GNOME | GNOME3)
            AssertPicture endeavouros_gnome.png
            gsettings set org.gnome.desktop.background picture-uri "$pic"
            ;;
        I3)
            AssertPicture endeavouros_i3.png no
            feh --bg-scale "$pic"
            ;;
        KDE)
            AssertPicture endeavouros_plasma.png no
            python3 /usr/share/endeavouros/scripts/ksetwallpaper.py --file "$pic"
            # see also:
            # https://www.kubuntuforums.net/showthread.php/66762-Right-click-wallpaper-changer?p=387392&viewfull=1#post387392
            ;;
        LXDE)
            AssertPicture endeavouros_lxde.png no
            pcmanfm --set-wallpaper="$pic"
            ;;
        LXQT)
            AssertPicture endeavouros_lxqt.png no
            pcmanfm-qt --set-wallpaper="$pic"
            ;;
        MATE)
            AssertPicture endeavouros_mate.png no
            gsettings set org.mate.background picture-filename "$pic"
            ;;
        XFCE)
            AssertPicture endeavouros_xfce4.png no
            XfceSetWallpaper
            ;;

        # Not DEs but WMs:

        SWAY)
            AssertPicture "$pic_default" no
            killall swaybg   # otherwise wallpaper doesn't change!
            swaybg -i "$pic"
            ;;
        BSPWM)
            AssertPicture "$pic_default" no
            nitrogen --set-auto "$pic"
            ;;
        OPENBOX)
            AssertPicture "$pic_default" no
            nitrogen --set-auto "$pic"
            ;;
        QTILE)
            AssertPicture "$pic_default" no
            feh --bg-scale "$pic"
            ;;
        *)
            echo "$progname: info: not setting wallpaper to $DE ..." >&2

            #AssertPicture "$pic_default" no
            #feh --bg-scale "$pic"
            #DIE "Sorry, desktop '$DE' is not supported."
            ;;
    esac

    if [ ! -e "$history_of_backgrounds" ] ; then
        local header="History of desktop wallpapers set by $progname (started at $(date '+%x %X'))"
        local underline=${header//?/=}
        cat <<EOF > "$history_of_backgrounds"
$header
$underline

EOF
    fi
    echo "$(date '+%x %X'): $(realpath "${pic//file:\/\//}")" >> "$history_of_backgrounds"
}

PictureNameVariations() {
    # Allow very small naming choices in the default wallpapers,
    # like '-' instead of '_' before the DE name.

    [ -r "$pic" ] && return    # picture found, OK
    
    if [ "$(basename "$pic")" = "$fallback" ] ; then
        local changed="$(echo "$pic" | sed 's|endeavouros_\([a-z][a-z]*[0-9]\.png\)$|endeavouros-\1|')"
        if [ -r "$changed" ] ; then
            echo "Info: wallpaper name changed from '$(basename "$pic")' to '$(basename "$changed")'" >&2
            pic="$changed"
            return 0
        fi
    fi
    DIE "Picture file '$pic' does not exist."
}

AssertPicture() {
    local fallback="$1"
    local use_file_prefix="$2"

    case "$pic" in
        DEFAULT-2020 | default-2020)
            case "$(eos_GetArch)" in
                armv7h)
                    pic="$picfolder/arm-$fallback"
                    [ -r "$pic" ] || pic="$picfolder/$fallback"          # ARM pictures missing
                    ;;
                *)
                    pic="$picfolder/$fallback"
                    ;;
            esac
            ;;
        DEFAULT | default | DEFAULT-2021 | default-2021)
            pic="$picfolder/"$pic_default""
            ;;
        ISO | iso)
            pic="$picfolder/endeavouros-default-background.png"          # new picture
            [ -r "$pic" ] || pic="$picfolder/"$pic_default""  # old picture
            ;;
    esac

    # change $pic to full path format
    case "$pic" in
        "")
            DIE "no picture file given!"
            ;;
        file://*)
            pic="${pic:7}"
            ;;
        /*)
            ;;                                        # OK, full path
        *)
            if [ -r "$picfolder/$pic" ] ; then
                pic="$picfolder/$pic"                 # EOS picture without path given, add path
            elif [ -r "$pic" ] ; then
                pic="$PWD/$pic"                       # picture has relative path
            fi
            ;;
    esac

    # Now we have a full path. Check that it exists or die.
    PictureNameVariations

    # Some DE's prefer file:// prefix, some not.
    if [ "$use_file_prefix" = "no" ] ; then
        case "$pic" in
            file://*) pic="${pic:7}" ;;
        esac
    else
        case "$pic" in
            file://*) ;;
            *) pic="file://$pic" ;;
        esac
    fi
    echo "Setting desktop wallpaper $pic for '$DE' ..." >&2
}

RemoveBadWallsFromHistory() {
    local walls_remove=() wp

    walls=()
    for wp in "$@" ; do
        if [ -e "$wp" ] ; then
            walls+=("$wp")
        else
            echo "==> not exist: '$wp'" >&2
            if false && [ "$quote_some_specials" = yes ] && [ "${wp//\[/}" != "$wp" ] ; then
                wp=${wp//\[/\\[}                         # quote possible [ and ] for 'grep' below in this function
                wp=${wp//\]/\\]}
            fi
            walls_remove+=("$wp")
        fi
    done
    if [ "$walls_remove" ] ; then
        local reply
        read -p "==> Remove non-existing wallpaper paths from the history (Y/n)? " reply >&2
        case "$reply" in
            [Nn]*) ;;
            *)
                rm -f "$history_of_backgrounds".bak
                mv "$history_of_backgrounds" "$history_of_backgrounds".bak
                printf "%s\n" "${walls_remove[@]}" > "$history_of_backgrounds.removed_paths"
                grep -Fvf "$history_of_backgrounds.removed_paths" "$history_of_backgrounds".bak > "$history_of_backgrounds"
                ;;
        esac
    fi
}

Pager() {
    local file="$1"
    [    "$file" ] || return 1
    [ -r "$file" ] || return 2
    local pager="/bin/more -de"

    if [ -x /bin/less ] ; then
        local LESS="-P [H=help] %f"
        pager="/bin/less"
    fi
    $pager "$file"
}

Parameters() {
    local arg msg

    for arg in "$@" ; do
        case "$arg" in
            -h | --help)
                eos_yad_infomsg "$(Usage)"
                exit 0
                ;;
            --history)
                # Wallpaper file names may have spaces.
                # Some old wallpapers may not exist anymore.
                local walls=() wp
                readarray -t walls < <(grep ^[0-9] "$history_of_backgrounds" | sed -E 's|^[^:]+: (/.*)|\1|' | sort -u)
                RemoveBadWallsFromHistory "${walls[@]}"
                if [ "$walls" ] ; then
                    wp=$(printf "%s\n" "${walls[@]}" | fzf)
                    [ "$wp" ] && Main "$wp"
                else
                    echo "==> no wallpapers in the history" >&2
                fi
                exit 0
                ;;
            --history-raw)
                Pager "$history_of_backgrounds"
                exit 0
                ;;
            -*)
                msg="$(printf "\n%s\n\n" "Unsupported option '$arg'." ; Usage)"
                DIE "$msg"
                ;;
            *)
                if [ -d "$arg" ] ; then
                    picfolder="$arg"
                else
                    pic="$arg"
                fi
                ;;
        esac
    done
}

Usage() {
    cat <<EOF
Usage: <b>$progname</b> [options] [wallpaper-file | folder]
Options:
    -h, --help           This help.
    --history            Select wallpaper from previously set wallpapers.
    --history-raw        Show wallpaper history fully including time stamps.
Parameters:
    <i>wallpaper-file</i>
        Wallpaper file name, 'DEFAULT', or 'ISO':
        - absolute or relative path, with or without leading 'file://'.
        - 'DEFAULT' means the default Desktop specific wallpaper.
        - 'ISO'     means the default wallpaper for the installer ISO
    <i>folder</i>
        An existing folder path for wallpapers.

If <i>wallpaper-file</i> is not given, the <i>wallpaper chooser</i> is started.

Examples:
    $progname ~/Pictures/a_picture.jpg  # wallpaper file name
    $progname ~/Pictures                # folder path for pictures
    $progname DEFAULT                   # Desktop specific default wallpaper
    $progname ISO                       # wallpaper used by the ISO
    $progname                           # starts the wallpaper chooser
EOF
}

PicDefault() {
    local pic_formats=(avif jpg png)        # supported in this order
    local -r pic_base=endeavouros-wallpaper
    local fmt

    for fmt in "${pic_formats[@]}" ; do
        if [ -e "$picfolder/$pic_base"."$fmt" ] ; then
            pic_default="$pic_base.$fmt"
            return 0  # not used
        fi
    done
    return 1  # not used
}

GetDE() {
    if [ -x /bin/yad ] ; then
        local de=$(eos_GetDeOrWm)
    else
        local de=$XDG_CURRENT_DESKTOP
    fi
    echo "$de"
}

Main()
{
    local -r progname=${0##*/}
    local -r DE="$(GetDE)"
    local picfolder=/usr/share/endeavouros/backgrounds
    local pic=""
    local pic_default=""
    local history_of_backgrounds="$HOME/.$progname.history-of-wallpapers"   # saves history of wallpaper file names
    local quote_some_specials=yes

    # yad_missing_check $progname

    case "$DE" in
        XFCE) type xrandr >& /dev/null || DIE "Sorry, this implementation needs package 'xorg-xrandr' on Xfce." ;;
    esac

    PicDefault
    Parameters "$@"

    if [ -z "$pic" ] ; then
        WallpaperSelect
    fi
    WallpaperSetCommon
}

Main "$@"
