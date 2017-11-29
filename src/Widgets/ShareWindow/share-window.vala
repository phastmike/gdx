/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * share-window.vala
 *
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/share-window.ui")]
public class ShareWindow : Gtk.Window {
    [GtkChild]
    private Gtk.HeaderBar headerbar;
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

    View view = View.SPOT;

    private enum View {
        SPOT,
        ANNOUNCE
    }

    public enum AnnounceRange {
        LOCAL,
        GLOBAL
    }

    public signal void cancelled ();
    public signal void share_action (ShareAction action);

    public ShareWindow () {
        Object (default_width: 400, default_height: 200);
        set_titlebar (headerbar);
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
            } else {
                warning_icon.set_visible (false);
                label_info_range.set_visible (false);
            }
        });

        stack1.notify["visible-child"].connect ((s, p) => {
            var widget = stack1.get_visible_child ();
            if (widget == announce_grid) {
                view = View.ANNOUNCE; 
                print ("ANNOUNCE\n");
            } else if (widget == spot_grid) {
                view = View.SPOT;
                print ("SPOTS\n");
            }

            check_enable_share ();
        });

        button_cancel.clicked.connect (() => {
            cancelled ();
            this.destroy ();
        });

        button_share.clicked.connect (() => {
            if (view == View.SPOT) {
                var freq = input_freq.get_value ().to_string ();
                var dx_station = input_dx.get_text ();
                var comment = input_comment.get_text ();
                var share_spot = new ShareActionSpot.with_data (freq, dx_station, comment);
                share_action (share_spot);
            } else if (view == View.ANNOUNCE) {
                var range = (ShareActionAnnouncement.Range) range_selection.get_active ();
                var message = entry_message.get_text ();
                var share_announcement = new ShareActionAnnouncement.with_data (range, message);
                share_action (share_announcement);
            }
            
            this.destroy ();
        });

        entry_message.changed.connect (() => {
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
            return entry_message.text_length >= 1;
        }

        return false;
    }
}
