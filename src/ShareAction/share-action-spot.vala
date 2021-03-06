/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * share-action-spot.vala
 *
 */

public class ShareActionSpot : ShareAction {
    public string frequency;
    public string dx_station;
    public string comment;

    construct {
        @type = ShareAction.Type.SPOT;
    }

    public ShareActionSpot () {
    }

    public ShareActionSpot.with_data (string frequency, string dx_station, string comment) {
        this.frequency = frequency;
        this.dx_station = dx_station;
        this.comment = comment;
    }

    public override string to_string () {
        return "dx " + dx_station + " " + frequency + " " + comment;
    }
}

