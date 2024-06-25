#!/bin/bash
# Dynamically opens images or pdfs based on filetype

if [ -z "$1" ]; then
  echo "Usage: open {filename}"
  return 0
fi

# Check if directory or file
if [ -d "$1" ]; then
  nautilus $1 # open directory
elif [ -f "$1" ]; then
  if [ ${1: -4} == ".pdf" ]; then
    evince "$1" & # pdf
  elif [ ${1: -4} == ".png" ] || [ ${1: -4} == ".jpg" ] || [ ${1: -4} == ".gif" ]; then
    eog "$1" & # image files
  fi
else
  echo "File does not exist"
fi
