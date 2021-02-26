#!/usr/bin/env bash

kill -9 $(cat ./rtorrent.session/rtorrent.pid)
rm -f -r ./rtorrent.session