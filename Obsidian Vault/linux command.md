### Check Ports via lsof Command

The [lsof command](https://phoenixnap.com/kb/lsof-command) allows users to list the programs that utilize listening ports and daemons that maintain active network connections.

Use the **`lsof`** command to:

- Display a list of ports in use:

```
sudo lsof -nP -iTCP -sTCP:LISTEN
```

For example, to check if port 5054 is in use, type:

```
sudo lsof -nP -i:5054


For example, to check if the UDP port 53 is open, type:

sudo lsof -nP -iUDP:53

sudo netstat -tunpl

The following command scans TCP and UDP ports for listening sockets and displays them in a list:

sudo ss -tunl

###Check Ports via nmap Command

The [Nmap utility](https://phoenixnap.com/kb/nmap-scan-open-ports) allows users to scan for open ports on local and [remote systems](https://phoenixnap.com/glossary/what-is-remote-access). Execute the command below to scan for all open TCP and UDP ports on the local system:

```
     sudo nmap -n -PN -sT -sU -p- localhost  
```  

The following are the **`nmap`** options used in the example.

- **`-n`** - Skips DNS resolution.
- **`-PN`** - Skips the discovery phase.
- **`-sT`** and **`-sU`** - Tell **`netstat`** to scan TCP and UDP ports, respectively.
- **`-p-`** - Scans all the ports.


### Check Ports via nc Command

The [nc command](https://phoenixnap.com/kb/nc-command) in Linux allows users to control the **netcat** utility. **`netcat`** can scan the ports on local and remote systems and provide information on whether the ports are open, closed, or filtered by a firewall.

**Note**: In CentOS, RHEL, and Debian the natcat command is **`ncat`**.

Scan all the ports on the local system by typing:

```
      nc -z -v localhost 1-65535

The **`-z`** flag enables the zero-I/O mode used for scanning, while the **`-v`** option tells **`netcat`** to produce verbose output.

When the command is executed, **`netcat`** attempts to connect to all the ports and reports on the success for each port. Scanning many ports at once produces an extensive output.

To show only the ports where the connection succeeded, i.e., the open ports, use the **`2>$1`** expression to redirect the output. Then, pipe the expression to the [grep command](https://phoenixnap.com/kb/grep-command-linux-unix-examples) and search for the word **`succeeded`**.

     nc -z -v localhost 1-65535 2>&1 | grep succeeded