/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * Connector.vala
 *
 * Connection handler. 
 *
 * Jose Miguel Fonte
 */

public class Connector : Object {
    private Socket socket;
    private SocketClient client;
    private SocketConnection? connection = null;
    private DataInputStream? stream_input;
    private DataOutputStream? stream_output;
    public string? last_host_address = null;
    private uint16 last_host_port = 0;
    private Cancellable? cancellable;
    public bool auto_reconnect  {set; get; default = false;}
     
    public signal void disconnected ();
    public signal void connection_lost ();
    public signal void connection_failed ();
    public signal void connection_established ();
    public signal void received_message (string text);

    public Connector () {
        client = new SocketClient ();
        cancellable = new Cancellable ();

        client.event.connect ((e, c, ios) => {
            string dmsg;

            dmsg = "[%s]: ".printf (new DateTime.now_local ().format ("%F %T").to_string ());
            dmsg += e.to_string ();
            
            debug (dmsg);
        });

        connection_failed.connect (()=> {
            debug ("signal::connection_failed");
            if (auto_reconnect) {
                Idle.add(reconnect);
            }
        });

        connection_lost.connect (()=> {
            debug ("signal::connection_lost");
            disconnect_async ();
            if (auto_reconnect) {
                reconnect ();
            }
        });

        connection_established.connect (() => {
            debug ("signal::connection_established");
        });
    }
    
    public async void connect_async (string host, uint16 port) {
        if (connection != null) {
            disconnect_async ();
        }

        last_host_address = host.dup (); 
        last_host_port = port;

        cancellable.reset ();
        
        try {
            connection = yield client.connect_to_host_async (host, port, this.cancellable);
            socket = connection.get_socket ();
            socket.set_timeout (0); 
            socket.set_keepalive (true);
            stream_input = new DataInputStream (connection.get_input_stream ());
            stream_output = new DataOutputStream (connection.get_output_stream ()); 
            stream_input.set_newline_type (DataStreamNewlineType.CR_LF);

            connection_established ();
            receive_async.begin ();

        } catch (Error e) {
            connection_failed ();
        }
    }

    public void disconnect_async () requires (connection != null) {
        debug ("signal::disconnect_async");
        cancellable.cancel ();
        try {
            connection.close ();
        } catch (IOError e) {
            debug ("iostream close error::%s\n",e.message);
        }

        try {
            socket.close ();
        } catch (Error e) {
            debug ("iostream close error::%s\n",e.message);
        }
        connection = null;
        disconnected ();
    }

    public bool reconnect () {
        connect_async (last_host_address, last_host_port);
        return false;
    }

    private async void receive_async () {
        string? message = null;

        while (cancellable.is_cancelled () == false && connection != null) {
            try {
                message = yield stream_input.read_line_async (Priority.DEFAULT, cancellable, null);
                if (message != null) {
                    message_handler (message);
                } else {
                    connection_lost ();
                }

                if (connection == null) {
                    cancellable.cancel ();
                }
            } catch (IOError e) {
                stderr.printf ("%s\n", e.message);
            }
        }
    }

    public void send (string message) requires (connection != null) {
        try {
            if (!stream_output.put_string (message + "\r\n", null)) {
                connection_lost ();
            } 
        } catch (IOError e) {
            connection_lost ();
        }
    }

    public void message_handler (string message) {
        received_message (((message.escape (null)).replace ("\\007", "")).compress ());
    }
}
