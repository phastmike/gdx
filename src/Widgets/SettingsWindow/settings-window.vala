/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * settings-window.vala
 *
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/settings-window.ui")]
public class SettingsWindow: Gtk.Window {
    [GtkChild]
    private unowned Gtk.Entry entry_callsign;
    [GtkChild]
    private unowned Gtk.Entry entry_cluster_name;
    [GtkChild]
    private unowned Gtk.Entry entry_cluster_address;
    [GtkChild]
    private unowned Gtk.SpinButton spinbutton_cluster_port;
    [GtkChild]
    private unowned Gtk.Entry entry_cluster_login;
    [GtkChild]
    private unowned Gtk.CheckButton checkbutton_autoconnect;
    [GtkChild]
    private unowned Gtk.CheckButton checkbutton_autoreconnect;
    [GtkChild]
    private unowned Gtk.CheckButton checkbutton_filterspots;

    
    public SettingsWindow () {
        setup ();
    }

    private void setup () {
        var settings = Settings.instance ();
        
        entry_callsign.set_text (settings.user_callsign);
        entry_cluster_name.set_text (settings.default_cluster_name);
        entry_cluster_address.set_text (settings.default_cluster_address);
        spinbutton_cluster_port.set_value ((double) settings.default_cluster_port);
        entry_cluster_login.set_text (settings.default_cluster_login_script);
        checkbutton_autoconnect.set_active (settings.auto_connect_startup);
        checkbutton_autoreconnect.set_active (settings.auto_reconnect);
        checkbutton_filterspots.set_active (settings.filter_spots_from_console);

        close_request.connect (() => {
            settings.user_callsign = entry_callsign.get_text ();
            settings.default_cluster_name = entry_cluster_name.get_text ();
            settings.default_cluster_address = entry_cluster_address.get_text ();
            settings.default_cluster_port = spinbutton_cluster_port.get_value_as_int ();
            settings.default_cluster_login_script = entry_cluster_login.get_text ();
            settings.auto_connect_startup = checkbutton_autoconnect.active;
            settings.auto_reconnect = checkbutton_autoreconnect.active; 
            settings.filter_spots_from_console = checkbutton_filterspots.active;
            return true;
        });
    }
}
