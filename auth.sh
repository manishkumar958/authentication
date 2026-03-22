

#!/bin/bash

DB="users.db"

# Function to hash password
hash_password() {
    echo -n "$1" | sha256sum | awk '{print $1}'
}

# Register User
register() {
    echo "------ Register ------"
    read -p "Enter username: " username

    # Check if user exists
    if grep -q "^$username:" $DB; then
        echo "❌ User already exists!"
        return
    fi

    read -s -p "Enter password: " password
    echo
    read -s -p "Confirm password: " confirm
    echo

    if [ "$password" != "$confirm" ]; then
        echo "❌ Passwords do not match!"
        return
    fi

    hashed=$(hash_password "$password")
    echo "$username:$hashed" >> $DB

    echo "✅ Registration successful!"
}

# Login User
login() {
    echo "------ Login ------"
    read -p "Enter username: " username
    read -s -p "Enter password: " password
    echo

    hashed=$(hash_password "$password")

    if grep -q "^$username:$hashed" $DB; then
        echo "✅ Login successful!"
    else
        echo "❌ Invalid username or password!"
    fi
}

# Menu
while true; do
    echo ""
    echo "==== User Authentication System ===="
    echo "1. Register"
    echo "2. Login"
    echo "3. Exit"
    read -p "Choose option: " choice

    case $choice in
        1) register ;;
        2) login ;;
        3) exit ;;
        *) echo "Invalid choice!" ;;
    esac
done
