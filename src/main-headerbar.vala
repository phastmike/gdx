/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * main-headerbar.vala
 *
 * Jose Miguel Fonte, 2017
 */

[GtkTemplate (ui = "/org/ampr/ct1enq/gdx/main-headerbar.ui")]
public class MainHeaderBar : Gtk.HeaderBar {
    public MainHeaderBar () {
        show_all ();
    }
}
