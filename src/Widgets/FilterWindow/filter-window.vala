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
    [GtkChild]
    private Gtk.Grid grid1;

    BandFilters band_filters;

    public FilterWindow () {
        Object (default_width: 350, default_height: 150);
        set_titlebar (headerbar);

        setup_filters ();
        setup_filters_ui ();
        setup_callbacks ();
    }

    private void setup_callbacks () {
        close_button.clicked.connect (() => {
            destroy ();
        });
        apply_button.clicked.connect (() => {
            destroy ();
        });
    }

    private void setup_filters () {
        band_filters = new FilterBuilder ();
        band_filters.bind_property ("enabled", status_switch, "active", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
    }

    private void setup_filters_ui () {
        int x = 0;
        int y = 5;

        foreach (BandFilter filter in band_filters) {
            grid1.attach (new Gtk.CheckButton.with_label (filter.band.name),x,y,1,1);
            x = x + 1;
            if (x > 3) {
                x = 0;
                y = y + 1;
            }
        }
    }
}
