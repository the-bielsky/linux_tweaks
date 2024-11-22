#!/bin/bash

function new_api_session() {
  # usage: new_api_session <username> <password> <url>
  local USR=$1
  local PWD=$2
  local URL=$3
  local apicmd=$(curl -X POST \
    -H "Content-Type: application/json" \
    -d '{"username": "'${USR}'", "password": "'${PWD}'"}' \
    "${URL}/api/session" 
  )
  session_id=$(echo $apicmd | jq -r '.id')
  echo $session_id
}

function get_endpoint() {
  # usage   : get_endpoint <URL> <session_id> <endpoint>
  local URL=$1
  local session_id=$2
  local endpoint=$3
  local apicmd=$(curl -X GET \
    -H "Content-Type: application/json" \
    -H "X-Metabase-Session: ${session_id}" \
    "${URL}/api/${endpoint}" 
  )
  echo $apicmd
}

function post_endpoint() {
  # usage: post_endpoint <URL> <session_id> <endpoint> <data>
  #        post_endpoint $URL $session_id endpoint_name "$(cat ~/endpoint_backup.json)" | jq
  local URL=$1
  local session_id=$2
  local endpoint=$3
  local data=$4
  local apicmd=$(curl -X POST \
    -H "Content-Type: application/json" \
    -H "X-Metabase-Session: ${session_id}" \
    -d "${data}" \
    "${URL}/api/${endpoint}"
  )
  echo $apicmd
}
