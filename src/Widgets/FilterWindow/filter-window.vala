/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * filter-window.vala
 *
 * Jose Miguel Fonte, 2017
 */

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

    public FilterWindow () {
        Object (default_width: 350, default_height: 150);
        set_titlebar (headerbar);

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
}
