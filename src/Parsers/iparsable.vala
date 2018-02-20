/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * iparsable.vala
 * 
 */

public interface IParsable : GLib.Object {
    public enum MsgType {
        UNKNOWN,
        PROMPT,
        NORMAL_TEXT,
        DX_REAL_SPOT,
        WWV,
        WCY,
        ANN,
        MESSAGE,
        PC_PROTOCOL,
    }

    public static MsgType text_get_type (string text) {
        if (text.has_prefix("PC")) {
            return MsgType.PC_PROTOCOL;
        }
        if (text.has_prefix ("DX de ")) {
            return MsgType.DX_REAL_SPOT;
        }
        if (text.has_prefix ("WWV de ")) {
            return MsgType.WWV;
        }
        if (text.has_prefix ("WCY de ")) {
            return MsgType.WCY;
        }
        if (text.has_prefix ("To ")) {
            return MsgType.ANN;
        }
        if (text.has_prefix (Settings.instance ().user_callsign + " de ") &&
            text.has_suffix (" >")) {
            return MsgType.PROMPT;
        }

        return MsgType.UNKNOWN;
    }

    public signal void rcvd_spot (DxSpot spot);
    public abstract void parse_spot (string text);
}
