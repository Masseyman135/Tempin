#!/bin/bash

TEMPUSER="tempadmin"

# Must be run as root
if [ "$EUID" -ne 0 ]; then
    echo "Run as root or with sudo."
    exit 1
fi

# Create user if needed
if ! id "$TEMPUSER" >/dev/null 2>&1; then
    adduser "$TEMPUSER"
fi

# Add to sudo group
usermod -aG sudo "$TEMPUSER"

# Force password change at first login
passwd -e "$TEMPUSER"

# Delete the account automatically on logout
cat > /etc/profile.d/remove-tempadmin.sh <<EOF
#!/bin/bash

if [ "\$USER" = "$TEMPUSER" ]; then
    trap '
        echo "Removing temporary account..."
        (
            sleep 2
            pkill -u $TEMPUSER 2>/dev/null
            userdel -r $TEMPUSER 2>/dev/null
            rm -f /etc/profile.d/remove-tempadmin.sh
        ) &
    ' EXIT
fi
EOF

chmod +x /etc/profile.d/remove-tempadmin.sh

echo
echo "======================================"
echo "Temporary admin '$TEMPUSER' created."
echo "They will:"
echo "  ✓ Change their password on first login."
echo "  ✓ Have sudo access."
echo "  ✓ Be automatically deleted after they log out."
echo "======================================"
