/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * parser-console.vala
 *
 */

public class ParserConsole : Object, IParsable {
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

    public void parse_spot (string text) {
        string utc = "";
        string qth = "";
        string comment = "";
        string s = text.substring (0, text.length); // remove \r\n

        if (!text.validate (-1, null)) return;

        while (s.contains ("  ")) {
            s = s.replace ("  ", " ");
        } 

        var split = s.split_set (" ");

        int length = split.length;

        foreach (string token in split) {
            print ("[%s]  ", token);
        }
        print ("\n");

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

        var spotter = split[2].replace (":", "");
        var freq = split[3];
        var dx = split[4];

        if (utc.length == 5) {
            utc = "%c%c:%c%c".printf (utc[0], utc[1], utc[2], utc[3]);
        }

        rcvd_spot (new DxSpot.with_data (spotter, freq, dx, comment, utc, qth));
    }
} 
