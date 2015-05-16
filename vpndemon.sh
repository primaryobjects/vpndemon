#!/bin/bash

interface="org.freedesktop.NetworkManager.VPN.Connection"
member="VpnStateChanged"
logPath="/tmp/vpndemon"
header="VPNDemon\nhttps://github.com/primaryobjects/vpndemon\n\n"

# Clear log file.
> "$logPath"

list_descendants()
{
    local children=$(ps -o pid= --ppid "$1")

    for pid in $children
    do
        list_descendants "$pid"
    done

    echo "$children"
}

# Consider the first argument as the target process
killProgramName="$1"
if [ -z "$killProgramName" ]
then
    killProgramName=$(zenity --entry --title="VPNDemon" --text="$header Enter name of process to kill when VPN disconnects:")
fi

result=$?
if [ $result = 0 ]
then
    if [ $killProgramName ]
    then
        header="$header Target: $killProgramName\n\n"

        (tail -f "$logPath") |
        {
            zenity --progress --title="VPNDemon" --text="$header Monitoring VPN" --pulsate

            # Kill all child processes upon exit.
            kill $(list_descendants $$)
        } |
        {
            # Monitor for VPNStateChanged event.
            dbus-monitor --system "type='signal',interface='$interface',member='$member'" |
            {
                # Read output from dbus.
                (while read -r line
                do
                    currentDate=`date +'%m-%d-%Y %r'`

                    # Check if this a VPN connection (uint32 2) event.
                    if [ x"$(echo "$line" | grep 'uint32 3')" != x ]
                    then
                        echo "VPN Connected $currentDate"
                        echo "# $header VPN Connected $currentDate" >> "$logPath"
                    fi

                    # Check if this a VPN disconnected (uint32 7) event.
                    if [ x"$(echo "$line" | grep 'uint32 7')" != x ]
                    then
                        echo "VPN Disconnected $currentDate"
                        echo "# $header VPN Disconnected $currentDate" >> "$logPath"

                        # Kill target process.
                        for i in `pgrep $killProgramName`
                        do
                            # Get process name.
                            name=$(ps -ocommand= -p $i | awk -F/ '{print $NF}' | awk '{print $1}')

                            # Kill process.
                            kill $i

                            # Log result.
                            echo "Terminated $i ($name)"
                            echo "Terminated $i ($name)" >> "$logPath"
                        done
                    fi
                done)
            }
        }
    else
        zenity --error --text="No process name entered."
    fi
fi
