#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

#
# TODO: Sound is not working for some reason
# TODO: Should see if X11 can be autodetected and run appropriately
#

rp_module_id="pleethebear"
rp_module_desc="Plee the Bear"
rp_module_help=""
rp_module_licence="CC https://github.com/j-jorge/plee-the-bear/blob/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!all rpi4"

function depends_pleethebear() {
    # On RPI systems, we need to make sure Box86 is installed.
    if isPlatform "rpi"; then
        if ! rp_isInstalled "box86" ; then
            md_ret_errors+=("Sorry, you need to install the Box86 scriptmodule")
            return 1
        fi
    fi
}

function install_bin_pleethebear() {
    echo "Downloading $rp_module_desc to $md_inst"
    downloadAndExtract "https://web.archive.org/web/20171012044857/http://www.stuff-o-matic.com/plee-the-bear/download/file.php?platform=linux" "$md_inst"
}

function configure_pleethebear() {
    local system="plee-the-bear"
    local runScript="$romdir/box86/Plee the Bear.sh"
    local runScriptX11="$romdir/box86/Plee the Bear.sh"

    # Create the configuration directory
    moveConfigDir "$home/.plee_the_bear" "$md_conf_root/$system"

    # Create new INI files if they do not already exist
    # Create MAME config file
    local temp_ini_mame="$(mktemp)"

    cat > $temp_ini_mame << __CONF__
# Configuration of the screen.
[Video]
# Do we use the fullscreen?
fullscreen = true
# Do we use the dumb but visually better procedure to render the elements?
dumb_rendering = true

# Configuration of the sound system.
[Audio]
# Do we play the sounds?
sound_on = true
# Do we play the music?
music_on = true
# Volume of the sounds.
sound_volume = 1
# Volume of the the music.
music_volume = 1

# Miscellaneous options of the game.
[Gameplay]
# Tell if the players can harm each other.
friendly_fire = true
__CONF__

    copyDefaultConfig "$temp_ini_mame" "$md_conf_root/$system/config"
    rm "$temp_ini_mame"

    #
    # Add entry to Box86 roms directory in Emulation Station
    #
    cat > "$runScriptX11" << __EOFX11__
#!/bin/bash
xset -dpms s off s noblank
export LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/:/opt/retropie/emulators/box86/"
cd "$md_inst/plee-the-bear/"
matchbox-window-manager &
setarch linux32 -L "$md_inst"/plee-the-bear/plee-the-bear
__EOFX11__

    chown $user:$user "$runScriptX11"
    chmod a+x "$runScriptX11"
}
