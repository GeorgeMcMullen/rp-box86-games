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

rp_module_id="malditacastillalinux"
rp_module_desc="Maldita Castilla by Locomalito"
rp_module_licence="CC https://locomalito.com/maldita_castilla.php"
rp_module_section="opt"
rp_module_flags="!all rpi4"

function depends_malditacastillalinux() {
    # On RPI systems, we need to make sure Box86 is installed.
    if isPlatform "rpi"; then
        if ! rp_isInstalled "box86" ; then
            md_ret_errors+=("Sorry, you need to install the Box86 scriptmodule")
            return 1
        fi
    fi
}

function install_bin_malditacastillalinux() {
    echo "Downloading Maldita Castilla to $md_inst"
    downloadAndExtract "https://locomalito.com/juegos/Maldita_Castilla_linux.tgz" "$md_inst"
}

function configure_malditacastillalinux() {
    cat > "$romdir/box86/Maldita Castilla (Locomalito).sh" << __EOFX11__
#!/bin/bash
xset -dpms s off s noblank
export LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/"
cd "$md_inst/MalditaCastilla/"
matchbox-window-manager &
setarch linux32 -L "$md_inst"/MalditaCastilla/runner
__EOFX11__

    chmod a+x "$romdir/box86/Maldita Castilla (Locomalito).sh"
    chown $user:$user "$romdir/box86/Maldita Castilla (Locomalito).sh"
}
