#!/bin/bash

############ COLOURED BASH TEXT

# ANSI color codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


################################################################################################## FILE & FOLDER PATHS

# Location
APPLICATION="backup"
BASE="$HOME/bash.$APPLICATION"
FILES="$BASE/files"
APP_LIST="$FILES/packages.txt"

# Pre-Configuration
BASH="$HOME/order_66"


################################################################################################## PRINT MESSAGE

# Function to print colored messages
print_message() {
    local COLOR=$1
    local MESSAGE=$2
    echo -e "${COLOR}${MESSAGE}${NC}"
}


################################################################################################## INSTALLATION FUNCTIONS

packages_txt() {
    # Check if $HOME/bash directory exists, if not create it
    if [ ! -d "$BASH" ]; then
        mkdir -p "$BASH"
        print_message "$GREEN" "Created directory: $BASH"
    fi
    
    # Check if $HOME/bash.pkmgr exists, delete it if it does
    if [ -d "$HOME/bash.pkmgr" ]; then
        print_message "$YELLOW" "Removing existing $HOME/bash.pkmgr"
        rm -rf "$HOME/bash.pkmgr"
    fi
    
    # Copy ../files/packages.txt to /home/user/bash
    cp "$APP_LIST" "$BASH"
    print_message "$CYAN" "Copied $APP_LIST to $BASH"
    
    # Get the Package Manager & Package Installer
    git clone https://github.com/Querzion/bash.pkmgr.git "$HOME/bash.pkmgr"
    chmod +x -R "$HOME/bash.pkmgr"
    sh "$HOME/bash.pkmgr/installer.sh"
    
    print_message "$GREEN" "Applications installed successfully."
}


################################################################################################## MAIN FUNCTION

# Main function to manage backup based on filesystem type
manage_backup() {
    local filesystem=$(df -T / | awk 'NR==2 {print $2}')

    if [ "$filesystem" == "btrfs" ]; then
        FILES="$BASE/files"
        default_choice="s"
        tool="snapper"
    else
        FILES="$BASE/files"
        default_choice="t"
        tool="timeshift"
    fi

    # Function to create directory $BASH if it doesn't exist
    setup_bash_directory() {
        if [ ! -d "$BASH" ]; then
            mkdir -p "$BASH"
            print_message "$GREEN" "Created directory: $BASH"
        else
            print_message "$YELLOW" "Directory already exists: $BASH"
        fi
    }

    # Function to export packages.txt from specified source file
    export_packages_txt() {
        local source_file="$1"
        cp "$FILES/$source_file" "$BASH/packages.txt"
        print_message "$GREEN" "Exported $source_file to $BASH/packages.txt"
    }

    # Ask user for backup management tool choice
    read -p "Choose backup management tool (s for snapper / t for timeshift) [default: $default_choice]: " choice

    # Set choice to default if empty
    choice=${choice:-$default_choice}

    # Validate user choice and proceed with exporting the packages file
    if [ "$choice" == "s" ]; then
        setup_bash_directory
        export_packages_txt "snapper.txt"
        tool="snapper"
    elif [ "$choice" == "t" ]; then
        setup_bash_directory
        export_packages_txt "timeshift.txt"
        tool="timeshift"
    else
        print_message "$RED" "Invalid choice. Exiting."
        exit 1
    fi

    # Return the selected tool for further processing
    echo "$tool"
}


################################################################################################## CHECK INSTALLATION FUNCTION

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to handle configuration based on the application
backup_configuration() {
    local tool=$1

    if [ "$tool" == "snapper" ]; then
        if command_exists snapper; then
            print_message "$CYAN" "Configuring Snapper..."
            # Example configuration commands for snapper
            snapper create-config root
            snapper set-config NUMBER_CLEANUP="yes"
            print_message "$GREEN" "Snapper configuration complete."
        else
            print_message "$RED" "Snapper is not installed. Exiting."
            exit 1
        fi
    elif [ "$tool" == "timeshift" ]; then
        if command_exists timeshift; then
            print_message "$CYAN" "Configuring Timeshift..."
            # Example configuration commands for timeshift
            timeshift --create --comments "Initial backup"
            timeshift --schedule daily
            print_message "$GREEN" "Timeshift configuration complete."
        else
            print_message "$RED" "Timeshift is not installed. Exiting."
            exit 1
        fi
    else
        print_message "$RED" "Invalid tool specified. Exiting."
        exit 1
    fi
}

################################################################################################## MAIN LOGIC

# Snapper / Timeshift Packages.txt
selected_tool=$(manage_backup)

# Install Packages from $BASH/packages.txt
packages_txt

# Backup Configuration for Snapper / Timeshift
backup_configuration "$selected_tool"
