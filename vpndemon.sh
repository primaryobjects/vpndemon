#!/bin/bash

killProgramName="calc"
interface="org.freedesktop.NetworkManager.VPN.Connection"
member="VpnStateChanged"
#isDone=0

# Monitor for VPNStateChanged event.
dbus-monitor --system "type='signal',interface='$interface',member='$member'" |
{
    # Read output from dbus.
    while read -r line #&& [ $isDone = 0 ]
    do
        # Check if this a VPN disconnected (uint32 7) event.
        if [ x"$(echo "$line" | grep 'uint32 7')" != x ]
        then
            echo ""
            date

            echo "VPN Disconnected!"

            # Disconnect network.
            # nmcli -p nm enable false

            # Kill target process.
            for i in `pgrep $killProgramName`
            do
                echo "Terminated $i."
                kill $i
            done

            #isDone=1
        fi
    done

    # Kill all threads and exit script.
    #kill $$
}