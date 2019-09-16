#!/usr/bin/env python
#
# Requires humanize (`pip3 install humanize`) and gcalcli.

import subprocess
from datetime import datetime
from humanize import naturaltime

CALENDAR = 'ivan.wang@flyzipline.com'
GCALCLI_COMMAND = [
    'gcalcli', 'agenda', '--tsv', '--nostarted', '--nodeclined', '--details', 'calendar']


if __name__ == '__main__':
    print('hello')
    meetings = subprocess.run(
        GCALCLI_COMMAND,
        universal_newlines=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE).stdout
    try:
        next_meeting = next(
            line for line in meetings.split('\n') if CALENDAR in line).split()
        time = datetime.strptime('{} {}'.format(*next_meeting[:2]), '%Y-%m-%d %H:%M')
        now = datetime.now()
        diff = now - time
        print('{}: {}'.format(naturaltime(diff), ' '.join(next_meeting[4:-1])))
    except StopIteration:
        print('No meetings scheduled!')
print('hello')
