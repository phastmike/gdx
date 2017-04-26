/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * application.vala
 *
 * Jose Miguel Fonte, 2017
 */

using Gtk;

public class Application : Gtk.Application {
    private Parser parser;

    public Application () {
        Object (application_id: "org.ampr.ct1enq.gdx", flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void shutdown () {
        base.shutdown ();
    }

    protected override void activate () {
        parser = new Parser ();

        var connector = new DxCluster.Connector ();
        connector.connect_async ("hamradio.isel.ipl.pt", 41112);
        connector.connection_established.connect (() => {
            print ("Connected!\n");
        });

        var window = new MainWindow ();
        add_window (window);

        window.entry_commands.activate.connect (() => {
            connector.send (window.entry_commands.get_text () + "\r\n");
            window.entry_commands.set_text ("");
        });

        connector.received_message.connect ((text) => {
            window.add_text_to_console (text);
            //print ("%s\n", Parser.text_get_type (text).to_string ());
            if (Parser.text_get_type (text) == Parser.MsgType.DX_REAL_SPOT) {
                parser.parse_spot (text);
            } 
        });

        parser.rcvd_spot.connect ((s) => {
            window.add_spot_to_view (s.spotter, s.freq, s.dx, s.comment, s.utc);
        });
    }
}
