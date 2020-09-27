#!/bin/bash
# ------------------------------------------------------------------
# Copyright:  Patrick Byrne
# License:      GNU GPLv3
# Author:       Patrick Byrne
# Title:        amcrest_timelapse
# Description:  A tool to take a series of still images and make a timelapse
#         
# ------------------------------------------------------------------
#    Todo:
#           - DRY code
#           - Backup the timelapse dir
#           - Add frame delay option
#           - Add output folder/name option
# ------------------------------------------------------------------

# --- Variables ----------------------------------------------------

version=0.1.0

# --- Functions ----------------------------------------------------

version()	
{
  printf "Version: %s\n" $version
}

usage() 
{
    cat <<"STOP"
    Usage: amcrest_timelapse.sh [OPTIONS]

    OPTIONS

      -h  --help      Print this message
      -v  --version   Print Version 
      -H  --host      Hostname or IP
      -p  --port      Port
      -f  --freq      Frequency in seconds to take snapshots
      -d  --duration  Duration in minutes to capture     

STOP
}

check_dir()
{
  if [[ ! -d "$1" ]]; then
    mkdir -p "$1";
  fi
}

# --- Options processing -------------------------------------------

while [[ $# -gt 0 ]]; do
  param=$1
  value=$2
  case $param in
    -h | --help | help)
      usage
      exit
      ;;
    -v | --version | version)
      version
      exit
      ;;
    -H | --host)
      hostname=$value
      shift
      ;;
    -u | --user)
      username=$value
      shift
      ;;
    -p | --pass)
      password=$value
      shift
      ;;
    -P | --port)
      port=$value
      shift
      ;;
    -f | --freq)
      freq=$value
      shift
      ;;
    -d | --dur)
      dur=$value
      shift
      ;;
    *)
      echo "Error: unknown parameter \"$param\""
      usage
      exit 1
      ;;
  esac
  shift
done

# --- Body ---------------------------------------------------------

# Validate hostname
if [[ -z $hostname ]]; then
  echo "No hostname, quitting"
  exit 0
elif ! ping -c1 "$hostname" > /dev/null; then
  echo "Host unreachable"
  exit 0
fi

# Validate username
if [[ -z $username ]]; then
  echo "No username, quitting"
  exit 0
fi

# Validate password
if [[ -z $password ]]; then
  echo "No password, quitting"
  exit 0
fi

# Validate port
if [[ -z $port ]]; then
  echo "No port, quitting"
  exit 0
fi

# Validate frequency
if [[ -z $freq ]]; then
  echo "No frequency, quitting"
  exit 0
fi

# Validate duration
if [[ -z $dur ]]; then
  echo "No duration, quitting"
  exit 0
fi

# Convert duration to end time
end_time=$(date -ud "now + $dur minutes" +%s)

# Setup timelapse folder
check_dir "./timelapse_output"

# Capture loop
while [[ $(date -ud "now" +%s) -lt $end_time ]]; do
  echo working
  wget --quiet -O "./timelapse_output/$(date +%y.%m.%d-%H.%M.%S)_timelapse.jpg"  "http://${username}:${password}@${hostname}:${port}/cgi-bin/snapshot.cgi" 
  sleep "$freq"
done

# Create the timelapse
ffmpeg -framerate 30 -pattern_type glob -i "./timelapse_output/*.jpg" "timelapse_$(date +%m.%d.%y-%H.%M).gif"
