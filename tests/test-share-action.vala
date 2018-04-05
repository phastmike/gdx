/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-share-action.vala
 *
 */

using Gtk;

public int main (string args[]) {
    // Create instances
    var spot = new ShareActionSpot ();
    var ann = new ShareActionAnnouncement ();

    // print action types
    print ("spot: %s\n", spot.get_action_type ().to_string ());
    print ("annc: %s\n", ann.get_action_type ().to_string ());

    // print result of raw actions without data
    print ("spot: %s\n", spot.to_string ());
    print ("annc: %s\n", ann.to_string ());

    // test a "normal" spot
    var spot1 = new ShareActionSpot.with_data ("14005.3", "D44C", "No takers...");
    print ("spot1: %s\n", spot1.to_string ());

    // test a "normal" announcement local/global
    var ann1 = new ShareActionAnnouncement.with_data (ShareActionAnnouncement.Range.LOCAL, "This is a local test");
    print ("ann1: %s\n", ann1.to_string ());

    var ann2 = new ShareActionAnnouncement.with_data (ShareActionAnnouncement.Range.GLOBAL, "This is a global test");
    print ("ann2: %s\n", ann2.to_string ());


    return 0;
}
