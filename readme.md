VPNDemon
=========
### for Linux


VPNDemon monitors your VPN connection and upon disconnect, kills a target program. It's the safest and easiest way to help prevent DNS leaks and enhance your security while connected over a VPN.

![Screenshot 1](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot4.png)

It's as simple as this:

- Run vpndemon.sh.
- Enter the name of the target process to kill, upon VPN disconnect.

That's it!

Install
---

1. Download [vpndemon.sh](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/vpndemon.sh) and place it in a folder, such as ~/Documents/vpndemon.

 ```sh
 cd ~/Documents/vpndemon
 bash vpndemon.sh
 ```

2. Enter the name of a program to kill upon VPN disconnect, then click OK. This can be a substring of the name, such as "chrome", "firefox", etc.

 ![Enter a target process to kill upon VPN disconnect](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot2.png)

3. VPNDemon is now monitoring your VPN connection. Go ahead and connect to your VPN. VPNDemon will detect the connection and update its status.

 ![Detecting a VPN connection](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot3.png)

4. Try disconnecting your VPN. VPNDemon will detect the disconnect, kill all instances of the target program, and update its status.

 ![Detecting a VPN disconnect](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot3.png)

Technical Details
---

VPNDemon monitors the VPN connection by listening to events from the linux [NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager). When a VPN connect/disconnect event is received, the signal is checked to see which state it relates to. If it's a connect state, the status is simply displayed in the main window. If it's a disconnect state, VPNDemon immediately issues a kill command for all processes that match the target process name:

```sh
for i in `pgrep $killProgramName`
do
    kill $i
done
```

Since the NetworkManager is being listened to, directly via the [dbus-monitor](http://dbus.freedesktop.org/doc/dbus-monitor.1.html), disconnect events are detected almost instantly. Likewise, the target process is killed almost instantly.

VPNDemon should be compatible with any linux system that uses NetworkManager for VPN connections.


Troubleshooting
---

1. A log file is saved to /tmp/vpndemon, which contains the list of VPN connect/disconnect events and a list of processes terminated. The log is cleared each time the app is run. However, you can review the log during or after running the app, to help determine any troubleshooting issues.

License
----

MIT

Author
----
Kory Becker
http://www.primaryobjects.com/kory-becker
