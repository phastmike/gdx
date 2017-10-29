/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * main-window.vala
 *
 * Jose Miguel Fonte, 2017
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/main-window.ui")]
public class MainWindow : Gtk.ApplicationWindow {
    [GtkChild]
    public Gtk.Button button_share;
    [GtkChild]
    private Gtk.Stack stack_main;
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
    private Gtk.ScrolledWindow scrolled_spots;
    [GtkChild]
    private Gtk.ScrolledWindow scrolled_console;
    [GtkChild]
    private Gtk.SearchBar searchbar;
    [GtkChild]
    private Gtk.Button searchbutton;
    [GtkChild]
    private Gtk.SearchEntry searchentry;
    [GtkChild]
    private Gtk.ListStore liststore_spots;
    [GtkChild]
    private Gtk.TreeModelFilter liststore_spots_with_filter;
    private bool scrolled_spots_moved = false;
    private bool scrolled_console_moved = false;


    private enum Col{
        SPOTTER,
        FREQ,
        DX,
        COMMENT,
        UTC
    }

    // Main Window needs to have an application set before its shown
    // otherwise menu-app wont be set!
    // Thats why we need to set the application at construct!

    public MainWindow (Gtk.Application? app = null) {
        Object (application: app, default_width: 720, default_height: 480);
        set_titlebar (headerbar1);
        set_send_spot_button_visible (false);

        show_all ();

        Gtk.TextIter iter;
        textbuffer_console.get_end_iter (out iter);
        textbuffer_console.create_mark ("scroll", iter, false); 

        var vscrollbar = (Gtk.Scrollbar) scrolled_spots.get_vscrollbar ();

        vscrollbar.value_changed.connect ( () => {
            var val = vscrollbar.adjustment.@value;
            var upper = vscrollbar.adjustment.upper - vscrollbar.adjustment.page_size;
            if (val != upper) {
                scrolled_spots_moved = true;
            } else {
                scrolled_spots_moved = false;
            }
        });

        var vscrollbar2 = (Gtk.Scrollbar) scrolled_console.get_vscrollbar ();

        vscrollbar2.value_changed.connect ( () => {
            var val = vscrollbar2.adjustment.@value;
            var upper = vscrollbar2.adjustment.upper - vscrollbar2.adjustment.page_size;
            print ("upper: %f value: %f\n", upper, val);
            if (val != upper) {
                scrolled_console_moved = true;
            } else {
                scrolled_console_moved = false;
            }
        });

        treeview_spots.key_press_event.connect ((event) => {
            searchbar.set_search_mode (true);
            return searchentry.handle_event (event);
        }); 

        searchbutton.clicked.connect (() => {
            searchbar.search_mode_enabled = !searchbar.search_mode_enabled;
        });
        
        searchentry.search_changed.connect (() => {
            liststore_spots_with_filter.refilter ();
            stack_main.set_visible_child (scrolled_spots);
        });

        button_share.clicked.connect (() => {
            var share_window = new ShareWindow ();
            share_window.set_transient_for (this);
            share_window.show_all ();

            share_window.spot.connect ((f, dx, c) => {
                print ("dx %s %s %s\n", f,dx,c);
            });

            share_window.announcement.connect ((range, node, msg) => {
                print ("Announcement %s %s msg: %s\n", range.to_string (), node != null ? node : "", msg);
            });
        });

        liststore_spots_with_filter.set_visible_func ((model, iter) => {
            string dx;

            if (searchentry.get_text () == "" || searchentry.get_text == null) {
                return true;
            }

            model.get (iter, Col.DX, out dx);

            if (dx == null) return false;

            if (dx.up ().contains (searchentry.get_text ().up())) {
                return true;
            } else {
                return false;
            }
        });
    }

    public void add_spot_to_view (string spotter, string freq, string dx, string comment, string utc) {
        Gtk.TreeIter iter;
        Gtk.ListStore store;

        store = liststore_spots;
        store.append (out iter);
        store.@set (iter, Col.SPOTTER, spotter, Col.FREQ, freq, Col.DX, dx, Col.COMMENT, comment, Col.UTC, utc);
        // HOUSTON WE HAVE A PROBLEM!
        if (!searchbar.search_mode_enabled && !scrolled_spots_moved) {
            treeview_spots.scroll_to_cell (new Gtk.TreePath.from_string (store.get_string_from_iter(iter)), null, true, 0, 0);
        }
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
            //if (!scrolled_console_moved) {
                textview_console.scroll_mark_onscreen (mark);
            //}
            return false;
        });
    }

    public void set_send_spot_button_visible (bool sensitive) {
        button_share.sensitive = sensitive;
    }
}
