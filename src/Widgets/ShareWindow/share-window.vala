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
    private Gtk.Stack stack;
    [GtkChild]
    private Gtk.Button button_share;
    [GtkChild]
    private Gtk.Button button_cancel;

    public signal void cancelled ();
    public signal void share_action (ShareAction action);

    public ShareWindow () {
        Object (default_width: 440, default_height: 220);
        set_titlebar (headerbar);
        setup_callbacks ();

        var share_spots_view = new ShareSpotView ();
        stack.add_titled (share_spots_view, "child1", "DX Spot");
        share_spots_view.data_changed.connect (() => {
           check_enable_share();
        });

        var share_announce_view = new ShareAnnouncementView ();
        stack.add_titled (share_announce_view, "child2", "Announce");
        share_announce_view.data_changed.connect (() => {
           check_enable_share();
        });
    }

    private void setup_callbacks () {
        stack.notify["visible-child"].connect ((s, p) => {
            check_enable_share ();
        });

        button_cancel.clicked.connect (() => {
            cancelled ();
            this.destroy ();
        });

        button_share.clicked.connect (() => {
            ShareableView view = stack.get_visible_child () as ShareableView;
            share_action (view.get_share_action ());
            
            this.destroy ();
        });
    }

    private void check_enable_share () {
        ShareableView view = stack.get_visible_child () as ShareableView;
        button_share.set_sensitive (view.entries_have_data ());
    }
}
