#!/bin/bash

OLDUSER="ben"
NEWUSER="Charlotte"

usermod -l "$NEWUSER" "$OLDUSER"
usermod -d "/home/$NEWUSER" -m "$NEWUSER"
groupmod -n "$NEWUSER" "$OLDUSER"
chown -R "$NEWUSER:$NEWUSER" "/home/$NEWUSER"

echo "Renamed $OLDUSER to $NEWUSER successfully."
