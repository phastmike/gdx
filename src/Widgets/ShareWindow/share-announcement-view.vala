/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * share-announcement-view.vala
 *
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/share-announcement-view.ui")]
public class ShareAnnouncementView: Gtk.Window, ShareableView {
    private Gtk.ComboBoxText range_selection;
    [GtkChild]
    private Gtk.Entry entry_message;
    [GtkChild]
    private Gtk.Label label_info_range;
    [GtkChild]
    private Gtk.Image warning_icon;

    construct {
        entry_message.icon_press.connect ((position, event) => {
            on_entry_button_press (entry_message, position, event);
        });

        entry_message.changed.connect (() => {
            //check_enable_share ();
            handle_entry_delete_icon (entry_message);

        });

        range_selection.changed.connect (() => {
            entries_have_data ();
            if (range_selection.get_active () == ShareActionAnnouncement.Range.GLOBAL) {
                warning_icon.set_visible (true);
                label_info_range.set_visible (true);
            } else {
                warning_icon.set_visible (false);
                label_info_range.set_visible (false);
            }
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
        var range = (ShareActionAnnouncement.Range) range_selection.get_active ();
        var message = entry_message.get_text ();
        return new ShareActionAnnouncement.with_data (range, message);
    }

    private bool entries_have_data () {
        return entry_message.text_length >= 1;
    }

}
