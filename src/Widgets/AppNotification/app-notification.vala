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

    public AppNotification () {

        close_button.clicked.connect (() => {
            set_reveal_child (false);
        });

        show_all ();
    }

    public void set_message (string message) {
        label.set_text (message);
    }
} 
