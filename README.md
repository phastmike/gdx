[![build](https://travis-ci.org/phastmike/gdx.svg?branch=master)](https://travis-ci.org/phastmike/gdx)

# gdx

A DX Cluster client for Radio amateurs. It allows hamradio operators to connect to the Packet Radio DX Clusters network via telnet. Connection via radio frequency modem, or TNC, not available at the moment.

## What is the DX Cluster network

The DX Cluster network it's a legacy service, still in active use today, that used the packet radio network to broadcast DX information. Developed, initially, to use RF network links (AX25), it has migrated, mostly, to the Internet.

## DX Cluster node software
There are a few software packages that implement this kind of service and due to the legacy they all provide a ASCII based interface to the user leaving the [AK1A PC protocol](http://www.dxcluster.org/tech/pcprot.html) to the cluster nodes. Well, this is not exactly true because some developers added additional commands to force the reception of dx spots with the [PC protocol](http://www.dxcluster.org/tech/pcprot.html) semantic. Of course this depends on the cluster node software to support it. Nevertheless, support for different methods is necessary (standard and enhanced).

[More information](https://en.wikipedia.org/wiki/DX_cluster) available on Wikipedia

## Limitations

For many years, the service was provided solely by AK1A Packet Cluster software. This was a paid software and in the late 90's some alternatives started to emerge. Nowadays most nodes use [DXSpider](http://www.dxcluster.org/main/) or AR-Cluster.

These software applications provide a console based user interface (session) and they tried to implement the same, or almost similar, experience but each application has it's own minor variations. This means that some commands, or lack of, are specific to the service software being used.

Nodes use a protocol, known as [PC protocol](http://www.dxcluster.org/tech/pcprot.html), to communicate. Most of this protocol has been reverse engineered due to AK1A being a commercial product and lack of documentation.

# Building and running

Start by cloning this repository:

	$ git clone https://github.com/phastmike/gdx

To build it, `cd` into the repository and run:

	$ meson build && cd build && ninja

Then run the application it with:

	$ ./src/gdx

If you wish to install gdx then run

	$ sudo ninja install

## Screenshot

![Screenshot](/data/screenshots/screenshot2.png "Screenshot")

## Dependencies

* meson (>= 0.40.0)
* ninja (>= 1.6.0)
* valac (>= 0.38.3)
* Gtk+ (>= 3.18)
* libgee

Probably will work with some previous versions but has not been tested.

## Debug

To enable debug messages, set:

    export G_MESSAGES_DEBUG=all

## First use

* User must set its callsign (default NOCALL) before connecting to any node
