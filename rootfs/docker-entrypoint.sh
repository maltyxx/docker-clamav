#!/bin/sh

# Update virus database
echo "Database Updater..."
freshclam

# Add all script
if [ -d /entrypoint.d ]; then
    for f in /entrypoint.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

exec "$@"
