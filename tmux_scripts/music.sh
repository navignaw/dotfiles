#!/usr/bin/env bash
#
# https://github.com/getmicah/spotify-now

music=$(spotify-now -i "%artist - %title")
echo "♫  $(echo $music | sed -E 's/(.{50})(.{1,})$/\1…/')"
