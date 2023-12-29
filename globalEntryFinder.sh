#!/bin/bash

location1=14321  # Charlotte-Douglas - DOWNSTAIRS LOCATION
location2=6880   # Charlotte-Douglas International Airport
slack_webhook_url="https://hooks.slack.com/services/{webhook}"

while true; do
  payload1=$(curl -s "https://ttp.cbp.dhs.gov/schedulerapi/slots?orderBy=soonest&limit=1&locationId=$location1&minimum=1")
  payload2=$(curl -s "https://ttp.cbp.dhs.gov/schedulerapi/slots?orderBy=soonest&limit=1&locationId=$location2&minimum=1")

  check_and_notify() {
    if echo "$1" | grep "locationId"; then
      echo "$1" | grep "startTimestamp"

      echo $start_timestamp
      # Send Slack notification

      # curl -X POST -H "Content-type: application/json" --data "{\"text\":\"Appointment available for location $2!\nLocation ID: $location_id\nStart Timestamp: $start_timestamp\"}" "$slack_webhook_url"
      curl -X POST -H "Content-type: application/json" --data "{\"text\":\"An appointment is available at CLT\"}" "$slack_webhook_url"

      tput bel

      exit 0
    else
      echo "Nothing available for location $2. Checked $(date)"
    fi
  }

  check_and_notify "$payload1" "location1"
  check_and_notify "$payload2" "location2"

  sleep 60
done