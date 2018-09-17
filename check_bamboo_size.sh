#!/bin/bash

mysql_usr="$1"
mysql_passwd="$2"   # It is always better to use a file.
mysql_dbs="$3"

output_limit=52428800 # Only Build-Plans > 50 Mbytes

mysql -N -u$mysql_usr -p$mysql_passwd $mysql_dbs -e "SELECT FULL_KEY,STORAGE_TAG FROM BUILD WHERE BUILD_TYPE IN ('CHAIN','CHAIN_BRANCH') ORDER BY FULL_KEY;" 2>&1 | grep -v "Warning: Using a password" > /tmp/mysql_out.$$

directories=`cat /tmp/mysql_out.$$ | cut -f2`      # Build-Planen.
projects_string=`cat /tmp/mysql_out.$$ | cut -f1`  # Project Name.
projects_array=($projects_string)
typeset -i durchgang
durchgang=1

result=$(for i in $directories;
	do
		bambo_plan=`du -hcb /opt/atlassian/bamboo/artifacts/$i /opt/atlassian/bamboo/xml-data/builds/$i 2>/dev/null| tail -n 1 | cut -f1`  
		if [ $bambo_plan -gt $output_limit ]; then
	        	echo -n "${projects_array[$durchgang-1]}_$i=$bambo_plan "
		fi
		durchgang=$durchgang+1
done)

if [[ -z "$result" ]]; then
   echo "ERROR: Bamboo-Plan-Metrics not found." && exit 1
else
#   echo "OK: Bamboo-Plan-Metrics Found. | $result" && exit 0   # Nagios / Icinga output (Grafana)
   echo "$result" && exit 0 
fi

rm -fr /tmp/mysql_out.$$
