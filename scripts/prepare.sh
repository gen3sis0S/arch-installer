#!/bin/bash

################################################################################
##  █████╗ ██████╗  ██████╗██╗  ██╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗ ##
## ██╔══██╗██╔══██╗██╔════╝██║  ██║    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝ ##
## ███████║██████╔╝██║     ███████║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝  ##
## ██╔══██║██╔══██╗██║     ██╔══██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗  ##
## ██║  ██║██║  ██║╚██████╗██║  ██║    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗ ##
## ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ##
##                                                                            ##
## Author: gen3sis0s                                                          ##
## Github: https://github.com/gen3sis0s                                       ##
################################################################################


# Load common functions and variables
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/common.sh"


# Detect boot mode
if [[ -d /sys/firmware/efi/efivars ]]; then
    BOOT_MODE="UEFI"
    log_message INFO "Boot mode detected: UEFI"
else
    BOOT_MODE="BIOS"
    log_message INFO "Boot mode detected: BIOS"
fi

# Install yq for parsing YAML files
#if ! command -v yq &>/dev/null; then
#    log INFO "Installing yq for YAML parsing."
#    pacman -Sy --noconfirm yq
#fi



#-------------------------#
# TIME ZONE CONFIGURATION #
#-------------------------#
section_header "Time Zone Configuration"
log_message SUGGESTION "To list available time zones run 'timedatectl list-timezones'."
echo ""
prompt_input "Enter your time zone (e.g., 'America/New_York'): " "TIMEZONE" validate_timezone
echo ""
log_message INFO "Time zone set to: $TIMEZONE"



#----------------------#
# LOCALE CONFIGURATION #
#----------------------#
section_header "Locale Configuration"
log_message SUGGESTION "You can list available locales in /etc/locale.gen"
echo ""
prompt_input "Enter your locale (e.g., 'en_US.UTF-8'): " "LOCALE" validate_locale
echo ""
log_message INFO "Locale set to: $LOCALE"


#------------------------#
# HOSTNAME CONFIGURATION #
#------------------------#
section_header "Hostname Configuration"
echo ""
prompt_input "Enter a hostname for your system: " "HOSTNAME" 
echo ""
log_message INFO "Hostname set to: $HOSTNAME"



#--------------------#
# USER CONFIGURATION #
#--------------------#
section_header "User Account Creation"
echo ""
prompt_yes_no "Do you want to create a non root user?" "CREATE_USER"
echo ""

if [[ "$CREATE_USER" == "yes" ]]; then
    prompt_input "Enter a username for the new user: " "USERNAME"
    echo ""

    # Administrative privileges confirmation
    section_subheader "Administrative Privileges Confirmation"
    prompt_yes_no "Should the user '$USERNAME' have administrative privileges?" "IS_ADMIN"
    echo ""
    log_message INFO "User '$USERNAME' will have administrative privileges: $IS_ADMIN"

    # Set password for the new user (optional)
    section_subheader "Set Password User '$USERNAME'"
    prompt_yes_no "Do you want to set a password for user '$USERNAME' now?" "SET_USER_PASSWORD"
    echo ""

    if [[ "$SET_USER_PASSWORD" == "yes" ]]; then
        read -sp "Please enter the password for user '$USERNAME': " USER_PASSWORD
        echo ""
        read -sp "Please confirm the password: " USER_PASSWORD_CONFIRM
        echo ""

        if [[ "$USER_PASSWORD" != "$USER_PASSWORD_CONFIRM" ]]; then
            echo ""
            log_message CONFIRMATION_ERROR "Passwords do not match. The password will need to be set later."
            unset USER_PASSWORD
        else
            echo ""
            log_message INFO "Password for user '$USERNAME' will be set."
        fi
    else
        log_message SUGGESTION "It is important to set a password for all the users to increase the security!"
        echo ""
        log_message INFO "Password for user '$USERNAME' will be set later."
    fi
fi