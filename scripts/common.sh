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


###################################################
##  _____                 _   _                  ##
## |  ___|   _ _ __   ___| |_(_) ___  _ __  ___  ##
## | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __| ##
## |  _|| |_| | | | | (__| |_| | (_) | | | \__ \ ##
## |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/ ##
##                                               ##
###################################################

display_menu() {
    local PROMPT="$1"
    shift
    local OPTIONS=("$@")
    local NUM_OPTIONS=${#OPTIONS[@]}
    local i

    echo "$PROMPT"
    for (( i=0; i<NUM_OPTIONS; i+=2 )); do
        echo "${OPTIONS[i]}) ${OPTIONS[i+1]}"
    done

    while true; do
        read -p "Enter your choice: " CHOICE
        for (( i=0; i<NUM_OPTIONS; i+=2 )); do
            if [[ "$CHOICE" == "${OPTIONS[i]}" ]]; then
                echo "${OPTIONS[i]}"
                return
            fi
        done
        echo "Invalid selection. Please try again."
    done
}

logotype () {
    echo ""
    echo "  █████╗ ██████╗  ██████╗██╗  ██╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗"
    echo " ██╔══██╗██╔══██╗██╔════╝██║  ██║    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝"
    echo " ███████║██████╔╝██║     ███████║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝"
    echo " ██╔══██║██╔══██╗██║     ██╔══██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗"
    echo " ██║  ██║██║  ██║╚██████╗██║  ██║    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗"
    echo " ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝"
    echo "|--------------------------------------------------------------------------|"
    echo "|                           Author: gen3sis0s                              |"
    echo "|                     Github: https://github.com/gen3sis0s                 |"
    echo "|--------------------------------------------------------------------------|"
    echo ""
}


log_message () {
    local LEVEL="$1"
    shift
    local MESSAGE="$@"

    case "$LEVEL" in
        INFO)
            echo -e "\e[32m[INFO]\e[0m $MESSAGE \n"
            ;;
        WARN)
            echo -e "\e[33m[WARN]\e[0m $MESSAGE \n"
            ;;
        ERROR)
            echo -e "\e[31m[ERROR]\e[0m $MESSAGE \n"
            ;;
        SUGGESTION)
            echo -e "\e[34m[!]\e[0m $MESSAGE"
            ;;
        *)
            echo -e "\e[34m[LOG]\e[0m $MESSAGE \n"
            ;;
     
    esac
}

prompt_input() {
    local PROMPT="$1"
    local VARIABLE_NAME="$2"
    local INPUT

    while true; do
        read -p "$PROMPT" INPUT
        if [[ -n "$INPUT" ]]; then
            eval "$VARIABLE_NAME='$INPUT'"
            break
        else
            echo "Input cannot be empty. Please try again."
        fi
    done
}


prompt_yes_no() {
    local PROMPT="$1"
    local VARIABLE_NAME="$2"
    local RESPONSE

    while true; do
        read -p "$PROMPT [y/n]: " RESPONSE
        case "$RESPONSE" in
            [yY][eE][sS]|[yY])
                eval "$VARIABLE_NAME='yes'"
                break
                ;;
            [nN][oO]|[nN]|'')
                eval "$VARIABLE_NAME='no'"
                break
                ;;
            *)
                echo "Invalid response. Please enter 'y' or 'n'."
                ;;
        esac
    done
}

section_header() {
    local TITLE="$1"
    echo    "|--------------------------------------------------------------------------|"
    echo -e "|\e[96m                           $TITLE                        \e[0m|" 
    echo    "|--------------------------------------------------------------------------|"
}

validate_locale() {
    local LOC="$1"
    if grep -Eq "^[# ]*$LOC" /etc/locale.gen; then
        return 0
    else
        return 1
    fi
}

validate_timezone() {
    local TZ="$1"
    if [ -f "/usr/share/zoneinfo/$TZ" ]; then
        return 0
    else
        return 1
    fi
}

################################
##  END OF FUNCTIONS SECTION  ##
################################