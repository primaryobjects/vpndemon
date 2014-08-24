#!/bin/bash

killProgramName="calc"
interface="org.freedesktop.NetworkManager.VPN.Connection"
member="VpnStateChanged"

# Clear log file.
> /tmp/testpipe

(tail -q -f /tmp/testpipe) |
{
    zenity --progress --title="VPNDemon" --text="Monitoring VPN"

    # Kill all child processes upon exit. kill 0 sends a SIGTERM to the whole process group, thus killing also descendants.
    trap "kill 0" SIGINT SIGTERM EXIT

    # Terminate app.
    kill $$
} |
{
    # Monitor for VPNStateChanged event.
    dbus-monitor --system "type='signal',interface='$interface',member='$member'" |
    {
        # Read output from dbus.
        (while read -r line
        do
            # Check if this a VPN disconnected (uint32 7) event.
            if [ x"$(echo "$line" | grep 'uint32 7')" != x ]
            then
                currentDate=`date +'%m-%d-%Y %r'`

                echo "VPN Disconnected $currentDate"
                echo "# VPN Disconnected $currentDate" > '/tmp/testpipe'

                # Kill target process.
                for i in `pgrep $killProgramName`
                do
                    echo "Terminated $i."
                    kill $i
                done
            fi
        done)
    }
}
