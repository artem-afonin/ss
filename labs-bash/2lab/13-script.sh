#!/usr/bin/env bash

function info() {
    echo "#" "$@"
}

function error() {
    echo "#" "$@" 1>&2
}

function fatal() {
    error "$@"
    exit 1
}

DIR=
FILE=${HOME}/.bashrc
COMPILE="no"
RUN="no"

while (($# > 0)); do
    KEY="$1"
    VALUE="$2"
    case "$KEY" in
    -d)
        if [[ -z "$VALUE" ]]; then
            fatal "No directory passed with -d flag"
        fi
        if [[ -d "$VALUE" ]]; then
            DIR="$VALUE"
        else
            fatal "$VALUE is not valid directory"
        fi
        shift
        ;;
    -f)
        if [[ -z "$VALUE" ]]; then
            fatal "No file passed with -f flag"
        fi
        if [[ -f "$VALUE" ]]; then
            FILE="$VALUE"
        fi
        shift
        ;;
    -c)
        COMPILE="yes"
        ;;
    -r)
        if [[ "$COMPILE" == "yes" ]]; then
            RUN="yes"
        else
            error "-r flag used without -c flag"
            fatal "if you specified -c flag then place it before -r"
        fi
        ;;
    *)
        fatal "Unknown parameter: $KEY"
        ;;
    esac
    shift
done

if [[ -d "$DIR" ]]; then
    info "$DIR content:"
    ls -1 $DIR
fi

if [[ -f "$FILE" ]]; then
    info "$FILE content:"
    cat $FILE
fi

if [[ "$COMPILE" == "yes" ]]; then
    OUTPUT_FILE=${FILE%.c}
    OUTPUT_FILE=${OUTPUT_FILE%.cpp}
    gcc -o $OUTPUT_FILE $FILE
    EXIT_CODE=$?
    if [[ "$RUN" == "yes" && "$EXIT_CODE" == "0" ]]; then
        ./$OUTPUT_FILE
    fi
fi
