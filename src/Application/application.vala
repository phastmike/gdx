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

        // CONFIG DIR
        //print("Config_dir: %s\n", Environment.get_user_config_dir () + Path.DIR_SEPARATOR_S + "gdx");
        // check existence otherwise create it

        var connector = new DxCluster.Connector ();
        connector.connect_async (Gdx.Settings.default_cluster_address, (int16) Gdx.Settings.default_cluster_port);
        connector.connection_established.connect (() => {
            connector.send ("ct1enq\r\n");
            print ("Connected!\n");
        });

        window = new MainWindow (this);
        //window.set_application (this);
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

    protected override void startup () {
        base.startup ();
        //Gdk.set_show_events (true);
        setup_app_menu ();
    }

    private void setup_app_menu () {
        // Using action named Settings the option becomes not sensitive !?
        // Although it appears as Settings on the menu, internally is preferences.

        new Gdx.Settings ();
        var action = new GLib.SimpleAction ("preferences", null);
        action.activate.connect (() => {
            print ("APP SETTINGS\n");
            show_preferences ();
        });
        add_action (action);

        action = new GLib.SimpleAction ("about", null);
        action.activate.connect (() => {
            show_about_dialog (); 
        });
        add_action (action);

        action = new GLib.SimpleAction ("quit", null);
        action.activate.connect (() => {
            print ("APP QUIT\n");
            base.quit ();
        });
        add_action (action);

        var builder = new Gtk.Builder.from_resource ("/org/ampr/ct1enq/gdx/ui/app-menu.ui");
        var app_menu = builder.get_object ("app-menu") as GLib.MenuModel;
        
        set_app_menu (app_menu);
    }

    private void show_preferences () {
        var settings_window = new SettingsWindow ();
        settings_window.set_transient_for (window);
        settings_window.show_all ();
    }

    private void show_about_dialog () {
        string[] authors = {
            "José Fonte <phastmike@gmail.com>"
        };
        string[] artists = {
            "José Fonte <phastmike@gmail.com>"
        };
        Gtk.show_about_dialog (window,
            "artists", artists,
            "authors", authors,
            //"translator-credits", _("translator-credits"),
            "translator-credits", "translator-credits",
            "program-name", "GDx",
            //"title", _("About GDx"),
            "title", "About GDx",
            "license-type", Gtk.License.GPL_3_0,
            "logo-icon-name", "de.haeckerfelix.gradio",
            //"version", VERSION,
            "version", "0.1",
            "comments", "Database: www.radio-browser.info",
            "website", "https://github.com/phastmike/gdx",
            "wrap-license", true);
    }
}
