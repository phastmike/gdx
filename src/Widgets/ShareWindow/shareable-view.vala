/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * shareable-view.vala
 *
 */

public interface ShareableView: Object {
    //public signal void data_changed (bool has_data)
    public abstract bool entries_have_data ();
    public abstract ShareAction get_share_action();
}
