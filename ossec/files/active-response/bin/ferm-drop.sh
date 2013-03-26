#!/bin/sh
# Adds an IP to the /etc/ferm/ferm.d/ossec.ferm file, and reloads ferm.
# Prerequisites: ferm, with a main config file at /etc/ferm/ferm.conf,
#                which in turn includes /etc/ferm/ossec.ferm as the first
#                set of rules
# Expect: srcip, rule
# Author: Ben Chavet <ben.chavet@lullabot.com>
# Last modified: June 25, 2012

ACTION=$1
USER=$2
IP=$3
RULE=$5

LOCAL=`dirname $0`;
FERM='/etc/ferm/ossec.ferm'
NOW=`date +"%Y-%m-%d %H:%M:%S %Z"`

# Logging the call
echo "`date` $0 $1 $2 $3 $4 $5" >> ${LOCAL}/../../logs/active-responses.log

# IP Address must be provided
if [ "x${IP}" = "x" ]; then
    echo "$0: Missing argument <action> <user> (ip)"
    exit 1;
fi

# Adding the ip to ferm
if [ "x${ACTION}" = "xadd" ]; then
    echo "table filter chain INPUT saddr ${IP} mod comment comment \"Added by OSSEC rule ${RULE}: ${NOW}\" jump OSSEC;" >> ${FERM}

# Deleting the ip from ferm
elif [ "x${ACTION}" = "xdelete" ]; then
    sed -i /${IP}/d ${FERM}

# Invalid action
else
    echo "$0: invalid action: ${ACTION}"
    exit 1
fi

# Update running rules
/usr/sbin/ferm /etc/ferm/ferm.conf
exit $?
