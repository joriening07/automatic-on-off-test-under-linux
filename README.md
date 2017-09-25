# automatic-on-off-test-under-linux
Using on/off switch to power on/off the Linux testing system, and login to run certain scripts. It's done in Bash Shell.

Preparation:
Ubuntu laptop with expect package installed; an ethernet switch; USB-serial port.
The under test unit (linux system) is under the power on/off control of the switch. The switch is connected to the laptop via LAN port. Under test unit is monitored by console (Telnet connection) on laptop via USB-serial cable. 

Assumption:
Laptop ethernet port is set to static 192.168.0.1
the first synacess power cycle is set to 192.168.0.2, the second 192.168.0.3 etc...
ping 192.168.0.2 to check the first synacess is correctly connected to laptop ethernet.
to be continued...
