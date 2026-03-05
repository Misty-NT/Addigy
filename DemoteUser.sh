#!/bin/bash

echo "Starting admin cleanup..."

APPROVED_USERS=("root" "AddigySSH" "networktitan" "ntadmin" "itadmin" "support")

ADMIN_USERS=$(dscl . -read /Groups/admin GroupMembership | cut -d " " -f2-)

for user in $ADMIN_USERS; do

    approved=false

    for allowed in "${APPROVED_USERS[@]}"; do
        if [[ "$user" == "$allowed" ]]; then
            approved=true
        fi
    done

    if [[ "$user" == Addigy* ]]; then
        approved=true
    fi

    if [[ "$user" == *it* ]] || [[ "$user" == *IT* ]]; then
        approved=true
    fi

    if [ "$approved" = false ]; then
        echo "Removing admin rights from $user"
        dseditgroup -o edit -d "$user" -t user admin
    else
        echo "Keeping approved admin: $user"
    fi

done

echo "Admin cleanup complete."
