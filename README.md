# gdx

A DX Cluster client for Radio amateurs. It allows hamradio operators to connect to the Packet Radio DX Clusters network via telnet. Connection via the packet radio network not available at the moment but could be implemented.

## What is the a DX Cluster network

The DX Cluster network it's a legacy service, still in active use today, that used the packet radio network to broadcast dx information. Developed, initially, to use RF network links (AX25), it has migrated, mostly, to the Internet.

## DX Cluster node software
There are a few software packages that implement this kind of service and due to the legacy they all provide a ASCII based interface to the user leaving the [AK1A PC protocol](http://www.dxcluster.org/tech/pcprot.html) to the cluster nodes. Well, this is not exactly true because some developers added additional commands to force the reception of dx spots with the [PC protocol](http://www.dxcluster.org/tech/pcprot.html) semantic. Of course this depends on the cluster node software to support it. Nevertheless, support for different methods is necessary (standard and enhanced).

[More information](https://en.wikipedia.org/wiki/DX_cluster) available on Wikipedia

## Limitations

For many years, the service was provided solely by AK1A Packet Cluster software. This was a paid software and in the late 90's some alternatives started to emerge. Nowadays most nodes use [DXSpider](http://www.dxcluster.org/main/) or AR-Cluster.

These software applications provide a console based user interface (session) and they tried to implement the same, or almost similar, experience but each application has it's own minor variations. This means that some commands specific to the service software being used.

Nodes use a protocol, known as [PC protocol](http://www.dxcluster.org/tech/pcprot.html), to communicate. Most of this protocol has been reverse engineered due to AK1A being a commercial product and lack of documentation.

## Screenshot

![Screenshot](/data/screenshots/screenshot1dark.png "Screenshot")

# Building and running

Start by cloning this repository:

	$ git clone https://github.com/phastmike/gdx

To build it, `cd` into it and run:

	$ meson build && cd build && ninja

Then run it with:

	$ ./src/gdx

If you wish to install gdx then run

	$ sudo ninja install

## Dependencies

* meson (>= 0.40.0)
* ninja (>= 1.8.2)
* valac (>= 0.38.3)
* Gtk+ (>= 3.22)

Probably will work with some previous versions but has not been tested.


# To Do

- [ ] Avoid UTF-8 errors

- [ ] Improve parser

- [ ] Persistent user defined column position

- [x] ~~Handle treeview key events to respond solely to alpha numeric keys.~~

- [ ] Filter DX Spots from console (Client side)

- [ ] Fix `DX de <CALLSIGN>` when call is to big and strips colon delimiter

# Resources

**List of Telnet DX Clusters**

[http://www.g4bki.com/clusters.htm](http://www.g4bki.com/clusters.htm)

**Client Commands**

* [http://www.dxcluster.info/commands.htm](http://www.dxcluster.info/commands.htm)

* [http://www.febo.com/packet/clx/clx-7.html](http://www.dxcluster.info/commands.htm)

## Application icon
Icon from [Flaticon](http://www.flaticon.com):

[![AppIcon](/data/icons/hicolor/48x48/apps/org.ampr.ct1enq.gdx.png "Application icon")](https://www.flaticon.com/free-icon/network_148800#term=network&page=1&position=33)

## Debug

To enable debug messages, set:

    export G__MESSAGES_DEBUG=all

## First use

* User must set their callsign (default NOCALL) before connecting to any node

## Info on Frames

	00000000011111111112222222222333333333344444444445555555555666666666677777777778
	12345678901234567890123456789012345678901234567890123456789012345678901234567890
	 14233.0  SV9OFS      19-May-2010 2215Z  tnx kontantinos 73          <YV5HNJ>    # Show Dx result
	DX de PY3CEJ:     1826.0  9U4M         559 Good signal live my site   2253Z GG40 # Real spot

    WWV data

	Date        Hour   SFI   A   K Forecast                               Logger
	19-May-2010   21    69   6   1 No Storms -> No Storms                <VE7CC>

	Date        Hour   SFI   A   K Exp.K   R SA    GMF   Aurora   Logger
	19-May-2010   21    69  12   3     0   0 qui   qui       no <DK0WCY>

