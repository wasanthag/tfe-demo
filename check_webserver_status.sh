#!/bin/bash
url=`terraform output Windows_Server_Public_IP | awk -F '"' '{print $2}'`
set -x
attempts=5
timeout=30
online=false

echo "Checking status of $url."

for (( i=1; i<=$attempts; i++ ))
do
  code=`curl -s --connect-timeout 20 --max-time 30 -w "%{http_code}\\n" $url -o /dev/null`

  echo "Found code $code for $url."

  if [ "$code" = "200" ]; then
    echo "Website $url is online."
    online=true
    break
  else
    echo "Website $url seems to be offline. Waiting $timeout seconds."
    sleep $timeout
  fi
done

if $online; then
  echo "Monitor finished, website is online."
  exit 0
else
  echo "Monitor failed, website seems to be down."
  exit 1
fi
