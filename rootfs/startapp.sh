#!/usr/bin/env bash

set -u # Treat unset variables as an error.

trap "exit" TERM QUIT INT
trap "kill_mega" EXIT

log() {
    echo "[megaSupervisor] $*"
}

getpid_mega() {
    PID=UNSET
    PID="$(pgrep megasync)"
    if [ ! -f /proc/$PID/cmdline ] || ! cat /proc/$PID/cmdline | grep -qw "megasync"; then
        PID=UNSET
    fi
    echo "${PID:-UNSET}"
}

is_mega_running() {
    [ "$(getpid_mega)" != "UNSET" ]
}

start_mega() {
    tint2 &  # start tint2 for tray in openbox
    /defaults/megasync &
}

kill_mega() {
    PID="$(getpid_mega)"
    if [ "$PID" != "UNSET" ]; then
        log "Terminating MEGASync..."
        kill $PID
        wait $PID
    fi
}

if ! is_mega_running; then
    log "MEGASync not started yet.  Proceeding..."
    start_mega
fi

MEGA_NOT_RUNNING=0
while [ "$MEGA_NOT_RUNNING" -lt 5 ]
do
    if is_mega_running; then
        MEGA_NOT_RUNNING=0
    else
        MEGA_NOT_RUNNING="$(expr $MEGA_NOT_RUNNING + 1)"
    fi
    sleep 1
done

log "MEGASync no longer running.  Exiting..."
