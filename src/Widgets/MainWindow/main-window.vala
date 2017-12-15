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
    private Gtk.Grid grid1;
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
    [GtkChild]
    private Gtk.MenuButton menu_button;
    [GtkChild]
    private Gtk.Overlay main_overlay;
    [GtkChild]
    private Gtk.Entry nodecall;

    View view = View.SPOTS;

    private Connector connector;
    private ParserConsole parser;
    private AppNotification app_notification;

    private bool scrolled_spots_moved = false;
    private bool scrolled_console_moved = false;

    public signal void share_clicked ();

    private enum View {
        SPOTS,
        CONSOLE
    }

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

        set_textbuffer ();
        set_callbacks ();
        set_main_menu ();

        var settings = Settings.instance ();
        parser = new ParserConsole ();
        connector = new Connector ();

        app_notification = new AppNotification ();
        main_overlay.add_overlay (app_notification);

        if (settings.auto_connect_startup) {
            connector.connect_async (settings.default_cluster_address, (int16) settings.default_cluster_port);
        }

        connector.connection_established.connect (() => {
            connector.send (settings.user_callsign);
            button_share.sensitive = true;
            var action = (SimpleAction) lookup_action ("disconnect");
            action.set_enabled (true);
            action = (SimpleAction) lookup_action ("connect");
            action.set_enabled (false);
            app_notification.set_message ("You are now connected");
            app_notification.set_reveal_child (true);
        });

        connector.disconnected.connect (() => {
            button_share.sensitive = false;
            var action = (SimpleAction) lookup_action ("disconnect");
            action.set_enabled (false);
            action = (SimpleAction) lookup_action ("connect");
            action.set_enabled (true);
            app_notification.set_message ("You are now disconnected");
            app_notification.set_reveal_child (true);
        });

        connector.received_message.connect ((text) => {
            if (ParserConsole.text_get_type (text) == ParserConsole.MsgType.DX_REAL_SPOT) {
                parser.parse_spot (text);
                if (!settings.filter_spots_from_console) {
                    add_text_to_console (text);
                }
            } else if (ParserConsole.text_get_type (text) == ParserConsole.MsgType.PROMPT) {
                //entry_commands.set_text (text);
                var split = text.split_set (" ");
                if (split.length > 2) {
                    nodecall.set_text (split[2]);
                }
                add_text_to_console (text);
            } else {
                add_text_to_console (text);
            }
        });

        entry_commands.activate.connect (() => {
            connector.send (entry_commands.get_text ());
            entry_commands.set_text ("");
        });

        share_clicked.connect (() => {
            var share_window = new ShareWindow ();
            share_window.set_transient_for (this);
            share_window.show_all ();

            share_window.share_action.connect ((action) => {
                connector.send (action.to_string ());
            });
        });

        parser.rcvd_spot.connect ((s) => {
            add_spot_to_view (s.spotter, s.freq, s.dx, s.comment, s.utc);
        });

        show_all ();
    }

    private void set_main_menu() {
        var connect_action = new GLib.SimpleAction ("connect", null);
        connect_action.activate.connect (() => {
            var settings = Settings.instance ();
            connector.connect_async (settings.default_cluster_address, (int16) settings.default_cluster_port);
        });
        add_action (connect_action);

        var connect_to_action = new GLib.SimpleAction ("connect_to", null);
        connect_to_action.activate.connect (() => {
        });
        //add_action (connect_to_action);

        var disconnect_action = new GLib.SimpleAction ("disconnect", null);
        disconnect_action.activate.connect (() => {
            connector.disconnect_async ();
        });
        add_action (disconnect_action);
        disconnect_action.set_enabled (false);

        var filter_action = new GLib.SimpleAction ("spot_filter", null);
        filter_action.activate.connect (() => {
            var filter_window = new FilterWindow ();
            filter_window.set_transient_for (this);
            filter_window.show_all ();
        });
        add_action (filter_action);

        var builder = new Gtk.Builder.from_resource ("/org/ampr/ct1enq/gdx/ui/main-menu.ui");
        var menu_model = (GLib.MenuModel) builder.get_object ("main-menu");
        menu_button.set_menu_model (menu_model);
    }

    private void set_textbuffer () {
        Gtk.TextIter iter;
        textbuffer_console.get_end_iter (out iter);
        textbuffer_console.create_mark ("scroll", iter, false);
    }

    private void set_callbacks () {
        setup_auto_scroll_callbacks ();

        this.key_press_event.connect ((event) => {
            if (view == View.SPOTS) {
                if ((event.keyval >= Gdk.Key.@0 && event.keyval <= Gdk.Key.@9) ||
                    (event.keyval >= Gdk.Key.@KP_0 && event.keyval <= Gdk.Key.@KP_9) ||
                    (event.keyval >= Gdk.Key.a && event.keyval <= Gdk.Key.z) ||
                    (event.keyval >= Gdk.Key.A && event.keyval <= Gdk.Key.Z)) {

                    searchbar.set_search_mode (true);
                }

                return searchentry.handle_event (event);
            } else {
                return false;
            }
        });

        searchbutton.clicked.connect (() => {
            searchbar.search_mode_enabled = !searchbar.search_mode_enabled;
        });

        searchentry.search_changed.connect (() => {
            liststore_spots_with_filter.refilter ();
            stack_main.set_visible_child (scrolled_spots);
        });

        button_share.clicked.connect (() => {
            share_clicked ();
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

        stack_main.notify["visible-child"].connect ((s, p) => {
            var widget = stack_main.get_visible_child ();
            if (widget == scrolled_spots) {
                view = View.SPOTS;
            } else if (widget == grid1) {
                view = View.CONSOLE;
                set_console_need_attention (false);
            }
        });
    }

    private void setup_auto_scroll_callbacks () {
        var vscrollbar_spots = (Gtk.Scrollbar) scrolled_spots.get_vscrollbar ();

        vscrollbar_spots.value_changed.connect ( () => {
            var val = vscrollbar_spots.adjustment.@value;
            var upper = vscrollbar_spots.adjustment.upper - vscrollbar_spots.adjustment.page_size;
            if (val != upper) {
                scrolled_spots_moved = true;
            } else {
                scrolled_spots_moved = false;
            }
        });

        var vscrollbar_console = (Gtk.Scrollbar) scrolled_console.get_vscrollbar ();

        vscrollbar_console.value_changed.connect ( () => {
            var val = vscrollbar_console.adjustment.@value;
            var upper = vscrollbar_console.adjustment.upper - vscrollbar_console.adjustment.page_size;
            if (val != upper) {
                scrolled_console_moved = true;
            } else {
                scrolled_console_moved = false;
            }
        });
    }

    public void add_spot_to_view (string spotter, string freq, string dx, string comment, string utc) {
        Gtk.TreeIter iter;
        Gtk.ListStore store;

        store = liststore_spots;
        store.append (out iter);
        store.@set (iter, Col.SPOTTER, spotter, Col.FREQ, freq, Col.DX, dx, Col.COMMENT, comment, Col.UTC, utc);

        if (!searchbar.search_mode_enabled && !scrolled_spots_moved) {
            var path = new Gtk.TreePath.from_string (store.get_string_from_iter(iter));
            treeview_spots.scroll_to_cell (path, null, true, 0, 0);
        }
    }

    public void add_text_to_console (string text) {
        Gtk.TextIter iter;

        textbuffer_console.get_end_iter (out iter);
        textbuffer_console.insert (ref iter, "\n", 1);
        textbuffer_console.insert (ref iter, text, text.length);

        if (view == View.SPOTS) {
            set_console_need_attention (true);
        }

        // Must add on Idle otherwise won't move if a lot of text :/

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

    private void set_console_need_attention (bool need) {
        var val = Value (typeof(bool));
        val.set_boolean (need);
        stack_main.child_set_property (grid1, "needs-attention", val);
    }
}
