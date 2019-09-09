#!/bin/bash

CALENDAR="ivan.wang@flyzipline.com"
printf -v DATE '%(%Y-%m-%d)T' -1 

agenda=$(gcalcli agenda --tsv --nostarted --nodeclined --details calendar)
event=$(echo "$agenda" | grep "$CALENDAR" | grep "$DATE" | head -1 | sed -e "s/$CALENDAR$//g")
if [[ ! -z "$event" ]]; then
  echo $(echo $event | cut -d\  -f2,5-)  # Take the 2nd and 5th-to-last columns
else
  echo "No events scheduled"
fi
