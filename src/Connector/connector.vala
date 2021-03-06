/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * Connector.vala
 *
 * Connection handler. 
 *
 * Jose Miguel Fonte
 */

public class Connector : SocketClient {
    private Socket socket;
    private Cancellable? cancellable;
    private DataInputStream? stream_input;
    private DataOutputStream? stream_output;
    private SocketConnection? connection = null;
    private uint16 last_host_port = 0;
    public string? last_host_address = null;
    public bool auto_reconnect  {set; get; default = false;}
     
    public signal void disconnected ();
    public signal void connection_lost ();
    public signal void connection_failed (string err_msg);
    public signal void connection_established ();
    public signal void received_message (string text);

    public Connector () {
        cancellable = new Cancellable ();

        this.event.connect ((e, c, ios) => {
            string dmsg;

            dmsg = "[%s]: ".printf (new DateTime.now_local ().format ("%F %T").to_string ());
            dmsg += e.to_string ();
            
            debug (dmsg);
        });

        connection_failed.connect ((err_msg)=> {
            GLib.message ("(signal) connection_failed...");
            if (auto_reconnect) {
                reconnect_async.begin ();
            }
        });

        connection_lost.connect (()=> {
            GLib.message ("(signal) connection_lost...");
            disconnect_async ();
            if (auto_reconnect) {
                reconnect_async.begin ();
            }
        });

        connection_established.connect (() => {
            GLib.message ("(signal) connection_established with %s:%d", last_host_address, last_host_port);
        });

        disconnected.connect (() => {
            GLib.message ("(signal) disconnected...");
        });

    }
    
    public new async void connect_async (string host, uint16 port) {
        /*
        if (connection != null) {
            disconnect_async ();
        }
        */

        disconnect_async ();

        last_host_address = host.dup (); 
        last_host_port = port;

        cancellable.reset ();
        
        try {
            connection = yield this.connect_to_host_async (host, port, this.cancellable);
            socket = connection.get_socket ();
            socket.set_timeout (0); 
            socket.set_keepalive (true);
            stream_input = new DataInputStream (connection.get_input_stream ());
            stream_output = new DataOutputStream (connection.get_output_stream ()); 
            stream_input.set_newline_type (DataStreamNewlineType.CR_LF);

            connection_established ();

            receive_upto_login.begin ((obj,res) => {
                if (receive_upto_login.end (res)) {
                    receive_async.begin ();
                }
            });
        } catch (Error e) {
            connection_failed (e.message);
        }
    }

    public void disconnect_async () {
        if (connection == null) {
            return;
        }

        cancellable.cancel ();

        try {
            connection.close ();
        } catch (IOError e) {
            GLib.warning ("connection.close () error: %s", e.message);
        }

        try {
            socket.close ();
        } catch (Error e) {
            GLib.warning ("socket.close () error: %s", e.message);
        }

        connection = null;
        disconnected ();
    }

    public async void reconnect_async () {
        yield connect_async (last_host_address, last_host_port);
    }

    private async bool receive_upto_login () {
        bool found_login = false;
        string? message= null;
        while (cancellable.is_cancelled () == false && connection != null && !found_login) {
            try {
                message = yield stream_input.read_upto_async (":", 1, Priority.DEFAULT, cancellable, null);
                if (message != null) {
                    stream_input.read_byte ();
                    message += ":";
                    if (message.length >= 5) {
                        var test_login = message[-6:message.length];
                        if (test_login == "login:") {
                            found_login = true;
                            stream_input.read_byte ();
                            message += " ";
                        }
                    }
                    message_handler (message);
                } else {
                    connection_lost ();
                }

                if (connection == null) {
                    cancellable.cancel ();
                }
            } catch (IOError e) {
                GLib.message ("receive_up_to_login: %s", e.message);
                if (connection != null) {
                    connection_lost ();
                }
            }
        }

        return found_login;
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
                GLib.message ("receive_async: %s", e.message);
                if (connection != null) {
                    connection_lost ();
                }
            }
        }
    }

    public void send (string message) requires (connection != null) {
        try {
            if (!stream_output.put_string (message + "\r\n", null)) {
                connection_lost ();
            } 
        } catch (IOError e) {
            GLib.message ("error: %s", e.message);
            connection_lost ();
        }
    }

    public void message_handler (string message) {
        received_message (((message.escape (null)).replace ("\\007", "")).compress ());
    }
}
