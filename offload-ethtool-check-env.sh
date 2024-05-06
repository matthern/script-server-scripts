#!/bin/bash
# Check if the required environment variables are set
if [ -z "$SSH_USERNAME" ] || [ -z "$SSH_IP_ADDRESS" ]; then
    echo "Please set the SSH_USERNAME and SSH_IP_ADDRESS environment variables."
    exit 1
fi

# Function to check if a feature is enabled, used local to declared only in this function.
check_feature_enabled() {
    local feature="$1"
    local output
    output=$(ssh "$SSH_USERNAME"@"$SSH_IP_ADDRESS" "ethtool -k eno1 | grep -i \"$feature\" | awk '{print \$2}'")
    if [ "$output" == "off" ]; then
        return 0  # Feature is already disabled
    else
        return 1  # Feature is enabled
    fi
}

# Disable features if they are enabled

disable_feature() {
    local feature="$1"
    if check_feature_enabled "$feature"; then
        echo "Disabling $feature..."
	ssh "$SSH_USERNAME"@"$SSH_IP_ADDRESS" "ethtool -K eno1 $feature off"
    else
        echo "$feature is already disabled."
    fi
}

# Features to disable
features=("gso" "gro" "tso" "tx" "rx" "rxvlan" "txvlan" "sg")

# Disable each feature, features is array name and the [@] is every element.  

for feature in "${features[@]}"; do
    disable_feature "$feature"
done

