/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * main-window.vala
 *
 * Jose Miguel Fonte, 2017
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/share-window.ui")]
public class ShareWindow : Gtk.Window {
    [GtkChild]
    private Gtk.HeaderBar headerbar1;
    [GtkChild]
    private Gtk.Stack stack1;
    [GtkChild]
    private Gtk.Grid spot_grid;
    [GtkChild]
    private Gtk.Grid announce_grid;
    [GtkChild]
    private Gtk.Button button_share;
    [GtkChild]
    private Gtk.Button button_cancel;
    [GtkChild]
    private Gtk.SpinButton input_freq;
    [GtkChild]
    private Gtk.Entry input_dx;
    [GtkChild]
    private Gtk.Entry input_comment;
    [GtkChild]
    private Gtk.ComboBoxText range_selection;
    [GtkChild]
    private Gtk.Entry entry_message;
    [GtkChild]
    private Gtk.Label label_info_range;
    [GtkChild]
    private Gtk.Image warning_icon;

    private enum View {
        SPOT,
        ANNOUNCE
    }

    View view = View.SPOT; 

    enum AnnounceRange {
        LOCAL,
        GLOBAL
    }

    enum SharePage {
        UNKNOWN = -1,
        SPOT,
        ANNOUNCE
    }

    public signal void cancelled ();
    public signal void spot (string freq, string dx_station, string comment);
    public signal void announcement (bool global, string message);

    public ShareWindow () {
        Object (default_width: 400, default_height: 200);
        set_titlebar (headerbar1);
        setup_callbacks ();
    }

    private void setup_callbacks () {
        range_selection.changed.connect (() => {
            if (range_selection.get_active () == AnnounceRange.GLOBAL) {
                warning_icon.set_visible (true);
                label_info_range.set_visible (true);
            } else {
                warning_icon.set_visible (false);
                label_info_range.set_visible (false);
            }
        });

        stack1.set_focus_child.connect ((widget) => {
            if (widget == announce_grid) {
                print ("SET FOCUS CHILD ANNOUNCE\n");
                view = View.ANNOUNCE; 
            } else if (widget == spot_grid) {
                print ("SET FOCUS CHILD SPOT\n");
                view = View.SPOT;
            }
        });

        button_cancel.clicked.connect (() => {
            cancelled ();
            this.destroy ();
        });

        button_share.clicked.connect (() => {
            if (get_page_id () == SharePage.SPOT) {
                spot (input_freq.get_value ().to_string (), input_dx.get_text (), input_comment.get_text ());
            } else if (get_page_id () == SharePage.ANNOUNCE) {
                bool global = false;

                if (range_selection.get_active () == AnnounceRange.GLOBAL) {
                    global = true;
                }

                announcement (global, entry_message.get_text ());
                print ("ANNOUNCEMENT GLOBAL: %s | MSG: %s\n", global.to_string (), entry_message.get_text ());
            }

            this.destroy ();
            
        });

        input_freq.value_changed.connect (() => {
            button_share.set_sensitive (entries_have_data ());
        });

        input_dx.key_release_event.connect ((event) => {
            button_share.set_sensitive (entries_have_data ());
            return false;
        });
    }

    private bool entries_have_data () {
        return (input_freq.@value > 0.0 && input_dx.text_length > 1);
    }

    private SharePage get_page_id () {
        if (stack1.visible_child == spot_grid) {
            return SharePage.SPOT;
        } else if (stack1.visible_child == announce_grid) {
            return SharePage.ANNOUNCE;
        }

        return SharePage.UNKNOWN;
    } 
}
