/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * settings-window.vala
 *
 * José Miguel Fonte
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/ui/app-notification.ui")]
public class AppNotification: Gtk.Revealer {
    [GtkChild]
    private Gtk.Label label;
    [GtkChild]
    private Gtk.Button close_button;

    private uint timeout_id;
    public int timeout_seconds {get; set; default = 10;}

    public AppNotification () {
        label.set_use_markup (true);

        close_button.clicked.connect (() => {
            dismiss ();
        });

        show_all ();
    }

    public void present (string message) {
        dismiss ();
        label.set_markup ("<b>" + message + "</b>");
        reveal ();
    }

    private void reveal () {
        base.set_reveal_child (true);
        timeout_id = Timeout.add_seconds (timeout_seconds, () => {
            base.set_reveal_child (false);
            return Source.REMOVE;
        });
    }

    private void dismiss () {
        base.set_reveal_child (false);
        if (timeout_id != 0) {
            Source.remove (timeout_id);
        }
    }
} 
