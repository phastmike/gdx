/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * main-window.vala
 *
 * Jose Miguel Fonte, 2017
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/share-window.ui")]
public class ShareWindow : Gtk.Window {
    View view = View.SPOT; 
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
    [GtkChild]
    private Gtk.Entry entry_node;

    private enum View {
        SPOT,
        ANNOUNCE
    }

    public enum AnnounceRange {
        LOCAL,
        NODE,
        GLOBAL
    }

    public signal void cancelled ();
    public signal void spot (string freq, string dx_station, string comment);
    public signal void announcement (AnnounceRange range, string? node, string message);

    public ShareWindow () {
        Object (default_width: 400, default_height: 200);
        set_titlebar (headerbar1);
        setup_callbacks ();
    }

    private void setup_callbacks () {
        input_dx.icon_press.connect ((position, event) => {
            if (event.button.button == 1 && position == Gtk.EntryIconPosition.SECONDARY) {
                input_dx.text = ""; 
            }
        });

        input_comment.icon_press.connect ((position, event) => {
            if (event.button.button == 1 && position == Gtk.EntryIconPosition.SECONDARY) {
                input_comment.text = ""; 
            }
        });

        entry_message.icon_press.connect ((position, event) => {
            if (event.button.button == 1 && position == Gtk.EntryIconPosition.SECONDARY) {
                entry_message.text = ""; 
            }
        });

        range_selection.changed.connect (() => {
            check_enable_share ();
            if (range_selection.get_active () == AnnounceRange.GLOBAL) {
                warning_icon.set_visible (true);
                label_info_range.set_visible (true);
                entry_node.set_visible (false);
            } else {
                warning_icon.set_visible (false);
                label_info_range.set_visible (false);
                if (range_selection.get_active () == AnnounceRange.NODE) {
                    entry_node.set_visible (true);
                } else {
                    entry_node.set_visible (false);
                }
            }
        });

        stack1.set_focus_child.connect ((widget) => {
            if (widget == announce_grid) {
                view = View.ANNOUNCE; 
            } else if (widget == spot_grid) {
                view = View.SPOT;
            }

            check_enable_share ();
        });

        button_cancel.clicked.connect (() => {
            cancelled ();
            this.destroy ();
        });

        button_share.clicked.connect (() => {
            if (view == View.SPOT) {
                spot (input_freq.get_value ().to_string (), input_dx.get_text (), input_comment.get_text ());
            } else if (view == View.ANNOUNCE) {
                string? node = null;
                AnnounceRange range;

                range = (AnnounceRange) range_selection.get_active (); 
                
                if (range == AnnounceRange.NODE) {
                    node = entry_node.text;
                } 

                announcement (range, node, entry_message.get_text ());
            }

            this.destroy ();
            
        });

        entry_message.changed.connect (() => {
            check_enable_share ();
        });

        entry_node.changed.connect (() => {
            check_enable_share ();
        });

        input_freq.value_changed.connect (() => {
            check_enable_share ();
        });

        input_dx.changed.connect (() => {
            check_enable_share ();
        });
    }

    private void check_enable_share () {
        button_share.set_sensitive (entries_have_data ());
    }

    private bool entries_have_data () {
        if (view == View.SPOT) {
            return (input_freq.@value > 0.0 && input_dx.text_length > 1);
        } else if (view == View.ANNOUNCE) {
            if (range_selection.get_active () == AnnounceRange.NODE) {
                if (entry_node.text.length > 3) {
                    return entry_message.text_length >= 1;
                } else {
                    return false;
                }
            } else {
                return entry_message.text_length >= 1;
            }
        }

        return false;
    }
}
