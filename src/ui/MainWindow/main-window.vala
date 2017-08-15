/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * main-window.vala
 *
 * Jose Miguel Fonte, 2017
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/main-window2.ui")]
public class MainWindow : Gtk.ApplicationWindow {
    [GtkChild]
    public Gtk.Button button1;
    [GtkChild]
    public Gtk.Entry entry_commands;
    [GtkChild]
    private Gtk.HeaderBar headerbar1;
    [GtkChild]
    private Gtk.TreeView treeview_spots;
    [GtkChild]
    private Gtk.TextView textview_console;
    [GtkChild]
    private Gtk.TextBuffer textbuffer_console;
    [GtkChild]
    private Gtk.SearchBar searchbar;
    [GtkChild]
    private Gtk.Button searchbutton;
    [GtkChild]
    private Gtk.SearchEntry searchentry;

    private enum Col{
        SPOTTER,
        FREQ,
        DX,
        COMMENT,
        UTC
    }

    public MainWindow () {
        Object (default_width: 720, default_height: 480);
        set_titlebar (headerbar1);
        show_all ();

        Gtk.TextIter iter;
        textbuffer_console.get_end_iter (out iter);
        textbuffer_console.create_mark ("scroll", iter, false); 

        treeview_spots.set_search_entry (searchentry);

        searchbutton.clicked.connect (() => {
            searchbar.search_mode_enabled = !searchbar.search_mode_enabled;
        });

        button1.clicked.connect (() => {
            var spot_window = new SpotWindow ();
            spot_window.set_transient_for (this);
            spot_window.show_all ();

            spot_window.spot.connect ((f, dx, c) => {
                print ("%s : %s : %s\n", f,dx,c);
            });
        });
    }

    public void add_spot_to_view (string spotter, string freq, string dx, string comment, string utc) {
        Gtk.TreeIter iter;
        Gtk.ListStore store;

        store = (Gtk.ListStore) treeview_spots.get_model ();
        store.append (out iter);
        store.@set (iter, Col.SPOTTER, spotter, Col.FREQ, freq, Col.DX, dx, Col.COMMENT, comment, Col.UTC, utc);
        treeview_spots.scroll_to_cell (new Gtk.TreePath.from_string (store.get_string_from_iter(iter)), null, true, 0, 0);
    }

    public void add_text_to_console (string text) {
        Gtk.TextIter iter;

        textbuffer_console.get_end_iter (out iter);
        textbuffer_console.insert (ref iter, "\n", 1);
        textbuffer_console.insert (ref iter, text, text.length);


        // Must add on Idle or Timeout otherwise won't move if a lot of text :/
        Idle.add (() => {
            textbuffer_console.get_end_iter (out iter);
            iter.set_line_index (0);
            var mark = textbuffer_console.get_mark ("scroll");
            textbuffer_console.move_mark (mark, iter);
            textview_console.scroll_mark_onscreen (mark);
            return false;
        });
    }
}
