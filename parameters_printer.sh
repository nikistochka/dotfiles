#!/usr/bin/env bash

FILE=
VERBOSE=0

function log_error_exit() {
    printf '%s\n' "$1" >&2
    exit 1
}

function show_help() {
cat << EOF 
USAGE:
parameters_printer.sh --file <FILEPATH> --second <SECOND> --third <THIRD>
EOF
}

function read_parameters(){
    if [[ "$1" = "" ]]; then
        show_help
        exit 0
    fi

    while [[ "$1" != "" ]]; do
        case "$1" in 
            -f|--file)
                if [ "$2" ]; then
                    FILE=$2
                    shift
                else
                    log_error_exit 'ERROR: "--file" requires a non-empty option argument.'
                fi
                ;;
            -f=?*|--file=?*)
                file=${1#*=} # Delete everything up to "=" and assign the remainder.
                ;;
            -f=|--file=)         # Handle the case of an empty --file=
                log_error_exit 'ERROR: "--file" requires a non-empty option argument.'
                ;;
            -v|--verbose)
                VERBOSE=$((VERBOSE + 1))  # Each -v adds 1 to verbosity.
                ;;
            -s|--second)
                SECOND=$2
                shift
                ;;
            -t|--third)
                THIRD=$2
                shift
                ;;
            -h|-\?|--help)
                show_help
                exit
                ;;
            * )
                echo "Invalid parameter $1" >&2
                show_help
                exit 1
        esac

        shift
    done
}


function main() {
    read_parameters "$@"
    echo "File path = ${FILE}, second parameter = ${SECOND}, third parameter = ${THIRD}, verbosity = ${VERBOSE}"
}

main "$@"
