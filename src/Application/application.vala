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

    protected override void startup () {
        base.startup ();
        setup_app_menu ();
    }

    protected override void activate () {
        base.activate ();

        /*
        parser = new ParserConsole ();
        connector = new Connector ();
        */
        settings = Settings.instance ();

        // Handle error if fail to setup main window!
        setup_main_window ();

        /*
        if (settings.auto_connect_startup) {
            connector.connect_async (settings.default_cluster_address, (int16) settings.default_cluster_port);
        }

        connector.connection_established.connect (() => {
            connector.send (settings.user_callsign);
            window.button_share.sensitive = true;
        });

        connector.disconnected.connect (() => {
            window.button_share.sensitive = false;
            var disconnect_action = (SimpleAction) lookup_action ("disconnect");
            disconnect_action.set_enabled (false);
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
        */
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

        /*
        var connect_action = new GLib.SimpleAction ("connect", null);
        connect_action.activate.connect (() => {
            settings = Settings.instance ();
            connector.connect_async (settings.default_cluster_address, (int16) settings.default_cluster_port);
        });
        add_action (connect_action);

        var connect_to_action = new GLib.SimpleAction ("connect_to", null);
        connect_to_action.activate.connect (() => {
        });
        //add_action (connect_to_action);

        var disconnect_action = new GLib.SimpleAction ("disconnect", null);
        disconnect_action.activate.connect (() => {
            connector.disconnect_async ();
        });
        add_action (disconnect_action);

        var builder = new Gtk.Builder.from_resource ("/org/ampr/ct1enq/gdx/ui/app-menu.ui");
        var app_menu = builder.get_object ("app-menu") as GLib.MenuModel;
        */
        set_app_menu (app_menu);
    }

    private void setup_main_window () {
        window = new MainWindow (this);
        add_window (window);

        window.entry_commands.activate.connect (() => {
            connector.send (window.entry_commands.get_text ());
            window.entry_commands.set_text ("");
        });

        window.share_clicked.connect (() => {
            var share_window = new ShareWindow ();
            share_window.set_transient_for (window);
            share_window.show_all ();

            share_window.share_action.connect ((action) => {
                switch (action.get_action_type ()) {
                    case ShareAction.Type.SPOT:
                        var spot = action as ShareActionSpot;
                        print ("dx %s %s %s\n", spot.frequency, spot.dx_station, spot.comment);
                        connector.send (spot.to_string ());
                        break;
                    case ShareAction.Type.ANNOUNCEMENT:
                        var ann = action as ShareActionAnnouncement;
                        print ("Announcement %s msg: %s\n", ann.range.to_string (), ann.message);
                        connector.send (ann.to_string ());
                        break;
                    default:
                        print ("Unknown ShareAction\n");
                        break;
                }
            });
        });

    }

    private void show_settings () {
        var settings_window = new SettingsWindow ();
        settings_window.set_transient_for (window);
        settings_window.show_all ();
    }

    private void show_about_dialog () {
        string[] authors = {
            "Miguel, CT1ENQ"
        };

        string[] artists = {
            "Miguel, CT1ENQ",
            "App Icon by Smashicons from flaticon.com"
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
            "Website", "https://github.com/phastmike/gdx",
            "wrap-license", true);
    }
}
