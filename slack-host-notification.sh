#!/usr/bin/python

from os import environ, unlink
from slackclient import SlackClient

CHANNEL = 'CHANNEL_ID'

filename = '/tmp/host-%s' % (environ['HOSTDISPLAYNAME'])

slack_client = SlackClient('AUTH_TOKEN')

message = """
*%s - %s* is %s
Additional Info: %s
""" % (environ['NOTIFICATIONTYPE'], environ['HOSTDISPLAYNAME'], environ['HOSTSTATE'], environ['HOSTOUTPUT'])

if environ['HOSTSTATE'] == 'DOWN':
    resp = slack_client.api_call("chat.postMessage", channel=CHANNEL, text=message)
    if 'ts' not in resp:
        print resp
    with open(filename, 'w') as fh:
        fh.write(resp['ts'])

elif environ['HOSTSTATE'] == 'UP':
    ts = ''
    with open(filename, 'r') as fh:
        slack_client.api_call("chat.delete", channel=CHANNEL, ts=fh.readline())
    unlink(filename)


