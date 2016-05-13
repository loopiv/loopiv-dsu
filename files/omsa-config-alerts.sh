#!/bin/bash
#
# Enables all Dell OMSA alerts and sets a custom alert action.
#
OMCONFIG=/opt/dell/srvadmin/bin/omconfig
for I in `$OMCONFIG system alertaction | sed 's/ *(.*)//; s/>.*//; s/.*[:<] *// ; s/|/ /g;'`; do
   echo $I;
   $OMCONFIG system alertaction event=$I alert=true broadcast=false execappath="/usr/local/sbin/om-alert.sh"
done
