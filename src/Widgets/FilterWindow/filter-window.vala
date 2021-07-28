/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * filter-window.vala
 *
 * Jose Miguel Fonte
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

    private RadioBandFilters band_filters;
    private RadioBandFilters band_filters_origin;

    public FilterWindow (RadioBandFilters band_filters) requires (band_filters != null) {
        Object (default_width: 350, default_height: 150);
        set_titlebar (headerbar);

        // To allow Cancel/Apply we need to keep a copy of the data
        // and deal with user option.
        // Replicate all data, verbose

        band_filters_origin = band_filters;
        this.band_filters = new RadioBandFilters ();
        this.band_filters.enabled = band_filters.enabled;
        foreach (var filter in band_filters_origin) {
            this.band_filters.add (
                new RadioBandFilter (
                    new RadioBand (filter.band.name,
                         new RadioFrequency (filter.band.begin.get_frequency ()),
                         new RadioFrequency (filter.band.end.get_frequency ())
                    ),
                filter.enabled,
                RadioBandFilter.Type.ACCEPT)
            );
        }

        setup_filters ();
        setup_filters_ui ();
        setup_callbacks ();
    }

    private void setup_callbacks () {
        close_button.clicked.connect (() => {
            destroy ();
        });

        apply_button.clicked.connect (() => {
            band_filters_origin.enabled = band_filters.enabled;
            ((Application) transient_for.get_application ()).warehouse.save_config ();
            for (var i=0; i < band_filters_origin.size; i++) {
                band_filters_origin.@get (i).enabled = band_filters.@get (i).enabled;
                ((Application) transient_for.get_application ()).warehouse.save_radio_band_filter (band_filters_origin.@get (i));
            } 
            destroy ();
        });
    }

    private void setup_filters () {
        if (band_filters != null) {
            band_filters.bind_property ("enabled", status_switch, "active", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
        }
    }

    private void setup_filters_ui () {
        int x = 0;
        int y = 5;

        foreach (RadioBandFilter filter in band_filters) {
            var checkbutton = new Gtk.CheckButton.with_label (filter.band.name);
            filter.bind_property ("enabled", checkbutton, "active", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
            grid1.attach (checkbutton, x, y, 1, 1);
            x = x + 1;
            if (x > 3) {
                x = 0;
                y = y + 1;
            }
        }
    }
}
