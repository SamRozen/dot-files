# Python
pidof() {
    ps axc 2>/dev/null | awk "{if (\$5==\"$1\") print \$1}"
}

export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)