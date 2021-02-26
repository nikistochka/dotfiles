#!/usr/bin/env bash

################################
# Usage:
# tdownloader.sh file1.torrent
#
# TBD:
# - Download multiple files: tdownloader.sh file1.torrent file2.torrent
################################

SERVER_ADDRESS="1.2.3.4"
SERVER_USER="user1"
SERVER_PORT="22"
SERVER_KEY_PATH="~/.ssh/id_rsa"
SERVER_DOWNLOAD_PATH="/tmp"
ssh_command="ssh -i ${SERVER_KEY_PATH} -p ${SERVER_PORT} ${SERVER_USER}@${SERVER_ADDRESS}"

function error_date() {
    echo "[$(date +'%m-%d-%YT%H:%M:%S')]: $*" >&2
}

function log_date() {
    echo "[$(date +'%m-%d-%YT%H:%M:%S')]: $*" >&1
}

function check_rtorrent() {
    ${ssh_command} "which rtorrent>/dev/null"
    if [[ $? != 0 ]]; then
        log_date "Installing rtorrent"
        ${ssh_command} "apt-get update && apt-get install rtorrent"
        if [[ $? != 0 ]]; then
            error_date "Unable to install rtorrent"
            exit 1
        fi
    fi
}

function setup_rtorrent() {
    scp -i ${SERVER_KEY_PATH} -P ${SERVER_PORT} ./rtorrent.rc ${SERVER_USER}@${SERVER_ADDRESS}:${SERVER_DOWNLOAD_PATH}
    if [[ $? != 0 ]]; then
        error_date "Unable to upload rtorrent.rc file into home directory"
        exit 1
    fi
    scp -i ${SERVER_KEY_PATH} -P ${SERVER_PORT} ./stop_tdownloader.sh ${SERVER_USER}@${SERVER_ADDRESS}:${SERVER_DOWNLOAD_PATH}
    if [[ $? != 0 ]]; then
        error_date "Unable to upload ./stop_tdownloader.sh file into home directory"
        exit 1
    fi
    ${ssh_command} "mkdir -p ${SERVER_DOWNLOAD_PATH}/rtorrent.session"
}

function upload_tfile() {
    log_date "Starting uploading torrent file to the server"
    scp -i ${SERVER_KEY_PATH} -P ${SERVER_PORT} "$1" ${SERVER_USER}@${SERVER_ADDRESS}:${SERVER_DOWNLOAD_PATH}
    if [[ $? != 0 ]]; then
        error_date "Unable to upload torrent file"
        exit 1
    fi
}

function start_downloading() {
    log_date "Starting downloading"
    ${ssh_command} -t "rtorrent -n -d ./ -O import=${SERVER_DOWNLOAD_PATH}/rtorrent.rc -O session=${SERVER_DOWNLOAD_PATH}/rtorrent.session ${SERVER_DOWNLOAD_PATH}/$1"
    if [[ $? != 0 ]]; then
        error_date "Unable to download $1"
        exit 1
    else
        log_date "Download $1 is completed"
    fi
}

function main() {
    check_rtorrent
    setup_rtorrent
    upload_tfile "$1"
    start_downloading "$1"
    log_date "SUCCESS"
}

main "$@"

