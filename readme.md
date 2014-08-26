VPNDemon
=========
### for Linux


VPNDemon monitors your VPN connection and kills a target program upon disconnect. It's the safest and easiest way to help prevent DNS leaks and enhance your security while connected over a VPN.

![Screenshot 1](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot4.png)

It's as simple as this:

- Run vpndemon.sh.
- Enter the name of the target process to kill when the VPN disconnects.

That's it!

Install
---

1. Download [vpndemon.sh](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/vpndemon.sh) and place it in a folder, such as ~/Documents/vpndemon.
 ```sh
 cd ~/Documents/vpndemon
 bash vpndemon.sh
 ```

2. Enter the name of a program to kill when the VPN disconnects. This can be a substring of the name, such as "chrome", "firefox", etc.

 ![Enter a target process to kill upon VPN disconnect](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot1.png)

3. Click OK to start monitoring.

 ![Monitoring VPN connection](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot2.png)

3. VPNDemon is now monitoring your VPN connection. If your not already connected to your VPN, go ahead and connect now.

 ![Detecting a VPN connection](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot3.png)

4. Try disconnecting your VPN. VPNDemon will detect the disconnect, kill all instances of the target program, and update its status.

 ![Detecting a VPN disconnect](https://raw.githubusercontent.com/primaryobjects/vpndemon/master/screenshots/screenshot4.png)

Installing as an Application
---

1. Set the script to have executable permissions by right-clicking vpndemon.sh, select Properties, click Permissions tab, and checkmark "Execute" for all 3 rows.

2. Create an application entry by navigating to /usr/share/applications and creating a file named VPNDemon.desktop with the following content:
 ```sh
 [Desktop Entry]
 Version=1.0
 Type=Application
 Exec=/home/YOURUSERNAME/Documents/vpndemon/vpndemon.sh
 Name=VPNDemon
 Icon=/usr/share/icons/gnome/32x32/devices/ac-adapter.png
 ```

3. Open the start menu and search for VPNDemon. Right-click the result and select "Add to Panel" or "Add to Desktop".

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
