#!/usr/bin/env bash

usage_guide(){
    echo "parameters_printer.sh --first FIRST --second SECOND --third THIRD"
}

if [[ "$1" = "" ]]; then
    usage_guide
    exit 0
fi

while [[ "$1" != "" ]]; do
    case $1 in 
        --first )
            shift
            FIRST=$1
            ;;
        --second )
            shift
            SECOND=$1
            ;;
        --third )
            shift
            THIRD=$1
            ;;
        --help | -h )
            usage_guide
            exit 0
            ;;
        * )
            echo "Invalid parameter $1" >&2
            usage_guide
            exit 1
    esac
    shift
done

echo "first parameter = ${FIRST}, second parameter = ${SECOND}, THIRD = ${THIRD}"