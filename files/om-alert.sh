#!/bin/sh
#
# Custom Dell OMSA action.
# Inserts data and arbitrary contents into a file.
#
HOST=`hostname`
DATE=`date`
cat > /root/omsa_alert.txt << EOF

$DATE

There has been a Dell OpenManage ALERT detected on $HOST.

Please login to the web interface to see details.
=> URL = https://$HOST:1311

- OR -

Check the log via commandline
=> /opt/dell/srvadmin/bin/omreport system alertlog

EOF

