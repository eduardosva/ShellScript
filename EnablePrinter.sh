#!/bin/sh
#
# Check if a printer queue is disabled and reenable it.

DISABLED=`lpstat -t | grep disabled | awk '{ print $2; }'`

for PRINTER in $DISABLED
do
        echo "Impressora $PRINTER esta desabilitada"
        cupsenable -h 127.0.0.1:631 $PRINTER && echo "Impressora $PRINTER foi habilitada"
done
