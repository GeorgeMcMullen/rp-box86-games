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
# TODO: Game only takes up a small portion of a 1920x1080 screen, even when setting resolution for Box86+ROM. Possibly because it runs on SDL1.
# TODO: Should see if X11 can be autodetected and run appropriately, instead of having two scripts
#

rp_module_id="defendguin"
rp_module_desc="Defendguin"
rp_module_licence="GPL http://www.newbreedsoftware.com/defendguin/"
rp_module_section="opt"
rp_module_flags="!all rpi4"

function depends_defendguin() {
    # On RPI systems, we need to make sure Box86 is installed.
    if isPlatform "rpi"; then
        if ! rp_isInstalled "box86" ; then
            md_ret_errors+=("Sorry, you need to install the Box86 scriptmodule")
            return 1
        fi
    fi

    getDepends libsdl-mixer1.2
}

function install_bin_defendguin() {
    echo "Downloading Defendguin to $md_inst"
    downloadAndExtract "ftp://ftp.tuxpaint.org/unix/x/defendguin/linux/defendguin-0.0.11-linux-i386.tar.bz2" "$md_inst"
}

function configure_defendguin() {
    cat > "$romdir/box86/Defendguin.sh" << __EOF__
#!/bin/bash
export LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/"
cd "$md_inst/defendguin-0.0.11/"
setarch linux32 -L "$md_inst"/defendguin-0.0.11/defendguin --fullscreen
__EOF__

    chmod a+x "$romdir/box86/Defendguin.sh"
    chown $user:$user "$romdir/box86/Defendguin.sh"

    cat > "$romdir/box86/Defendguin-X11.sh" << __EOFX11__
#!/bin/bash
xset -dpms s off s noblank
export LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/"
cd "$md_inst/defendguin-0.0.11/"
matchbox-window-manager &
setarch linux32 -L "$md_inst"/defendguin-0.0.11/defendguin --fullscreen
__EOFX11__

    chmod a+x "$romdir/box86/Defendguin-X11.sh"
    chown $user:$user "$romdir/box86/Defendguin-X11.sh"
}
