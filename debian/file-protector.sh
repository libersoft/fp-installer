#!/bin/bash
# Simple wrapper script used to start File Protector in Debian
set -e

if [ -e "/usr/bin/java" ]; then
    
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH/bin:/usr/local/lib:/usr/lib:/usr/local/lib:/usr/share/file-protector:/usr/lib/file-protector
    #export PATH=$PATH:$JAVAHOME/bin
    #export PKCS11_SIA_DEBUG=1
    export DS_SYNCH_POLICY=1
    export DS_VERIFICATION_POLICY=2
    export DS_CREATION_POLICY=2
    export DS_NAME_PREFIX=Firma
    
    if [ $# -gt 0 ]; then
        ARGS="-v"
    fi
    
    exec java -Djava.ext.dirs=/usr/share/file-protector it.actalis.ellips.fp.FileProtector $ARGS "$@"
else
    echo "No valid JVM found to run File Protector."
    exit 1
fi
