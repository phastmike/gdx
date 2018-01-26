/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * filter-window.vala
 *
 * Jose Miguel Fonte, 2017
 */
using Gee;

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/filter-window.ui")]
public class FilterWindow : Gtk.Window {
    [GtkChild]
    private Gtk.HeaderBar headerbar;
    [GtkChild]
    private Gtk.Switch status_switch;
    [GtkChild]
    private Gtk.Button close_button;
    [GtkChild]
    private Gtk.Button apply_button;
    ArrayList<RadioBand> bands;

    public FilterWindow () {
        Object (default_width: 350, default_height: 150);
        set_titlebar (headerbar);

        setup_callbacks ();
        setup_bands ();
    }

    private void setup_callbacks () {
        close_button.clicked.connect (() => {
            destroy ();
        });
        apply_button.clicked.connect (() => {
            destroy ();
        });
    }

    private void setup_bands () {
        bands = new ArrayList<RadioBand> ();

        // Should do a band Filter with status flag
        bands.add (new RadioBand ("10m", new RadioFrequency (28000.0), new RadioFrequency (29700.0)));

    }
}
