# gdx

A Gnome DX Cluster client for Radio amateurs. It allows hamradio operators to connect to the Packet Radio DX Clusters network via telnet. Connection via the packet radio network not available at the moment but could be implemented.

## What is the a DXCluster network

The DX Cluster network it's a legacy service that used the packet radio network to broadcast dx information. Developed, initially, to use radio frequency AX25 networks links has migrated, mostly,  to the Internet.

There are a few software packages that implement this kind of service and due to the legacy they all provide a ASCII based interface to the user leaving the AK1A PC protocol to the cluster nodes. Well, this is not exactly true because some developers added additional commands to force the reception of dx spots with the PC protocol semantic. Of course this depends on the cluster node software to support it. Nevertheless support for different methods is necessary (standard and enhanced).

[More information](https://en.wikipedia.org/wiki/DX_cluster) available on Wikipedia

## Limitations

For many years, the service was provided solely by AK1A Packet Cluster software. This was a paid software and in the late 90's some alternatives started to emerge. Nowadays most nodes use DXSpider followed by AR-CLuster software.

These software applications provide a console based user interface (session) and they tried to implement the same, or almost similar, experience but each application has it's own minor variations. This means that some commands specific to the service software being used.

Nodes use a protocol, known as PC protocol, to communicate. Most of this protocol has been reverse engineered due to AK1A being a commercial product and lack of documentation.

To simplify, service specific commands will be left out.

###To Do

[ ] Remake connection (auto reconnect when: cnx lost, pc sleep, etc.)

[ ] Avoid UTF-8 errors

[ ] Improve parser

[ ] Persistent user defined column position

[ ] Handle treeview key events to respond solely to alpha numeric keys.

[ ] Filter DX Spots from console as Setting/Preference

##Notes

**List of Telnet DX Clusters**

http://www.g4bki.com/clusters.htm

**Client Commands (simple?)**

http://www.dxcluster.info/commands.htm

http://www.febo.com/packet/clx/clx-7.html

#Application Settings

- Callsign
- Default cluster
	- Connect at startup
	- Reconnect automatically
- Connection parameters (telnet login)

#Parser errors
- DX de <CALLSIGN>: if call too big : can be supressed!

#Application icon
![Img](
https://www.flaticon.com/free-icon/network_148800#term=network&page=1&position=33)

#Debug

To enable debug messages, set `export G__MESSAGES_DEBUG=all`
