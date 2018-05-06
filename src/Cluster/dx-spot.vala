/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * dx-spot.vala
 *
 * José Miguel Fonte
 */

public class DxSpotBuilder : Object {
    public string spotter {private set; get; default="";}
    public string frequency {private set; get; default="";}
    public string dx {private set; get; default="";}
    public string comment {private set; get; default="";}
    public string utc {private set; get; default="";}
    public string qth {private set; get; default="";}
    

    public DxSpotBuilder add_spotter (string spotter) {
        this.spotter = spotter;
        return this;
    }

    public DxSpotBuilder add_frequency (string frequency) {
        this.frequency = frequency;
        return this;
    }    

    public DxSpotBuilder add_dx (string dx) {
        this.dx = dx;
        return this;
    }

    public DxSpotBuilder add_comment (string comment) {
        this.comment = comment;
        return this;
    }

    public DxSpotBuilder add_utc (string utc) {
        this.utc = utc;
        return this;
    }

    public DxSpotBuilder add_qth (string qth) {
        this.qth = qth;
        return this;
    }

    public DxSpot build () {
        return new DxSpot.with_builder (this);
    } 
}

public class DxSpot : Object {
    public string spotter {private set; get; default="";}
    public string freq {private set; get; default="";}
    public string dx {private set; get; default="";}
    public string comment {private set; get; default="";}
    public string utc {private set; get; default="";}
    public string qth {private set; get; default="";}


    public DxSpot.with_builder (DxSpotBuilder builder) {
        this.spotter = builder.spotter;
        this.freq = builder.frequency;
        this.dx = builder.dx;
        this.comment = builder.comment;
        this.utc = builder.utc;
        this.qth = builder.qth;
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
