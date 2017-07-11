/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * dx-spot.vala
 *
 * Copyright (C) 2017 José Miguel Fonte
 */

public class DxSpot : Object {
    public string spotter;
    public string freq;
    public string dx;
    public string comment;
    public string utc;
    public string qth;

    public DxSpot () {
        this.spotter = "";
        this.freq = "";
        this.dx = "";
        this.comment = "";
        this.utc = "";
        this.qth = ""; 
    }

    public DxSpot.with_data (string spotter, string freq, string dx, string comment, string utc, string qth) {
        this.spotter = spotter;
        this.freq = freq;
        this.dx = dx;
        this.comment = comment;
        this.utc = utc;
        this.qth = qth; 
    }
}
