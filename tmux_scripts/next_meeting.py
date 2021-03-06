#!/usr/bin/env python3
#
# Requires humanize (`pip3 install humanize`) and gcalcli.

import subprocess
from datetime import datetime, timedelta
from humanize import naturaltime
from typing import List

CALENDAR = 'ivan.wang@flyzipline.com'
GCALCLI_COMMAND = [
    'gcalcli', 'agenda', '--tsv', '--nodeclined', '--details', 'calendar']


def truncate(value: str, max_length: int) -> str:
    return value[:max_length] + (value[:max_length] and '…')


def get_recent_meeting(meetings: List[str], calendar: str) -> str:
    for line in meetings:
        if calendar not in line:
            continue  # Ignore other calendars

        next_meeting = line.split()
        time = datetime.strptime('{} {}'.format(*next_meeting[:2]), '%Y-%m-%d %H:%M')
        now = datetime.now()
        diff = now - time
        if diff > timedelta(minutes=30):
            continue  # Ignore events from more than 30 minutes ago.

        if diff < timedelta(hours=-12):
            break  # Ignore meetings more than 12 hours away.

        return '{}: {}'.format(
            naturaltime(diff), truncate(' '.join(next_meeting[4:-1]), 48))
    return 'No meetings today!'


if __name__ == '__main__':
    meetings = subprocess.run(
        GCALCLI_COMMAND,
        universal_newlines=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE).stdout

    print('📆  %s' % get_recent_meeting(meetings.split('\n'), CALENDAR))
