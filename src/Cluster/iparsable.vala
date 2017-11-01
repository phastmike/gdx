/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * iparsable.vala
 * 
 */

public interface IParsable : GLib.Object {
    public signal void rcvd_spot (DxSpot spot);
    public abstract void parse_spot (string text);
}
