/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-share-action.vala
 *
 */

using Gtk;
using GLib;

public int main (string args[]) {
    var spot = new ShareActionSpot ();
    var annc = new ShareActionAnnouncement ();

    assert (spot.get_action_type () == ShareAction.Type.SPOT);
    assert (annc.get_action_type () == ShareAction.Type.ANNOUNCEMENT);
    assert (spot.to_string () == "dx   ");
    assert (annc.to_string () == "announce ");

    var spot1 = new ShareActionSpot.with_data ("14005.3", "D44C", "No takers...");
    assert (spot1.to_string () == "dx D44C 14005.3 No takers...");

    var ann1 = new ShareActionAnnouncement.with_data (ShareActionAnnouncement.Range.LOCAL, "This is a local test");
    assert (ann1.to_string () == "announce This is a local test");

    var ann2 = new ShareActionAnnouncement.with_data (ShareActionAnnouncement.Range.GLOBAL, "This is a global test");
    assert (ann2.to_string () == "announce full This is a global test");


    return 0;
}
