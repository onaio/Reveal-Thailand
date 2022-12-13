#!/bin/bash
set -uo pipefail

PROFILE="VPN_Biophics_New-Project"
USER="biophicsvpn09"

cleanup() {
  echo "You're being logout! kindly wait"
  naclient logout
  echo "You're logout"
}

init() {
  if [[ $EUID != 0 ]]; then
      echo "Please run as root"
      exit
  fi
  if [[ -z "$REVEAL_TH_PREVIEW_NACLIENT_PASSWORD" ]]; then
    echo "'REVEAL_TH_PREVIEW_NACLIENT_PASSWORD' environment need to be set. Check the bitwarden collection."
    exit 1
  fi
  trap cleanup EXIT
  while true; do
    status=$(naclient status)
    exit_code=$?
    if [[ $exit_code -eq 8 || $exit_code -eq 4 ]]; then
      echo "naclient (re)starting"
      yes y | naclient login -profile $PROFILE -user $USER -password $REVEAL_TH_PREVIEW_NACLIENT_PASSWORD
      updateResolveConf
    elif [[ $exit_code -eq 1 ]]; then
      echo "successful" >/dev/null
    else
      echo "Unknown exit code $exit_code, status $status"
    fi
    sleep 2
  done
}

updateResolveConf() {
  firstLine=$(head -n1 /etc/resolv.conf)
  if [[ $firstLine != "nameserver 8.8.8.8" ]]; then
    sed -i '1s/^/nameserver 8.8.8.8\n/' /etc/resolv.conf
  fi
}

init
