/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * application.vala
 *
 */

using Gtk;

public class Application : Gtk.Application {
    public static MainWindow window;
    private static ParserConsole parser;
    private Settings settings;
    private Connector connector;
    
    public Application () {
        Object (application_id: "org.ampr.ct1enq.gdx", flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void shutdown () {
        base.shutdown ();
    }

    protected override void activate () {
        base.activate ();

        parser = new ParserConsole ();
        connector = new Connector ();
        settings = Settings.instance ();

        window = new MainWindow (this);
        add_window (window);

        window.button_share.sensitive = true;
    
        if (settings.auto_connect_startup) {
            connector.connect_async (settings.default_cluster_address, (int16) settings.default_cluster_port);
        }

        connector.connection_established.connect (() => {
            connector.send (settings.user_callsign + "\r\n");
            window.button_share.sensitive = true;
        });

        window.entry_commands.activate.connect (() => {
            connector.send (window.entry_commands.get_text () + "\r\n");
            window.entry_commands.set_text ("");
        });

        connector.received_message.connect ((text) => {
            //window.add_text_to_console (text);
            if (ParserConsole.text_get_type (text) == ParserConsole.MsgType.DX_REAL_SPOT) {
                parser.parse_spot (text);
                if (!settings.filter_spots_from_console) {
                    window.add_text_to_console (text);
                }
            } else {
                window.add_text_to_console (text);
            }
        });

        parser.rcvd_spot.connect ((s) => {
            window.add_spot_to_view (s.spotter, s.freq, s.dx, s.comment, s.utc);
        });
    }

    protected override void startup () {
        base.startup ();
        //Debug events
        //Gdk.set_show_events (true);

        setup_app_menu ();
    }

    private void setup_app_menu () {
        var action = new GLib.SimpleAction ("settings", null);
        action.activate.connect (() => {
            show_settings ();
        });
        add_action (action);

        action = new GLib.SimpleAction ("about", null);
        action.activate.connect (() => {
            show_about_dialog (); 
        });
        add_action (action);

        action = new GLib.SimpleAction ("quit", null);
        action.activate.connect (() => {
            base.quit ();
        });
        add_action (action);

        // For main menu

        var connect_action = new GLib.SimpleAction ("connect", null);
        connect_action.activate.connect (() => {
            settings = Settings.instance ();
            print ("CONNECT\n");
            connector.connect_async (settings.default_cluster_address, (int16) settings.default_cluster_port);
        });
        add_action (connect_action);

        var connect_to_action = new GLib.SimpleAction ("connect_to", null);
        connect_to_action.activate.connect (() => {
            print ("CONNECT\n");
        });
        //add_action (connect_to_action);

        var disconnect_action = new GLib.SimpleAction ("disconnect", null);
        disconnect_action.activate.connect (() => {
            print ("disconnect\n");
            connector.disconnect_async ();
        });
        add_action (disconnect_action);

        var builder = new Gtk.Builder.from_resource ("/org/ampr/ct1enq/gdx/ui/app-menu.ui");
        var app_menu = builder.get_object ("app-menu") as GLib.MenuModel;
        
        set_app_menu (app_menu);
    }

    private void show_settings () {
        var settings_window = new SettingsWindow ();
        settings_window.set_transient_for (window);
        settings_window.show_all ();
    }

    private void show_about_dialog () {
        string[] authors = {
            "José Fonte <phastmike@gmail.com>"
        };

        string[] artists = {
            "José Fonte <phastmike@gmail.com>",
            "App Icon by flaticon.com <http://flaticon.com>"
        };

        Gtk.show_about_dialog (window,
            "artists", artists,
            "authors", authors,
            "translator-credits", _("translator-credits"),
            "program-name", "Gdx",
            "title", _("About Gdx"),
            "license-type", Gtk.License.MIT_X11,
            "logo-icon-name", "org.ampr.ct1enq.gdx",
            "version", "0.1",
            "comments", "Access the Radio Amateur DX Cluster Network",
            "website", "https://github.com/phastmike/gdx",
            "wrap-license", true);
    }
}
