/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * application.vala
 *
 */

using Gtk;

public class Application : Gtk.Application {
    public const string version = "0.1";

    public Application () {
        Object (application_id: "org.ampr.ct1enq.gdx", flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void shutdown () {
        base.shutdown ();
    }

    protected override void startup () {
        base.startup ();

        setup_app_actions ();
        setup_app_menu ();
    }

    protected override void activate () {
        base.activate ();

        setup_main_window ();
    }

    private void setup_main_window () {
        add_window (new MainWindow (this));
    }

    private void setup_app_actions () {
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
    }

    private void setup_app_menu () {
        var builder = new Gtk.Builder.from_resource ("/org/ampr/ct1enq/gdx/ui/app-menu.ui");
        var app_menu = builder.get_object ("app-menu") as GLib.MenuModel;

        set_app_menu (app_menu);
    }

    private void show_settings () {
        var settings_window = new SettingsWindow ();
        settings_window.set_transient_for (get_active_window ());
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

        Gtk.show_about_dialog (get_active_window (),
            "artists", artists,
            "authors", authors,
            "translator-credits", _("translator-credits"),
            "program-name", "Gdx",
            "title", _("About Gdx"),
            "license-type", Gtk.License.MIT_X11,
            "logo-icon-name", "org.ampr.ct1enq.gdx",
            "version", Application.version,
            "comments", _("Access the Radio Amateur DX Cluster Network\nNorthern Portugal DX Group"),
            "website", "https://github.com/phastmike/gdx",
            "website-label", "https://github.com/phastmike/gdx",
            "wrap-license", true);
    }
}
