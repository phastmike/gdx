/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * main-window.vala
 *
 * Jose Miguel Fonte, 2017
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/main-window.ui")]
public class MainWindow : Gtk.ApplicationWindow {
    [GtkChild]
    private Gtk.TreeView treeview_spots;
    [GtkChild]
    private Gtk.TextView textview_console;
    [GtkChild]
    public Gtk.Entry entry_commands;
    [GtkChild]
    private Gtk.TextBuffer textbuffer_console;

    private enum Col{
        SPOTTER,
        FREQ,
        DX,
        COMMENT,
        UTC
    }

    public MainWindow () {
        Object (default_width: 720, default_height: 480);
        set_titlebar (new MainHeaderBar ());
        show_all ();

        Gtk.TextIter iter;
        textbuffer_console.get_end_iter (out iter);
        textbuffer_console.create_mark ("scroll", iter, false); 
    }

    public void add_spot_to_view (string spotter, string freq, string dx, string comment, string utc) {
        Gtk.TreeIter iter;
        Gtk.ListStore store;

        store = (Gtk.ListStore) treeview_spots.get_model ();
        store.prepend (out iter);
        store.@set (iter, Col.SPOTTER, spotter, Col.FREQ, freq, Col.DX, dx, Col.COMMENT, comment, Col.UTC, utc);
        treeview_spots.scroll_to_cell (new Gtk.TreePath.from_string ("0"), null, true, 0, 0);
    }

    public void add_text_to_console (string text) {
        Gtk.TextIter iter;
        /*
        textbuffer_console.get_end_iter (out iter);
        textbuffer_console.insert (ref iter, "\n" + text, -1);
        iter.set_line_index (0);
        var mark = textbuffer_console.get_mark ("scroll");
        textbuffer_console.move_mark (mark, iter);
        textview_console.scroll_mark_onscreen (mark);
        */
        textbuffer_console.get_end_iter (out iter);
        textbuffer_console.insert (ref iter, "\n", 1);
        textbuffer_console.insert (ref iter, text, text.length);
        //textbuffer_console.get_end_iter (out iter);
        //var mark = textbuffer_console.get_mark ("insert");
        //textview_console.scroll_to_mark (mark, 0, true, 0.0, 1.0);
        Timeout.add (300, () => {
            textbuffer_console.get_end_iter (out iter);
            iter.set_line_index (0);
            var mark = textbuffer_console.get_mark ("scroll");
            textbuffer_console.move_mark (mark, iter);
            textview_console.scroll_mark_onscreen (mark);
            return false;
        });
    }
}
