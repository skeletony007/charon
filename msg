#!/bin/bash

eval "$(secure_curl 'https://raw.githubusercontent.com/skeletony007/charon/main/color')"

msg() {
    local prefix; local message; local redirect

    case $1 in
        -e|--error)
            prefix="${RED}Error:${NC} "; message="$2"; redirect=">&2"
            ;;
        -i|--info)
            prefix="${BLUE}==>${NC} "; message="$2"
            ;;
        -w|--warning)
            prefix="${YELLOW}Warning:${NC} "; message="$2"
            ;;
        --unknown-command)
            local command=$2
            msg -e "Unknown command: $command"
            ;;
        --downloading)
            local file=$2
            msg -i "${BOLD}Downloading${NC} $file"
            ;;
        --installing)
            local package_name=$2
            msg -i "${BOLD}Installing${NC} $package_name"
            ;;
        --uninstalling)
            local path="$2"
            local file_count=$(find $path -type f | wc -l | awk '{print $1}')
            local folder_size="$(du -hs "$path" | awk '{print $1}')B"
            msg "Uninstalling $path... ($file_count files, $folder_size)"
            ;;
        --not-upgrading)
            local program=$2
            msg -w "Not upgrading $program, the latest version is already installed"
            ;;
        *)
            message="$1"
            ;;
    esac

    eval "echo -e \"${prefix}${message}\" $redirect"
}

