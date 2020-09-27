# amcrest_timelapse

This script will generate a timelapse from an Amcrest security camera. 

## Requirements
  * bash
  * ffmpeg
  * wget

## Usage

    amcrest_timelapse.sh [OPTIONS]

    OPTIONS

      -h  --help      Print this message
      -v  --version   Print Version 
      -H  --host      Hostname or IP
      -p  --port      Port
      -f  --freq      Frequency in seconds to take snapshots
      -d  --duration  Duration in minutes to capture     

#### Example

This example will create a timelapse from a camera at 192.168.1.10 on port 80. 
A username and password specified by '-u' and '-p' will be used to authenticate.
It will capture a frame every thirty seconds for 8 hours (480 minutes). 
The individual frames will be stored and a timelapse .gif file will be produced. 

```
amcrest_timelapse.sh -H 192.168.1.10 -P 80 -f 30 -d 480 -u user1 -p somepassword
working
working
...
```

