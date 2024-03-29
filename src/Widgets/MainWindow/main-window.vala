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
    public Gtk.Button button_go_bottom;
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
    private Gtk.ToggleButton searchbutton;
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
    private Gtk.Popover connection_popover;
    [GtkChild]
    private Gtk.MenuButton connection_menu_button;

    private Connector connector;
    private ParserConsole parser;
    private View view = View.SPOTS;
    private Gtk.TreeIter last_spot_iter;
    private AppNotification app_notification;

    public bool scrolled_spots_moved {set;get;default = false;}
    private bool scrolled_console_moved = false;

    public signal void share_clicked ();

    private enum View {
        SPOTS,
        CONSOLE
    }

    private enum SpotsViewColumn{
        SPOTTER,
        FREQ,
        DX,
        COMMENT,
        UTC
    }

    // IMPORTANT:
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

        connection_menu_button.set_popover (connection_popover);
        connection_popover.set_relative_to (connection_menu_button);
        searchbutton.bind_property ("active", searchbar, "search-mode-enabled", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);

        this.bind_property("scrolled-spots-moved", button_go_bottom, "sensitive", BindingFlags.SYNC_CREATE);

        connector.connection_established.connect (() => {
            button_share.sensitive = true;
            entry_commands.sensitive = true;
            var action = (SimpleAction) lookup_action ("disconnect");
            action.set_enabled (true);
            action = (SimpleAction) lookup_action ("connect");
            action.set_enabled (false);
            app_notification.present (_("You are now connected to") + " " + connector.last_host_address);
        });

        connector.connection_failed.connect ((err_msg) => {
            button_share.sensitive = false;
            entry_commands.sensitive = false;
            var action = (SimpleAction) lookup_action ("disconnect");
            action.set_enabled (false);
            action = (SimpleAction) lookup_action ("connect");
            action.set_enabled (true);
            app_notification.present (_("Connection to %s failed\n<small>%s</small>").printf (connector.last_host_address, err_msg));
        });

        connector.disconnected.connect (() => {
            button_share.sensitive = false;
            var action = (SimpleAction) lookup_action ("disconnect");
            action.set_enabled (false);
            action = (SimpleAction) lookup_action ("connect");
            action.set_enabled (true);
            app_notification.present (_("You are now disconnected"));
        });

        connector.received_message.connect ((text) => {
            // received text from connector is waiting for \r\n which login: does not send!
            // Now connector finds login: and sends it to handler.
            // FIXME: contains method may be misleading...

            /*
            if (text.contains ("login:")) {
                connector.send (settings.user_callsign);
            }
            */

            if (IParsable.text_get_type (text) == IParsable.MsgType.DX_REAL_SPOT) {
                parser.parse_spot (text);
                if (!settings.filter_spots_from_console) {
                    add_text_to_console (text, true);
                }
            } else if (IParsable.text_get_type (text) == IParsable.MsgType.PROMPT) {
                //entry_commands.set_text (text);
                var split = text.split_set (" ");
                if (split.length > 2) {
                    // got node call
                }
                add_text_to_console (text, true);
            } else {
                if (text.contains ("login:")) {
                    connector.send (settings.user_callsign);
                    add_text_to_console (text, false);
                } else {
                    add_text_to_console (text, true);
                }
            }
        });

        if (settings.auto_connect_startup) {
            app_notification.present (_("Connecting to") + " %s...".printf (settings.default_cluster_address));
            connector.connect_async.begin (settings.default_cluster_address, (int16) settings.default_cluster_port);
            //app_notification.present ("Connecting to %s...".printf (settings.default_cluster_address));
        }

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

        parser.rcvd_spot.connect ((spot) => {
            var band_filters = ((Application) get_application ()).warehouse.band_filters;

            if (band_filters.enabled) {
                foreach (RadioBandFilter filter in band_filters) { 
                    if (filter.enabled && filter.filter (new RadioFrequency.from_string (spot.freq))) {
                        add_spot_to_view (spot);
                        break;
                    }
                }
            } else {
                add_spot_to_view (spot);
            }
        });

        show_all ();
    }

    private void set_main_menu() {
        var connect_action = new GLib.SimpleAction ("connect", null);
        connect_action.activate.connect (() => {
            var settings = Settings.instance ();
            app_notification.present (_("Connecting to") + " %s...".printf (settings.default_cluster_address));
            connector.connect_async.begin (settings.default_cluster_address, (int16) settings.default_cluster_port);
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
            var filter_window = new FilterWindow (((Application) this.get_application ()).warehouse.band_filters);
            filter_window.set_transient_for (this);
            filter_window.show_all ();
        });
        add_action (filter_action);

        this.get_application ().set_accels_for_action ("win.connect", {"<Alt>C"});
        this.get_application ().set_accels_for_action ("win.disconnect", {"<Alt>D"});

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

                if (event.state != Gdk.ModifierType.MOD2_MASK && 
                    event.state != Gdk.ModifierType.LOCK_MASK && 
                    event.state != Gdk.ModifierType.SHIFT_MASK) {
                    return false;
                }

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

        searchentry.search_changed.connect (() => {
            liststore_spots_with_filter.refilter ();
            stack_main.set_visible_child (scrolled_spots);
        });

        button_share.clicked.connect (() => {
            share_clicked ();
        });

        liststore_spots_with_filter.set_visible_func ((model, iter) => {
            string dx;
            string entry_text;

            entry_text = searchentry.get_text ();

            return_val_if_fail (entry_text != "" || entry_text != null, true);

            model.get (iter, SpotsViewColumn.DX, out dx);

            if (dx == null) {
                return false;
            } else {
                return dx.up ().contains (searchentry.get_text ().up());
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
        button_go_bottom.clicked.connect (() => {
            Gtk.TreeIter iter = last_spot_iter;
            Gtk.ListStore store = liststore_spots;
            var path = new Gtk.TreePath.from_string (store.get_string_from_iter(iter));
            treeview_spots.scroll_to_cell (path, null, true, 0, 0);
        });


        var vscrollbar_spots = (Gtk.Scrollbar) scrolled_spots.get_vscrollbar ();

        vscrollbar_spots.size_allocate.connect ((allocation) => {
            var val = vscrollbar_spots.adjustment.@value;
            var upper = vscrollbar_spots.adjustment.upper - vscrollbar_spots.adjustment.page_size;
            if (val != upper) {
                scrolled_spots_moved = true;
            } else {
                scrolled_spots_moved = false;
            }
            treeview_spots.queue_draw ();
        });

        var vscrollbar_console = (Gtk.Scrollbar) scrolled_console.get_vscrollbar ();

        vscrollbar_console.value_changed.connect (() => {
            var val = vscrollbar_console.adjustment.@value;
            var upper = vscrollbar_console.adjustment.upper - vscrollbar_console.adjustment.page_size;
            if (val != upper) {
                scrolled_console_moved = true;
            } else {
                scrolled_console_moved = false;
            }
            treeview_spots.queue_draw ();
        });
    }

    public void add_spot_to_view (DxSpot spot) {
        Gtk.TreeIter iter;
        Gtk.ListStore store;
        
        store = liststore_spots;
        store.append (out iter);
        last_spot_iter = iter;
        store.@set (
            iter,
            SpotsViewColumn.SPOTTER, spot.spotter,
            SpotsViewColumn.FREQ, spot.freq,
            SpotsViewColumn.DX, spot.dx,
            SpotsViewColumn.COMMENT, spot.comment,
            SpotsViewColumn.UTC, spot.utc
        );

        if (!searchbar.search_mode_enabled && !scrolled_spots_moved) {
            var path = new Gtk.TreePath.from_string (store.get_string_from_iter(iter));
            treeview_spots.scroll_to_cell (path, null, true, 0, 0);
        }
    }

    public void add_text_to_console (string text, bool add_newline) {
        Gtk.TextIter iter;

        textbuffer_console.get_end_iter (out iter);
        if (add_newline) {
            textbuffer_console.insert (ref iter, "\n", 1);
        }
        textbuffer_console.insert (ref iter, text, text.length);

        if (view != View.CONSOLE) {
            set_console_need_attention (true);
        }

        // Must add on Idle otherwise won't move if a lot of text :/

        Idle.add (() => {
            textbuffer_console.get_end_iter (out iter);
            iter.set_line_index (0);
            var mark = textbuffer_console.get_mark ("scroll");
            textbuffer_console.move_mark (mark, iter);
            textview_console.scroll_mark_onscreen (mark);
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
