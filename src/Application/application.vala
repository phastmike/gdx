/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * application.vala
 *
 * Jose Miguel Fonte, 2017
 */

using Gtk;

public class Application : Gtk.Application {
    private static Parser parser;
    public static MainWindow window;
    
    public Application () {
        Object (application_id: "org.ampr.ct1enq.gdx", flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void shutdown () {
        base.shutdown ();
    }

    protected override void activate () {
        base.activate ();

        parser = new Parser ();
        var connector = new DxCluster.Connector ();
        var settings = Settings.instance ();

        window = new MainWindow (this);
        add_window (window);
    
        connector.connect_async (settings.default_cluster_address, (int16) settings.default_cluster_port);
        connector.connection_established.connect (() => {
            connector.send (settings.user_callsign + "\r\n");
            window.button1.sensitive = true;
        });

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
            "Icons by icons8.com"
            
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
            "comments", "Database: www.radio-browser.info",
            "website", "https://github.com/phastmike/gdx",
            "wrap-license", true);
    }
}
