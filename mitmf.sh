#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root." 1>&2
    exit 1
fi

# Check if the first argument is the interface (-i)
if [[ "$1" != "-i" ]]; then
    echo "Usage: $0 -i <interface> [other MITMf arguments]"
    exit 1
fi

# Get the interface argument
INTERFACE=$2

# Check if the interface is valid
if [ -z "$INTERFACE" ]; then
    echo "Error: Interface must be specified using -i." 1>&2
    exit 1
fi

# Verify the interface exists on the system
if ! ip link show "$INTERFACE" > /dev/null 2>&1; then
    echo "Error: Interface $INTERFACE does not exist." 1>&2
    exit 1
fi

# Enable IP forwarding temporarily on the host
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "IP forwarding is enabled."

# Save the current iptables configuration
echo "Saving current iptables configuration..."
iptables-save > /tmp/iptables-backup

# Modify iptables rules to allow traffic redirection (e.g., NAT, port redirection)
echo "Modifying iptables rules to allow redirection..."
# Redirection rule (for HTTP traffic)
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 10000
# MASQUERADE rule for NAT
iptables -t nat -A POSTROUTING -o "$INTERFACE" -j MASQUERADE
# Allow forwarding between interfaces
iptables -A FORWARD -i "$INTERFACE" -o "$INTERFACE" -j ACCEPT

# Run the Docker container with the provided parameters
docker run --rm --privileged --network host --cap-add=NET_ADMIN --cap-add=NET_RAW -it mitmf-docker "$@"

# Disable IP forwarding after the container has run
echo 0 > /proc/sys/net/ipv4/ip_forward
echo "IP forwarding is disabled."

# Restore the original iptables configuration
echo "Restoring original iptables configuration..."
iptables-restore < /tmp/iptables-backup
echo "Original iptables configuration restored."

# Clean up the backup file
rm /tmp/iptables-backup

