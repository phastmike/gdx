/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * dx-spot.vala
 *
 * José Miguel Fonte
 */

public class DxSpot : Object {
    public string spotter {private set; get; default="";}
    public string freq {private set; get; default="";}
    public string dx {private set; get; default="";}
    public string comment {private set; get; default="";}
    public string utc {private set; get; default="";}
    public string qth {private set; get; default="";}

    public DxSpot.with_data (string spotter, string freq, string dx, string comment, string utc, string qth) {
        this.spotter = spotter;
        this.freq = freq;
        this.dx = dx;
        this.comment = comment;
        this.utc = utc;
        this.qth = qth; 
    }
}
