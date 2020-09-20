#!/usr/bin/env bash

# Take ownership of the output directory.
if ! chown $USER_ID:$GROUP_ID /MEGASync ; then
    # Failed to take ownership of /MEGASync .  This could happen when,
    # for example, the folder is mapped to a network share.
    # Continue if we have write permission, else fail.
    if s6-setuidgid $USER_ID:$GROUP_ID [ ! -w /MEGASync ]; then
        log "ERROR: Failed to take ownership and no write permission on /MEGASync."
        exit 1
    fi
fi
