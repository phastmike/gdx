/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * share-action-spot.vala
 *
 */

public class ShareActionSpot : ShareAction {
    ShareAction.Type @type;
    public string frequency;
    public string dx_station;
    public string comment;

    public override ShareAction.Type get_action_type () {
        return @type;
    }

    construct {
        @type = ShareAction.Type.SPOT;
    }

    public ShareActionSpot () {
    }

    public override string to_string () {
        return "dx " + dx_station + " " + frequency + " " + comment;
    }

    public ShareActionSpot.with_data (string frequency, string dx_station, string comment) {
        this.frequency = frequency;
        this.dx_station = dx_station;
        this.comment = comment;
    }
}

