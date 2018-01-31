#!/bin/bash

#nb: must be bash to support shopt globstar
set -e
shopt -s globstar

if [ "$BUILD_TOOLS" = false ]; then
    if grep 'step_[xy]' _maps/**/*.dmm;	then
        echo "step_[xy] variables detected in maps, please remove them."
        exit 1
    fi;
    if grep '\W\/turf\s*[,\){]' _maps/**/*.dmm; then
        echo "base /turf path use detected in maps, please replace with proper paths."
        exit 1
    fi;
    source $HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/byondsetup
    tools/travis/dm.sh -M${DM_MAPFILE} yogstation.dme
fi;
