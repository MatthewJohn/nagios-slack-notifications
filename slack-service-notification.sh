#!/usr/bin/python

from os import environ, unlink, path
from slackclient import SlackClient

CHANNEL = 'CHANNEL_ID'

filename = '/tmp/host-%s-%s' % (environ['HOSTDISPLAYNAME'], environ['SERVICEDISPLAYNAME'])
state_filename = '/tmp/host-%s-%s-state' % (environ['HOSTDISPLAYNAME'], environ['SERVICEDISPLAYNAME'])

slack_client = SlackClient('AUTH_TOKEN')

message = """
*%s - %s - %s* is %s

Notification Type: %s

Service: %s
Host: %s
Address: %s
State: %s

Date/Time: %s

Additional Info: %s

Comment: [%s] %s
""" % (environ['NOTIFICATIONTYPE'], environ['HOSTDISPLAYNAME'], environ['SERVICEDISPLAYNAME'], environ['SERVICESTATE'], environ['NOTIFICATIONTYPE'], environ['SERVICEDESC'], environ['HOSTALIAS'], environ['HOSTADDRESS'], environ['SERVICESTATE'], environ['LONGDATETIME'], environ['SERVICEOUTPUT'], environ['NOTIFICATIONAUTHORNAME'], environ['NOTIFICATIONCOMMENT'])

new_state_string = '%s-%s' % (environ['SERVICESTATE'], environ['NOTIFICATIONTYPE'])
old_state_string = ''

if path.isfile(state_filename):
    with open(state_filename, 'r') as fh:
        old_state_string = fh.readline()

if environ['SERVICESTATE'] == 'OK' or new_state_string != old_state_string:
    if path.isfile(filename):
        with open(filename, 'r') as fh:
            slack_client.api_call("chat.delete", channel=CHANNEL, ts=fh.readline())
        unlink(filename)

if environ['SERVICESTATE'] != 'OK' and environ['NOTIFICATIONTYPE'] not in ['RECOVERY', 'ACKNOWLEDGEMENT', 'FLAPPINGSTOP', 'FLAPPINGDISABLED', 'DOWNTIMESTART', 'DOWNTIMEEND', 'DOWNTIMECANCELLED']:
    resp = slack_client.api_call("chat.postMessage", channel=CHANNEL, text=message)
    with open(filename, 'w') as fh:
        fh.write(resp['ts'])
    with open(state_filename, 'w') as fh:
        fh.write(new_state_string)


