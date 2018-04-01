/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * share-action-announcement.vala
 *
 */

public class ShareActionAnnouncement : ShareAction {
    public Range range;
    public string message;

    public enum Range {
        LOCAL,
        GLOBAL
    }

    construct {
        range = Range.LOCAL;
        @type = ShareAction.Type.ANNOUNCEMENT;
    }

    public ShareActionAnnouncement () {

    }

    public ShareActionAnnouncement.with_data (Range range, string message) {
        this.range = range;
        this.message = message;
    }

    public override string to_string () {
        string message;

        if (range == Range.LOCAL) {
            message = "announce " + this.message;
        } else {
            message = "announce full " + this.message;
        }

        return message;
    }
}

