#!/bin/sh
# Simple wrapper script used to start File Protector in Debian
set -e

# First, the alternative (if known to work) or users preference as defined by $JAVA_HOME. Next, use OpenJDK or Sun's proprietary JDK.
# Override to a specific one using $JAVACMD
ALTERNATIVE_JDK="`readlink -n -f /etc/alternatives/java`"

# If OpenJDK 6 is only available headless, do not try it
if dpkg --get-selections openjdk-6-jre | grep install$ > /dev/null ; then
	JAVA_CMDS="$JAVA_HOME/bin/java /usr/lib/jvm/java-6-openjdk/bin/java /usr/lib/jvm/java-6-sun/bin/java"
else
	JAVA_CMDS="$JAVA_HOME/bin/java /usr/lib/jvm/java-6-sun/bin/java"
fi

JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true -Djava.net.useSystemProxies=true"

for jcmd in $JAVA_CMDS; do
	if [ "z$ALTERNATIVE_JDK" = "z`readlink -n -f $jcmd`" ] && [ -z "${JAVACMD}" ]; then
        JAVACMD="$jcmd"
    fi
done

for jcmd in $JAVA_CMDS; do
    if [ -x "$jcmd" -a -z "${JAVACMD}" ]; then
        JAVACMD="$jcmd"
    fi
done

if [ "$JAVACMD" ]; then
    echo "Using $JAVACMD to execute File Protector."
    
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
    
    exec $JAVACMD $JAVA_OPTS -Djava.ext.dirs=/usr/share/file-protector it.actalis.ellips.fp.FileProtector $ARGS "$@"
else
    echo "No valid JVM found to run File Protector."
    exit 1
fi
