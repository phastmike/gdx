/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * settings-window.vala
 *
 * Jose Miguel Fonte, 2017
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/settings-window.ui")]
public class SettingsWindow: Gtk.Window {
    [GtkChild]
    private Gtk.Entry entry_callsign;
    [GtkChild]
    private Gtk.Entry entry_cluster_name;
    [GtkChild]
    private Gtk.Entry entry_cluster_address;
    [GtkChild]
    private Gtk.SpinButton spinbutton_cluster_port;
    [GtkChild]
    private Gtk.Entry entry_cluster_login;
    [GtkChild]
    private Gtk.CheckButton checkbutton_autoconnect;
    [GtkChild]
    private Gtk.CheckButton checkbutton_autoreconnect;

    
    public SettingsWindow () {
        setup ();
    }

    private void setup () {
        entry_callsign.set_text (Gdx.Settings.user_callsign);
        entry_cluster_name.set_text (Gdx.Settings.default_cluster_name);
        entry_cluster_address.set_text (Gdx.Settings.default_cluster_address);
        spinbutton_cluster_port.set_value ((double) Gdx.Settings.default_cluster_port);
        entry_cluster_login.set_text (Gdx.Settings.default_cluster_login_script);
    }
}
