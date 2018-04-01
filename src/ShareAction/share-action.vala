/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * share-action.vala
 *
 */

public abstract class ShareAction : Object {
    protected Type @type;

    public enum Type {
        SPOT,
        ANNOUNCEMENT
    }

    public Type get_action_type () {
        return @type;
    }

    public abstract string to_string ();
}
