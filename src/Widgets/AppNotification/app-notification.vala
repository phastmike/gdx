/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * settings-window.vala
 *
 * José Miguel Fonte
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/app-notification.ui")]
public class AppNotification: Gtk.Revealer {
    private uint timeout_id;
    public int timeout_seconds;
    [GtkChild]
    private Gtk.Label label;
    [GtkChild]
    private Gtk.Button close_button;

    public AppNotification () {
        timeout_seconds = 10;

        label.set_use_markup (true);

        close_button.clicked.connect (() => {
            set_reveal_child (false);
            Source.remove (timeout_id);
        });

        show_all ();
    }

    public new void set_reveal_child (bool reveal_child) {
        base.set_reveal_child (reveal_child);

        if (reveal_child == true) {
            timeout_id = Timeout.add_seconds (timeout_seconds, () => {
                set_reveal_child (false);
                return false;
            });
        }
    }

    public void set_message (string message) {
        label.set_markup ("<b>" + message + "</b>");
    }
} 
