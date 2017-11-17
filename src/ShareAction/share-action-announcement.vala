/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * share-action-announcement.vala
 *
 */

public class ShareActionAnnouncement : ShareAction {
    ShareAction.Type @type;
    public Range range;
    public string message;

    public enum Range {
        LOCAL,
        GLOBAL
    }

    public override ShareAction.Type get_action_type () {
        return @type;
    }

    construct {
        @type = ShareAction.Type.ANNOUNCEMENT;
    }

    public ShareActionAnnouncement () {

    }

    public ShareActionAnnouncement.with_data (Range range, string message) {
        this.range = range;
        this.message = message;
    }
}

