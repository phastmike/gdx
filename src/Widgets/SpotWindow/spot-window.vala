/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * spot-window.vala
 *
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/spot-window.ui")]
public class SpotWindow : Gtk.Window {
    [GtkChild]
    private Gtk.HeaderBar headerbar1;
    [GtkChild]
    private Gtk.Button button_share;
    [GtkChild]
    private Gtk.Button button_cancel;
    [GtkChild]
    private Gtk.SpinButton input_freq;
    [GtkChild]
    private Gtk.Entry input_dx;
    [GtkChild]
    private Gtk.Entry input_comment;

    public signal void cancelled ();
    public signal void spot (string freq, string dx_station, string comment);

    public SpotWindow () {
        Object (default_width: 400, default_height: 200);
        set_titlebar (headerbar1);
        setup_callbacks ();
    }

    private void setup_callbacks () {
        button_cancel.clicked.connect (() => {
            cancelled ();
            this.destroy ();
        });

        button_share.clicked.connect (() => {
            spot (input_freq.get_value ().to_string (), input_dx.get_text (), input_comment.get_text ()); 
            this.destroy ();
        });
        
        input_freq.value_changed.connect (() => {
            button_share.set_sensitive (entries_have_data ());
        });

        input_dx.key_release_event.connect ((event) => {
            button_share.set_sensitive (entries_have_data ());
            return false;
        });
    }

    private bool entries_have_data () {
        return (input_freq.@value > 0.0 && input_dx.text_length > 1);
    }
}
