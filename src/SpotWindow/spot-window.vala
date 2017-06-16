/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * main-window.vala
 *
 * Jose Miguel Fonte, 2017
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/spot-window.ui")]
public class SpotWindow : Gtk.Window {
    [GtkChild]
    private Gtk.HeaderBar headerbar1;
    [GtkChild]
    private Gtk.Button button_spot;
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
        //Object (default_width: 440, default_height: 340);
        set_titlebar (headerbar1);
        setup_callbacks ();
    }

    private void setup_callbacks () {
        button_cancel.clicked.connect (() => {
            cancelled ();
            this.destroy ();
        });

        button_spot.clicked.connect (() => {
            spot (input_freq.get_value ().to_string (), input_dx.get_text (), input_comment.get_text ()); 
            this.destroy ();
        });
        
        input_freq.value_changed.connect (() => {
            button_spot.set_sensitive (entries_have_data ());
        });

        input_dx.key_release_event.connect ((event) => {
            button_spot.set_sensitive (entries_have_data ());
            return false;
        });
    }

    private bool entries_have_data () {
        // Simple data validator, can and should be improved
        return (input_freq.@value > 0.0 && input_dx.text_length > 1);
    }
}
