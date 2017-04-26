/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * AtConnector.vala
 *
 * A-TOUCH Connection handler. 
 *
 * Version 0.1
 *
 * ATOUCHINTER
 * Copyright (C) 2015 José Miguel Fonte <miguel@atouch.com.pt>
 * 
 */

namespace DxCluster {
   public class Connector : Object {
        private Socket socket;
        private uint source_id;
        private uint timeout_id;
        private SocketClient client;
        private SocketSource source;
        private SocketConnection? connection = null;
        private DataInputStream? stream_input;
        private DataOutputStream? stream_output;
        private string? last_host_address=null;
        private uint16 last_host_port=0;
        public bool auto_reconnect  {set;get;default=true;}
        public Cancellable? cancellable;
         
        public signal void disconnected ();
        public signal void connection_lost ();
        public signal void connection_failed ();
        public signal void connection_established ();
        public signal void received_message (string text);

        public Connector () {
            client = new SocketClient ();
            cancellable = new Cancellable ();

            client.event.connect ((e, c, ios) => {
                print ("[%s]:[EVENT] %s\n", new DateTime.now_local ().format ("%F %T").to_string (), e.to_string ());
            });

            connection_failed.connect (()=> {
                print ("[%s]:[EVENT] %s\n", new DateTime.now_local ().format ("%F %T").to_string (), "SIGNAL::connection_failed");
                if (auto_reconnect) {
                    reconnect ();
                }
            });

            connection_lost.connect (()=> {
                print ("[%s]:[EVENT] %s\n", new DateTime.now_local ().format ("%F %T").to_string (), "SIGNAL::connection_lost");
                if (auto_reconnect) {
                    reconnect ();
                }
            });

            connection_established.connect (() => {
                print ("CONNECTED\n");
            });
        }
        
        public async void connect_async (string host, uint16 port, Cancellable? cancellable = null) {
            if (connection != null) {
                disconnect_async ();
            }

            last_host_address = host.dup (); 
            last_host_port = port;
            
            try {
                connection = yield client.connect_to_host_async (host, port, this.cancellable);
                socket = connection.get_socket ();
                socket.set_timeout (0); 
                socket.set_keepalive (true);
                stream_input = new DataInputStream (connection.get_input_stream ());
                stream_output = new DataOutputStream (connection.get_output_stream ()); 
                stream_input.set_buffer_size (8192);
                stream_input.set_newline_type (DataStreamNewlineType.ANY);
                
                //source = (SocketSource) (socket as Socket).create_source (IOCondition.IN, this.cancellable);
                //source.set_callback (receive_callback);
                //source.attach (MainContext.default ());

                connection_established ();
                send ("ct1enq\r\n");
                receive_async.begin ();
                
            } catch (Error e) {
                stderr.printf ("Error :: connect_async\n");
            }
        }

        public void disconnect_async () requires (connection != null) {
            print ("[%s]:[EVENT] %s\n", new DateTime.now_local ().format ("%F %T").to_string (), "Disconnect async\n");
            source.destroy ();
            Source.remove (timeout_id);
            try {
                connection.close ();
            } catch (IOError e) {
                print ("iostream close error::%s\n",e.message);
            }

            try {
                socket.close ();
            } catch (Error e) {
                print ("iostream close error::%s\n",e.message);
            }
            connection = null;
            disconnected ();
        }

        public void reconnect () {
            connect_async (last_host_address, last_host_port, cancellable);
        }
        
        private async void receive_async () {
            while (cancellable.is_cancelled () == false) {
            string? message = null;
            try {
                do {
                    message = yield stream_input.read_line_async (Priority.DEFAULT, cancellable, null);
                    message_handler (message);
                } while (message != null);
                //connection_lost ();
            } catch (IOError e) {
                stderr.printf ("%s\n", e.message);
                //connection_lost ();
            }
            }
        }

        public void send (string msg) requires (connection != null) {
            string message = msg;

            print ("[%s]>[TX] %s", new DateTime.now_local ().format ("%F %T").to_string (), message);

            try {
                stream_output.put_string (message, null);
            } catch (IOError e) {
                connection_lost ();
            }
        }

        public void message_handler (string msg) {
            string message = msg.dup ();
            
            received_message (message.escape ().replace ("\\007", "").compress () + "\r\n");
            //print ("[%s]<[RX] %s\n", new DateTime.now_local ().format ("%F %T").to_string (), message);
        }
    }
}
