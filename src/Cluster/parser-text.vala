/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * parser-text.vala
 *
 * Copyright (C) 2017 José Miguel Fonte
 */

public class Parser : Object, IParsable {
    public enum MsgType{
        UNKNOWN,
        PROMPT,
        NORMAL_TEXT,
        DX_REAL_SPOT,
        WWV,
        WCY,
        ANN,
        MESSAGE,
        PC_PROTOCOL
    }

    //public signal void rcvd_spot (DxSpot spot);
 
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

        return MsgType.UNKNOWN;
    } 

    public Parser () {

    }

    public void parse_spot (string text) {
        string utc = "";
        string qth = "";
        string comment = "";
        string s = text.substring (0, text.length); // remove \r\n

        if (!text.validate (-1, null)) return;

        while (s.contains ("  ")) {
            s = s.replace ("  ", " ");
        } 

        var split = s.split_set (" :");

        int length = split.length;

        if (length < 6) return;

        if (split[length - 1].@get(4) == 'Z') {
            utc = split[length - 1];
            foreach (string c in split[6:length-1]) {
                comment += " " + c;
            }
        } else if (split[length - 2].@get(4) == 'Z') {
            utc = split[length - 2];
            qth = split[length - 1];
            foreach (string c in split[6:length-2]) {
                comment += " " + c;
            }
        } else {
            // Something is wrong, what should i do?!
        }
        
        comment = comment.strip ().compress ();

        if (!comment.validate ()) {
            comment = "<invalid utf8 data in comment>";
        }

        var spotter = split[2];
        var freq = split[4];
        var dx = split[5];

        rcvd_spot (new DxSpot.with_data (spotter, freq, dx, comment, utc, qth));
    }
} 
