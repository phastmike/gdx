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

    ArrayList<BandFilter> band_filters;

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
        band_filters = new ArrayList<BandFilter> ();

        // Should do a band Filter with status flag
        band_filters.add (new BandFilter (new RadioBand ("160m", new RadioFrequency (1830.0), new RadioFrequency (1850.0))));
        band_filters.add (new BandFilter (new RadioBand ("80m", new RadioFrequency (3500.0), new RadioFrequency (3800.0))));
        band_filters.add (new BandFilter (new RadioBand ("60m", new RadioFrequency (5350.0), new RadioFrequency (5370.0))));
        band_filters.add (new BandFilter (new RadioBand ("40m", new RadioFrequency (7000.0), new RadioFrequency (7200.0))));
        band_filters.add (new BandFilter (new RadioBand ("30m", new RadioFrequency (10100.0), new RadioFrequency (10150.0))));
        band_filters.add (new BandFilter (new RadioBand ("20m", new RadioFrequency (14000.0), new RadioFrequency (14350.0))));
        band_filters.add (new BandFilter (new RadioBand ("17m", new RadioFrequency (18068.0), new RadioFrequency (18168.0))));
        band_filters.add (new BandFilter (new RadioBand ("15m", new RadioFrequency (21000.0), new RadioFrequency (21450.0))));
        band_filters.add (new BandFilter (new RadioBand ("12m", new RadioFrequency (24890.0), new RadioFrequency (24990.0))));
        band_filters.add (new BandFilter (new RadioBand ("10m", new RadioFrequency (28000.0), new RadioFrequency (29700.0))));
        band_filters.add (new BandFilter (new RadioBand ("6m", new RadioFrequency (50000.0), new RadioFrequency (54000.0))));
        band_filters.add (new BandFilter (new RadioBand ("4m", new RadioFrequency (70000.0), new RadioFrequency (70500.0))));
        band_filters.add (new BandFilter (new RadioBand ("2m", new RadioFrequency (144000.0), new RadioFrequency (146000.0))));
        band_filters.add (new BandFilter (new RadioBand ("70cm", new RadioFrequency (430000.0), new RadioFrequency (440000.0))));
        band_filters.add (new BandFilter (new RadioBand ("23cm", new RadioFrequency (1200000.0), new RadioFrequency (1300000.0))));
        band_filters.add (new BandFilter (new RadioBand ("12cm", new RadioFrequency (2400000.0), new RadioFrequency (2500000.0))));
    }

    private void setup_filters_ui () {
        int x;
        int y;
        x = 0;
        y = 5;

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
