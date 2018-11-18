# Nagios/Icinga slack notifications

## Background

I've found emails from nagios/icinga to be good 80% of the time, where a single service fails or becomes degraded and you receive a notification and then another once it has recovered.

Great!


However, there's times when a machine stops working and/or an underlying service fails and causes tens (if not hundreds) of alerts.

If the machine then comes right again, you'll be flooded with another load of notifications saying that they've come right.

If for example, you're in a meeting, or been woken up during the night with theses alerts, it's near impossible to check through all the failure notifications and all of the recovery notifications to determine if any are still failing.

This usually means that you'll need to... grab a laptop, login to numerous VPNs, login to the monitoring and check the status.

Other slack plugins for nagios are similar to the way that email notifications work and each time the service changes state, a new notification is sent.

This plugin works more like pagerduty (for those who can't afford the $$$ x 10^100, like me)...

When a host or service a down or critical (or other bad state) notifications, you'll get an alert in slack. When the error clears, the plugin then removes the message from slack.

This means that by looking at slack, you can easily identify all checks that are CURRENTLY failing.

Personally, I find this invaluable and hope others do to! :)

### TL;DR

A slack notiification for nagios that removes the messages once the service clears, meaning that you're left with a list of currently failing services.

## What this is

This is currently a working proof-of-concept, which pushes nagios notifications to slack (using the same message format default emails that are sent by icinga (except for a tiny bit of bold text))

## Install and use

### Install pre-requisites

On the nagios server, run:


    pip install SlackClient


### Install scripts

Copy scripts *.sh (even though they're python) into the /etc/icinga2/scripts directory (for icinga, chose an alternative directory for nagios)

### Configuring icinga/nagios

For installation on versions that provide the alert details as environment variables, copy the configuration used for the default mail-host-notification and mail-service-notification scipts.

For newer version, which use arguments to the script for the alert details, check the example.conf file for example configurations for passing the required variables.

### Configure script

Update the two scripts, adding the slack bot API key and the channel ID


### NOTE

The nagios user must be able to write to '/tmp'
