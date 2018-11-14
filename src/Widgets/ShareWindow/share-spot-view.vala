/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * share-spot-view.vala
 *
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/share-spot-view.ui")]
public class ShareSpotView : Gtk.Window, ShareableView {
    [GtkChild]
    private Gtk.Entry input_freq;
    [GtkChild]
    private Gtk.Entry input_dx;
    [GtkChild]
    private Gtk.Entry input_comment;

    construct {
        input_freq.icon_press.connect ((position, event) => {
            on_entry_button_press (input_freq, position, event);
        });

        input_dx.icon_press.connect ((position, event) => {
            on_entry_button_press (input_dx, position, event);
        });

        input_comment.icon_press.connect ((position, event) => {
            on_entry_button_press (input_comment, position, event);
        });

        input_freq.key_press_event.connect ((event) => {
            var key = event.keyval;

            if ((key == Gdk.Key.Tab) ||
                (key >= Gdk.Key.@0 && key <= Gdk.Key.@9) ||
                (key >= Gdk.Key.KP_0 && key <= Gdk.Key.KP_9) ||
                (key == Gdk.Key.KP_Decimal) || (key == Gdk.Key.period) ||
                (key == Gdk.Key.BackSpace || key == Gdk.Key.Delete || key == Gdk.Key.KP_Delete) ||
                (key == Gdk.Key.Return) || (key == Gdk.Key.KP_Enter) ||
                (key == Gdk.Key.Left || key == Gdk.Key.Right || key == Gdk.Key.Home || key == Gdk.Key.End) ||
                (key == Gdk.Key.KP_Left || key == Gdk.Key.KP_Right || key == Gdk.Key.KP_Home || key == Gdk.Key.KP_End)) {
                return false;
            }

            return true;
        });

        input_freq.changed.connect (() => {
            //check_enable_share ();
            handle_entry_delete_icon (input_freq);
        });

        input_dx.changed.connect (() => {
            //check_enable_share ();
            handle_entry_delete_icon (input_dx);
        });

        input_comment.changed.connect (() => {
            handle_entry_delete_icon (input_comment);
        });
    }

    private void on_entry_button_press (Gtk.Entry entry, Gtk.EntryIconPosition position, Gdk.Event event) {
        if (event.button.button == 1 && position == Gtk.EntryIconPosition.SECONDARY) {
            entry.set_text ("");
        }
    }

    private void handle_entry_delete_icon (Gtk.Entry entry) {
        var text_length = entry.get_text ().length;

        switch (text_length) {
            case 0:
                entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "");
                break;
            case 1:
                entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
                break;
            default:
                break;
        }
    }

    public ShareAction get_share_action() {
        var freq = input_freq.get_text ();
        var dx_station = input_dx.get_text ();
        var comment = input_comment.get_text ();
        return new ShareActionSpot.with_data (freq, dx_station, comment);
    }

    public bool entries_have_data () {
        return (double.parse (input_freq.get_text ()) > 0.0 && input_dx.text_length > 1);
    }
}
